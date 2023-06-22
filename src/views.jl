using Printf
using Genie
using JSON, CSV, Distributed
using HTTP
using SwagUI
using ModelSelection

options = Options()
options.show_explorer = false
swagger_document = JSON.parsefile("./docs/swagger/swagger.json")
frontend_file = read("./frontend/index.html", String)

"""
    frontend_view()

The function renders the frontend.
"""
function frontend_view()
    html(frontend_file)
end

"""
    docs_view()

The functions render the Swagger UI documentation of the API from the `swagger_document` data.
"""
function docs_view()
    render_swagger(swagger_document, options = options)
end

"""
    server_info_view()

Returns information about the server.

# Returns
- A JSON object with the server information.
"""
function server_info_view()
    application = APPLICATION # FIXME
    data = Dict(
        NCORES => Sys.CPU_THREADS,
        NWORKERS => nworkers(),
        MODEL_SELECTION_VERSION => string(MODEL_SELECTION_VER),
        JULIA_VERSION => string(VERSION),
        JOBS_QUEUE_SIZE => get_pending_queue_length(application.manager),
    )
    return Genie.Renderer.Json.json(data)
end

"""
    upload_file_view()

Uploads a CSV file to the server. Upon successful upload, the server will process the uploaded file for further operations.

# Returns
- A JSON object with information about the saved file.
"""
function upload_file_view()
    application = APPLICATION # FIXME
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

    tempfile = try
        name = tempname()
        save_tempfile(name, data)
        name
    catch
        throw(Genie.Exceptions.InternalServerException(FILE_NOT_SAVED))
    end
    filename = payload_file.name
    file = File(filename, tempfile, data)
    add_file(application.manager, file)
    return Genie.Renderer.Json.json(to_dict(file))
end

"""
    job_enqueue_view()

Enqueues a model selection job for the specified file. The task will be executed after the previously queued tasks have finished.

# Returns
- A JSON object with information about the created job.
"""
function job_enqueue_view()
    application = APPLICATION # FIXME
    filehash = get_request_filehash(params)
    file = get_file(job_manager, filehash)

    if file === nothing
        return bad_request_exception(FILEHASH_NOT_VALID[1] * filehash * FILEHASH_NOT_VALID[2])
    end

    if !isfile(file.tempfile)
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
        file,
        estimator,
        equation,
        parameters,
    )
    add_pending_job(application.manager, job)
    return to_dict(job)
end

"""
    job_info_view()

Returns the info of a model selection job. If the job is finished, it also includes the summary of a model selection job.

# Returns
- A JSON object with information about the selected job.
"""
function job_info_view()
    application = APPLICATION # FIXME
    id = get_request_job_id(params)
    job = get_job(application.manager, id)
    if job === nothing
        return bad_request_exception(MISSING_JOB_ID[1] * id * MISSING_JOB_ID[2])
    end
    return to_dict(job)
end

"""
job_results_view()

Returns the result file of a specific type for a model selection job.

# Returns
- A text file with the selected result.
"""
function job_results_view()
    application = APPLICATION # FIXME
    id = get_request_job_id(params)
    job = get_finished_job(application.manager, id)
    if job === nothing
        return bad_request_exception(MISSING_JOB_ID[1] * id * MISSING_JOB_ID[2])
    end

    resulttype = try
        Symbol(params(:resulttype))
    catch
        return bad_request_exception(MISSING_RESULT_TYPE)
    end

    if !(resulttype in AVAILABLE_RESULTS_TYPES)
        return bad_request_exception(INVALID_RESULT_TYPE[1] * resulttype * INVALID_RESULT_TYPE[2] * join(AVAILABLE_RESULTS_TYPES, ", ") * INVALID_RESULT_TYPE[3])
    end

    if resulttype == SUMMARY
        io_buffer = IOBuffer()
        outputstr = ""
        for result in job.modelselection_data.results
            if typeof(result) == ModelSelection.CrossValidation.CrossValidationResult
                outputstr =
                    outputstr * ModelSelection.CrossValidation.to_string(
                        job.modelselection_data,
                        result,
                    )
            elseif typeof(result) ==
                   ModelSelection.AllSubsetRegression.AllSubsetRegressionResult
                outputstr =
                    outputstr * ModelSelection.AllSubsetRegression.to_string(
                        job.modelselection_data,
                        result,
                    )
            end
        end
        body = String(take!(io_buffer))
        filename = get_txt_filename(job.filename)
        headers = Dict(
            "Content-Type" => PLAIN_MIME,
            "Content-Disposition" => "attachment; filename=$filename",
        )
        return HTTP.Response(200, headers, body = body)
    end

    data = nothing
    if resulttype == ALLSUBSETREGRESSION
        for result in job.modelselection_data.results
            if typeof(result) ==
               ModelSelection.AllSubsetRegression.AllSubsetRegressionResult
                filename = get_csv_filename(job.filename, result)
                data = get_csv_from_result(filename, result)
                break
            end
        end
    elseif resulttype == CROSSVALIDATION
        for result in job.modelselection_data.results
            if typeof(result) == ModelSelection.CrossValidation.CrossValidationResult
                filename = get_csv_filename(job.filename, result)
                data = get_csv_from_result(filename, result)
                break
            end
        end
    end

    if data === nothing
        return bad_request_exception(JOB_HAS_NOT_RESULTTYPE * resulttype)
    end

    body = data[DATA]
    filename = data[FILENAME]
    headers = Dict(
        "Content-Type" => CSV_MIME,
        "Content-Disposition" => "attachment; filename=$filename",
    )
    return HTTP.Response(200, headers, body = body)
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
