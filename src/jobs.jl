using CSV, DataStructures, DataFrames, Dates

jobs_queue = Vector{ModelSelectionJob}()
jobs_finished = Vector{ModelSelectionJob}()
jobs_files = Dict{String,Dict{Symbol,String}}()
jobs_queue_cond = Condition()
current_job = nothing

"""
    enqueue_job(job::ModelSelectionJob)

Enqueues the specified `ModelSelectionJob` and notifies any waiting tasks.

# Arguments
- `job::ModelSelectionJob`: The `ModelSelectionJob` instance to enqueue.

# Returns
- The enqueued `ModelSelectionJob`.

# Example
```julia
job = ModelSelectionJob(...)  # job is an instance of ModelSelectionJob
enqueue_job(job)
```
"""
function enqueue_job(job::ModelSelectionJob)
    global jobs_queue
    global jobs_queue_cond
    push!(jobs_queue, job)
    notify(jobs_queue_cond)
    job
end

"""
    consume_job_queue()

Continuously consumes jobs from the queue and runs them. This function blocks indefinitely.

# Example
```julia
consume_job_queue()
```
"""
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

"""
    run_job(job::ModelSelectionJob)

Runs the specified `ModelSelectionJob`, reads the necessary data from the job's tempfile, 
and performs model selection. In case of any exception, sets the job status to FAILED and 
saves the error message.

# Arguments
- `job::ModelSelectionJob`: The `ModelSelectionJob` instance to run.

# Example
```julia
job = ModelSelectionJob(...)  # job is an instance of ModelSelectionJob
run_job(job)
```
"""
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

"""
    get_jobs_queue_length()

Returns the number of jobs currently enqueued.

# Example
```julia
get_jobs_queue_length()
```
"""
function get_jobs_queue_length()
    global jobs_queue
    return length(jobs_queue)
end

"""
    add_job_file(filehash::String, tempfile::String, filename::String)

Stores a mapping from `filehash` to the specified `tempfile` and `filename`.

# Arguments
- `filehash::String`: The file hash.
- `tempfile::String`: The temporary file path.
- `filename::String`: The original file name.

# Example
```julia
add_job_file("filehash", "tempfile", "filename")
```
"""
function add_job_file(filehash::String, tempfile::String, filename::String)
    global jobs_files
    push!(jobs_files, Pair(filehash, Dict(TEMP_FILENAME => tempfile, FILENAME => filename)))
end

"""
    get_job_file(filehash::String)

Returns the tempfile and filename associated with the specified `filehash`.

# Arguments
- `filehash::String`: The file hash.

# Returns
- A `Dict` with the tempfile and filename.

# Example
```julia
get_job_file("filehash")
```
"""
function get_job_file(filehash::String)
    global jobs_files
    file = try
        jobs_files[filehash]
    catch
        return nothing
    end
    return file
end

"""
    job_notify(message::String, data::Union{Dict{Any,Any},Nothing} = nothing)

Notifies all subscribers on the default WebSocket channel with the specified `message` and `data`.

# Arguments
- `message::String`: The message to send.
- `data::Union{Dict{Any,Any},Nothing}`: The data to send.

# Example
```julia
job_notify("message", Dict("data" => "data"))
```
"""
function job_notify(message::String, data::Union{Dict{Any,Any},Nothing} = nothing)
    msg = Dict(ID => get_current_job(), MESSAGE => message, DATA => data)
    Genie.WebChannels.broadcast(string(DEFAULT_WS_CHANNEL), JSON.json(msg))
end

"""
    get_job(queue::Vector{ModelSelectionJob}, id::String)

Searches for a job with the specified `id` in the provided `queue` and returns it. 
Returns `nothing` if the job is not found.

# Arguments
- `queue::Vector{ModelSelectionJob}`: The queue to search.
- `id::String`: The job id.

# Returns
- The job with the specified `id` or `nothing` if the job is not found.

# Example
```julia
get_job(queue, "id")
```
"""
function get_job(queue::Vector{ModelSelectionJob}, id::String)
    for job in queue
        if job.id == id
            return job
        end
    end
    return nothing
end

"""
    get_job(id::String)

Returns the job with the specified `id` from the queue of jobs, the current job, or the finished jobs. 
Returns `nothing` if the job is not found.

# Arguments
- `id::String`: The job id.

# Returns
- The job with the specified `id` or `nothing` if the job is not found.

# Example
```julia
get_job("id")
```
"""
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

"""
    get_job_queue(id::String)

Returns the job with the specified `id` from the queue of jobs. 
Returns `nothing` if the job is not found.

# Arguments
- `id::String`: The job id.

# Returns
- The job with the specified `id` or `nothing` if the job is not found.

# Example
```julia
get_job_queue("id")
```
"""
function get_job_queue(id::String)
    global jobs_queue
    job = get_job(jobs_queue, id)
    if job !== nothing
        return job
    end
    return nothing
end

"""
    get_current_job(id::Union{String,Nothing} = nothing)

Returns the current job. If `id` is specified, only returns the current job if its id matches `id`.
Returns `nothing` if there is no current job or if the id does not match.

# Arguments
- `id::Union{String,Nothing}`: The job id.

# Returns
- The current job or `nothing` if there is no current job or if the id does not match.

# Example
```julia
get_current_job()
```
"""
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

"""
    get_job_finished(id::String)

Returns the job with the specified `id` from the finished jobs. 
Returns `nothing` if the job is not found.

# Arguments
- `id::String`: The job id.

# Returns
- The job with the specified `id` or `nothing` if the job is not found.

# Example
```julia
get_job_finished("id")
```
"""
function get_job_finished(id::String)
    global jobs_finished
    job = get_job(jobs_finished, id)
    if job !== nothing
        return job
    end
    return nothing
end

"""
    clear_jobs_queue()

Clear the jobs queue. 

# Example
```julia
clear_jobs_queue()
```
"""
function clear_jobs_queue()
    global jobs_queue
    jobs_queue = Vector{ModelSelectionJob}()
end

"""
    clear_current_job()

Clear the current job.

# Example
```julia
clear_current_job()
```
"""
function clear_current_job()
    global current_job
    current_job = nothing
end

"""
    clear_jobs_finished()

Clear all the finished jobs. 

# Example
```julia
clear_jobs_finished()
```
"""
function clear_jobs_finished()
    global jobs_finished
    jobs_finished = Vector{ModelSelectionJob}()
end


