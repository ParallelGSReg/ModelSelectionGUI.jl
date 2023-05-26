using Genie
using Genie.Renderer, Genie.Renderer.Html, Genie.Renderer.Json, Genie.Requests
using CSV,  DataFrames, Distributed, UUIDs

function home()
    html("ModelSelectionGUI")
end


function server_info()
    global job_queue
    data = Dict(
        "ncores" => Sys.CPU_THREADS,
        "nworkers" => nworkers(),
        "model_selecion_version" => string(MODEL_SELECTION_VERSION),
        "julia_version" => string(VERSION),
        "job_queue" => Dict(
            "length" => length(job_queue),
        )
    )
    return json(data)
end


function upload()
    if !infilespayload(:data)
        throw(BadRequestException("The file was not sent"))
    end
    payload_file = filespayload(:data)
    if payload_file.mime != "text/csv"
        throw(BadRequestException("The file must be a valid CSV"))
    end
    data = try
        CSV.read(IOBuffer(payload_file.data), DataFrame)
    catch
        throw(BadRequestException("The file must be a valid CSV"))
    end
    tempfile = try
        temp = tempname()
        save_csv(temp, data)
        return temp
    catch
        throw(Genie.Exceptions.InternalServerException("The file could not be saved"))
    end
    
    global jobs_files
    
    filehash = string(uuid4())
    push!(jobs_files, Pair(id, tempfile))
    
    data = Dict(
        "filehash" => filehash,
        "datanames" => names(data),
        "nobs" => size(data, 1),
    )
    return json(data)
end


function solve()
    global jobs_files
    global job_queue

    payload = jsonpayload()

    filehash = try
        payload[String(FILEHASH)]
    catch
        throw(BadRequestException("The filehash was not sent"))
    end

    file = try
        jobs_files[filehash]
    catch
        throw(BadRequestException("The filehash is not valid"))
    end

    if !isfile(file)
        throw(BadRequestException("The file was deleted"))
    end

    raw_parameters = try
        payload[String(PARAMETERS)]
    catch
        throw(BadRequestException("The parameters were not sent"))
    end

    if !haskey(payload, String(ESTIMATOR))
        throw(BadRequestException("The estimator was not sent"))
    end

    if !haskey(payload, String(EQUATION))
        throw(BadRequestException("The equation was not sent"))
    end

    parameters = get_parameters(raw_parameters)

    job = ModelSelectionJob(file, filehash, parameters)

    data = Dict(
        "operation_id" => job.id,
        "job_queue" => Dict(
            "length" => length(job_queue),
        )
    )
    return json(data)

    """
    # Enqueue the job
    job = GSRegJob(tempfile, req[:token], options)
    enqueue_job(job)
    """
end

function result()
    json("Result")
end
