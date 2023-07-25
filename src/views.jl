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
using SwagUI

swagger_options = Options()
swagger_options.show_explorer = false
swagger_document = JSON.parsefile(SWAGGER_DOCUMENT_FILE)
frontend_file = read(FRONTEND_FILE, String)

"""
    home_view()

The function handles the home page view. Returns a simple HTML string "ModelSelectionGUI".

# Returns
- `HTTP.Response`: A simple HTML string "ModelSelectionGUI".
"""
function home_view()
    html(frontend_file)
end

"""
    docs_view()

The functions render the Swagger UI documentation of the API from the `swagger_document` data.

# Returns
- `HTTP.Response`: A page with the swagger documentation.
"""
function docs_view()
    render_swagger(swagger_document, options = swagger_options)
end

"""
    server_info_view()

Returns information about the server.

# Returns
- `HTTP.Response`: A JSON response with the server information.
"""
function server_info_view()
    return server_info_response(
        Sys.CPU_THREADS,
        nworkers(),
        string(MODEL_SELECTION_VER),
        string(VERSION),
        get_pending_queue_length(),
    )
end

"""
    estimators_view()

Get a view of all available estimators. This function returns a view of all available estimators from the ModelSelection.AllSubsetRegression module.

# Returns
- `response::String`: A JSON string representation of the estimators.

# Returns
- `HTTP.Response`: A JSON response with the server information.
"""
function estimators_view()
    estimators = ModelSelection.AllSubsetRegression.ESTIMATORS
    return estimators_response(estimators)
end

"""
    upload_file_view()

Uploads a CSV file to the server. Upon successful upload, the server will process the uploaded file for further operations.

# Returns
- `HTTP.Response`: A JSON response with information about the saved file.
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
- `HTTP.Response`: A JSON response with information about the created job.
"""
function job_enqueue_view()
    filehash = get_request_filehash(params)
    file = get_job_file(filehash)

    if file === nothing
        return bad_request_exception(
            FILEHASH_NOT_VALID[1] * filehash * FILEHASH_NOT_VALID[2],
        )
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
    estimator = Symbol(parameters[ESTIMATOR])
    equation = parameters[EQUATION]
    delete!(parameters, ESTIMATOR)
    delete!(parameters, EQUATION)

    job = ModelSelectionJob(
        String(file[FILENAME]),
        String(file[TEMP_FILENAME]),
        String(filehash),
        estimator,
        equation,
        parameters,
    )
    add_pending_job(job)

    return job_info_response(job)
end

"""
    job_info_view()

Returns the info of a model selection job. If the job is finished, it also includes the summary of a model selection job.

# Returns
- `HTTP.Response`: A JSON response with information about the selected job.
"""
function job_info_view()
    global jobs_finished
    id = get_request_job_id(params)
    job = get_job(id)
    if job === nothing
        return bad_request_exception(MISSING_JOB_ID[1] * id * MISSING_JOB_ID[2])
    end
    return job_info_response(job)
end

"""
job_results_view()

Returns the result file of a specific type for a model selection job.

# Returns
- `HTTP.Response`: A text file with the selected result.
"""
function job_results_view()
    global jobs_finished
    id = get_request_job_id(params)
    job = get_finished_job(id)
    if job === nothing
        return bad_request_exception(MISSING_JOB_ID[1] * id * MISSING_JOB_ID[2])
    end
    resulttype = try
        Symbol(params(:resulttype))
    catch
        return bad_request_exception(MISSING_RESULT_TYPE)
    end

    if !(resulttype in AVAILABLE_RESULTS_TYPES)
        return bad_request_exception(
            INVALID_RESULT_TYPE[1] *
            string(resulttype) *
            INVALID_RESULT_TYPE[2] *
            join(AVAILABLE_RESULTS_TYPES, ", "),
        )
    end

    return job_results_response(job, resulttype)
end

"""
    websocket_channel_view()

The function handles the view for WebSocket channel subscriptions. 
It subscribes the client to the default WebSocket channel and returns a confirmation string.

# Returns
- `String`: A confirmation string.
"""
function websocket_channel_view()
    WebChannels.subscribe(Genie.Requests.wsclient(), string(DEFAULT_WS_CHANNEL))
    return "Subscription: OK"
end
