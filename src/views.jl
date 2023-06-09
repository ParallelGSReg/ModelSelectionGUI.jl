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

function home_view()
    html("ModelSelectionGUI")
end


function server_info_view()
    return server_info_response(
        Sys.CPU_THREADS,
        nworkers(),
        string(MODEL_SELECTION_VER),
        string(VERSION),
        get_jobs_queue_length(),
    )
end


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


function job_info_view()
    global jobs_finished
    id = get_request_job_id(params)
    job = get_job(id)
    if job === nothing
        return bad_request_exception(@sprintf("The job with id '%s' does not exists", id))  # FIXME: Move to constant MISSING_JOB_ID
    end
    return job_info_response(job)
end


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
        println(io_buffer, outputstr)
        body = String(take!(io_buffer))
        filename = get_txt_filename(job.filename)
        headers = Dict(
            "Content-Type" => "text/plain",
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
        return bad_request_exception(
            @sprintf("The job does not have a result of type %s", resulttype)
        )  # FIXME: Move to constant JOB_HAS_NOT_RESULTTYPE
    end

    body = data[DATA]
    filename = data[FILENAME]
    headers = Dict(
        "Content-Type" => "text/csv",
        "Content-Disposition" => "attachment; filename=$filename",
    )
    return HTTP.Response(200, headers, body = body)
end


function websocket_channel_view()
    WebChannels.subscribe(Genie.Requests.wsclient(), string(DEFAULT_WS_CHANNEL))
    return "Subscription: OK"
end
