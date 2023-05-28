using CSV, DataStructures, DataFrames, Dates

jobs_queue = Vector{ModelSelectionJob}()
jobs_finished = Vector{ModelSelectionJob}()
jobs_files = Dict{String, Dict{Symbol, String}}()
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


function get_job(queue::Vector{ModelSelectionJob}, id::String)
    for job in queue
        if job.id == id
            return job
        end
    end
    return nothing
end


function get_job(id::String)
    job = get_job(jobs_queue, id)
    if job !== nothing
        return job
    end
    if (current_job !== nothing) && (current_job.id == id)
        return current_job
    end
    job = get_job(jobs_finished, id)
    if job !== nothing
        return job
    end
    return nothing
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
            job.parameters...,
        )
        job.time_finished = now()
        job.status = FINISHED
        push!(jobs_finished, job)
    catch e
        job.time_finished = now()
        job.status = FAILED
        job.msg = e.msg
        push!(jobs_finished, job)
    end
end
