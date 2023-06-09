using CSV, DataStructures, DataFrames, Dates

jobs_queue = Vector{ModelSelectionJob}()
jobs_finished = Vector{ModelSelectionJob}()
jobs_files = Dict{String,Dict{Symbol,String}}()
jobs_queue_cond = Condition()
current_job = nothing


function enqueue_job(job::ModelSelectionJob)
    global jobs_queue
    global jobs_queue_cond
    push!(jobs_queue, job)
    notify(jobs_queue_cond)
    job
end


function consume_job_queue()
    global jobs_queue
    global jobs_queue_cond
    while true
        wait(jobs_queue_cond)
        while !(isempty(jobs_queue))
            current_job = pop!(jobs_queue)
            run_job(current_job)
        end
    end
end


function run_job(job::ModelSelectionJob)
    global jobs_finished
    global current_job
    current_job = job
    job.time_started = now()
    job.status = RUNNING
    try
        data = CSV.read(job.tempfile, DataFrame)
        job.modelselection_data = gsr(
            job.estimator,
            job.equation,
            data;
            notify = ModelSelectionGUI.job_notify,
            job.parameters...,
        )
        job.status = FINISHED
    catch e
        bt = backtrace()
        job.status = FAILED
        job.msg = sprint(showerror, e, bt)
    end
    job.time_finished = now()
    current_job = nothing
    push!(jobs_finished, job)
end


function get_jobs_queue_length()
    global jobs_queue
    return length(jobs_queue)
end


function add_job_file(filehash::String, tempfile::String, filename::String)
    global jobs_files
    push!(jobs_files, Pair(filehash, Dict(TEMP_FILENAME => tempfile, FILENAME => filename)))
end


function get_job_file(filehash::String)
    global jobs_files
    file = try
        jobs_files[filehash]
    catch
        return nothing
    end
    return file
end


function job_notify(message::String, data::Union{Dict{Any,Any},Nothing} = nothing)
    msg = Dict(ID => get_current_job(), MESSAGE => message, DATA => data)
    Genie.WebChannels.broadcast(string(DEFAULT_WS_CHANNEL), JSON.json(msg))
end



function get_job(queue::Vector{ModelSelectionJob}, id::String)
    for job in queue
        if job.id == id
            return job
        end
    end
    return nothing
end


function get_job(id::String)
    job = get_job_queue(id)
    if job !== nothing
        return job
    end
    job = get_current_job(id)
    if job !== nothing
        return job
    end
    return get_job_finished(id)
end


function get_job_queue(id::String)
    global jobs_queue
    job = get_job(jobs_queue, id)
    if job !== nothing
        return job
    end
    return nothing
end


function get_current_job(id::Union{String,Nothing} = nothing)
    global current_job
    if current_job === nothing
        return nothing
    end

    if (id === nothing) || (id !== nothing && current_job.id == id)
        return current_job
    end

    return nothing
end


function get_job_finished(id::String)
    global jobs_finished
    job = get_job(jobs_finished, id)
    if job !== nothing
        return job
    end
    return nothing
end
