using ModelSelection

function server_info_response(ncores::Int64, nworkers::Int64, model_selecion_version::String, julia_version::String, jobs_queue_size::Int64)
    data = Dict(
        NCORES => ncores,
        NWORKERS => nworkers,
        MODEL_SELECTION_VERSION => model_selecion_version,
        JULIA_VERSION => julia_version,
        JOBS_QUEUE_SIZE => jobs_queue_size,
    )
    return json(data)
end


function upload_response(filename::String, filehash::String, datanames::Array{String, 1}, nobs::Int64)
    data = Dict(
        FILENAME => filename,
        FILEHASH => filehash,
        DATANAMES => datanames,
        NOBS => nobs,
    )
    return json(data)
end


function job_response(job::ModelSelectionJob)
    return json(to_dict(job))
end


function summary_response(job::ModelSelectionJob)
    data = job.modelselection_data
    summary = to_dict(job)
    summary[:results] = ModelSelection.to_dict(data)
    return json(summary)
end
