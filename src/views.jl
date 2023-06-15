using Printf
using Genie
using Genie.Renderer,
    Genie.Renderer.Html,
    Genie.Renderer.Json,
    Genie.Requests,
    Genie.Responses,
    Genie.Assets,
    Genie.WebChannels
using CSV, DataFrames, Distributed, UUIDs
using HTTP

"""
    home_view()

The function handles the home page view. Returns a simple HTML string "ModelSelectionGUI".
"""
function home_view()
    html("ModelSelectionGUI")
end

"""
    server_info_view()

Returns information about the server.

# Returns
- A JSON object with the server information.
"""
function server_info_view()
    return server_info_response(
        Sys.CPU_THREADS,
        nworkers(),
        string(MODEL_SELECTION_VER),
        string(VERSION),
        get_jobs_queue_length(),
    )
end

"""
    upload_file_view()

Uploads a CSV file to the server. Upon successful upload, the server will process the uploaded file for further operations.

# Returns
- A JSON object with information about the saved file.
"""
function upload_file_view()
    if !infilespayload(:data)
        return bad_request_exception(FILE_NOT_SENT)
    end

    payload_file = filespayload(:data)

    if payload_file.mime != CSV_MIME
        return bad_request_exception(INVALID_CSV)
    end

    data = try
        CSV.read(IOBuffer(payload_file.data), DataFrame)
    catch
        return bad_request_exception(INVALID_CSV)
    end

    filehash = string(uuid4())

    tempfile = try
        name = tempname()
        save_tempfile(name, data)
        name
    catch
        throw(Genie.Exceptions.InternalServerException(FILE_NOT_SAVED))
    end
    filename = payload_file.name
    add_job_file(filehash, tempfile, filename)
    return upload_response(filename, filehash, names(data), size(data, 1))
end

"""
    job_enqueue_view()

Enqueues a model selection job for the specified file. The task will be executed after the previously queued tasks have finished.

# Returns
- A JSON object with information about the created job.
"""
function job_enqueue_view()
    filehash = get_request_filehash(params)
    file = get_job_file(filehash)

    if file === nothing
        return bad_request_exception(@sprintf("The filehash '%s' is not valid", filehash))  # FIXME: Move to constant FILEHASH_NOT_VALID
    end

    if !isfile(file[TEMP_FILENAME])
        return bad_request_exception(FILE_NOT_FOUND)
    end

    payload = jsonpayload()

    if !haskey(payload, String(ESTIMATOR))
        return bad_request_exception(ESTIMATOR_MISSING)
    end

    if !haskey(payload, String(EQUATION))
        return bad_request_exception(ESTIMATOR_MISSING)
    end

    parameters = get_parameters(payload)

    job = ModelSelectionJob(
        String(file[FILENAME]),
        String(file[TEMP_FILENAME]),
        String(filehash),
        parameters,
    )
    enqueue_job(job)

    return job_info_response(job)
end

"""
    job_info_view()

Returns the info of a model selection job. If the job is finished, it also includes the summary of a model selection job.

# Returns
- A JSON object with information about the selected job.
"""
function job_info_view()
    global jobs_finished
    id = get_request_job_id(params)
    job = get_job(id)
    if job === nothing
        return bad_request_exception(@sprintf("The job with id '%s' does not exists", id))  # FIXME: Move to constant MISSING_JOB_ID
    end
    return job_info_response(job)
end

"""
job_results_view()

Returns the result file of a specific type for a model selection job.

# Returns
- A text file with the selected result.
"""
function job_results_view()
    global jobs_finished
    id = get_request_job_id(params)
    job = get_job_finished(id)
    if job === nothing
        return bad_request_exception(@sprintf("The job with id '%s' does not exists", id))  # FIXME: Move to constant MISSING_JOB_ID
    end

    resulttype = try
        Symbol(params(:resulttype))
    catch
        return bad_request_exception(MISSING_RESULT_TYPE)
    end

    if !(resulttype in AVAILABLE_RESULTS_TYPES)
        return bad_request_exception(
            @sprintf(
                "The result type '%s' is not valid. [Available result types: %s]",
                resulttype,
                join(AVAILABLE_RESULTS_TYPES, ", ")
            )
        )  # FIXME: Move to constant INVALID_RESULT_TYPE
    end

    return job_results_response(job, resulttype)
end

"""
    websocket_channel_view()

The function handles the view for WebSocket channel subscriptions. 
It subscribes the client to the default WebSocket channel and returns a confirmation string.
"""
function websocket_channel_view()
    WebChannels.subscribe(Genie.Requests.wsclient(), string(DEFAULT_WS_CHANNEL))
    return "Subscription: OK"
end
