using ModelSelection

function server_info_response(
    ncores::Int64,
    nworkers::Int64,
    model_selecion_version::String,
    julia_version::String,
    jobs_queue_size::Int64,
)
    data = Dict(
        NCORES => ncores,
        NWORKERS => nworkers,
        MODEL_SELECTION_VERSION => model_selecion_version,
        JULIA_VERSION => julia_version,
        JOBS_QUEUE_SIZE => jobs_queue_size,
    )
    return Genie.Renderer.Json.json(data)
end


function upload_response(
    filename::String,
    filehash::String,
    datanames::Array{String,1},
    nobs::Int64,
)
    data = Dict(
        FILENAME => filename,
        FILEHASH => filehash,
        DATANAMES => datanames,
        NOBS => nobs,
    )
    return Genie.Renderer.Json.json(data)
end

function job_info_response(job::ModelSelectionJob)
    response = to_dict(job)
    response[RESULTS] = nothing
    if job.modelselection_data !== nothing
        response[RESULTS] = ModelSelection.to_dict(job.modelselection_data)
    end
    return Genie.Renderer.Json.json(response)
end
