using Genie
using Genie.Renderer, Genie.Renderer.Html, Genie.Renderer.Json, Genie.Requests, Genie.Responses
using CSV,  DataFrames, Distributed, UUIDs
using HTTP

function home()
    html("ModelSelectionGUI")
end


function server_info()
    global jobs_queue
    return server_info_response(Sys.CPU_THREADS, nworkers(), string(MODEL_SELECTION_VER), string(VERSION), length(jobs_queue))
end


function upload_file()
    if !infilespayload(:data)
        return bad_request_exception("The file was not sent")
    end

    payload_file = filespayload(:data)

    if payload_file.mime != "text/csv"
        return bad_request_exception("The file must be a valid CSV")
    end

    data = try
        CSV.read(IOBuffer(payload_file.data), DataFrame)
    catch
        return bad_request_exception("The file must be a valid CSV")
    end
    
    tempfile = try
        name = tempname()
        save_tempfile(name, data)
        name
    catch
        throw(Genie.Exceptions.InternalServerException("The file could not be saved"))
    end
    
    filename = payload_file.name

    global jobs_files
    
    filehash = string(uuid4())
    push!(jobs_files, Pair(filehash, Dict(TEMPFILE => tempfile, FILENAME => filename)))

    return upload_response(filename, filehash, names(data), size(data, 1))
end


function run()
    global jobs_files
    global jobs_queue

    filehash = string(params(:filehash))
    
    file = try
        jobs_files[filehash]
    catch
        return bad_request_exception("The filehash is not valid")
    end

    tempfile = file[TEMPFILE]
    filename = file[FILENAME]

    if !isfile(tempfile)
        return bad_request_exception("The file was deleted")
    end

    payload = jsonpayload()

    if !haskey(payload, String(ESTIMATOR))
        return bad_request_exception("The estimator was not sent")
    end

    if !haskey(payload, String(EQUATION))
        return bad_request_exception("The equation was not sent")
    end

    parameters = get_parameters(payload)

    job = ModelSelectionJob(String(filename), String(tempfile), String(filehash), parameters)
    enqueue_job(job)

    return job_response(job)
end


function status()
    global jobs_queue
    global jobs_finished

    id = string(params(:id))
    job = get_job(id)

    if job === nothing
        return bad_request_exception("The job with provided id does not exists")
    end
    return job_response(job)
end


function get_summary()
    global jobs_finished
    id = string(params(:id))
    job = get_job(jobs_finished, id)
    if job === nothing
        return bad_request_exception("The job id is not valid")
    end
    return summary_response(job)
end


function download_result()
    global jobs_finished
    id = string(params(:id))
    job = get_job(jobs_finished, id)
    if job === nothing
        return bad_request_exception("The job id is not valid")
    end

    resulttype = try
        Symbol(params(:resulttype))
    catch
        return bad_request_exception("The result type is not valid")
    end

    if !(resulttype in AVAILABLE_RESULTS_TYPES) 
        return bad_request_exception("The result type is not valid")  # TODO: Add results types
    end

    if resulttype == SUMMARY
        io_buffer = IOBuffer()
        outputstr = ""
        for result in job.modelselection_data.results
            if typeof(result) == ModelSelection.CrossValidation.CrossValidationResult
                outputstr = outputstr * ModelSelection.CrossValidation.to_string(job.modelselection_data, result)
            elseif typeof(result) ==
                ModelSelection.AllSubsetRegression.AllSubsetRegressionResult
                outputstr = outputstr * ModelSelection.AllSubsetRegression.to_string(job.modelselection_data, result)
            end
        end
        println(io_buffer, outputstr)
        body = String(take!(io_buffer))
        filename = get_txt_filename(job.filename)
        headers = Dict("Content-Type" => "text/plain", "Content-Disposition" => "attachment; filename=$filename")
        return HTTP.Response(200, headers, body = body)
    end
    
    data = nothing
    if resulttype == ALLSUBSETREGRESSION
        for result in job.modelselection_data.results
            if typeof(result) == ModelSelection.AllSubsetRegression.AllSubsetRegressionResult
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
        return bad_request_exception("The job does not have a result of type $resulttype")
    end

    body = data[DATA]
    filename = data[FILENAME] 
    headers = Dict("Content-Type" => "text/csv", "Content-Disposition" => "attachment; filename=$filename")
    return HTTP.Response(200, headers, body = body)
end
