using CSV, DataStructures, DataFrames, Dates

"""
    pending_queue::Vector{ModelSelectionJob}()

A vector to store pending model selection jobs.
"""
pending_queue = Vector{ModelSelectionJob}()

"""
    finished_queue::Vector{ModelSelectionJob}()

A vector to store finished model selection jobs.
"""
finished_queue = Vector{ModelSelectionJob}()

"""
    jobs_files::Dict{String, Dict{Symbol, String}}()

A dictionary that maps job hashes to their corresponding file information.
"""
jobs_files = Dict{String, Dict{Symbol, String}}()

"""
    pending_queue_condition::Condition()

A condition variable to signal changes in the pending job queue.
"""
pending_queue_condition = Condition()

"""
    finished_task_condition::Condition()

A condition variable to signal changes in the finished job queue.
"""
finished_task_condition = Condition()

"""
    current_job::Union{ModelSelectionJob, Nothing}

A variable to store the current job being processed, or `nothing` if no job is active.
"""
current_job = nothing

"""
    interrupted_task::Bool

A boolean flag indicating whether a task has been interrupted.
"""
interrupted_task = false

"""
    add_pending_job(job::ModelSelectionJob)

Adds the given job to the pending queue. After adding the job, the function notifies `condition` variable.

# Parameters
- `job::ModelSelectionJob`: The job to be added to the pending queue.

# Globals
- `pending_queue::Vector{ModelSelectionJob}`: The queue storing pending jobs.
- `pending_queue_condition::Condition`: The condition variable for signaling changes in the pending job queue.

# Returns
- `ModelSelectionJob`: The `ModelSelectionJob` object.

# Example
```julia
job = ModelSelectionJob(...)
add_pending_job(job)
```
"""
function add_pending_job(job::ModelSelectionJob)
    global pending_queue
    global pending_queue_condition
    push!(pending_queue, job)
    notify(pending_queue_condition)
    job
end

"""
    consume_pending_jobs()

Consumes continuously pending jobs from the `pending_queue` and processes them until interrupted.

# Globals
- `pending_queue::Vector{ModelSelectionJob}`: The queue storing pending jobs.
- `pending_queue_condition::Condition`: The condition variable for signaling changes in the pending job queue.
- `finished_task_condition::Condition`: The condition variable for signaling changes in the finished job queue.
- `interrupted_task::Bool`: A boolean flag indicating whether a task has been interrupted.

# Example
```julia
consume_pending_jobs()
```
"""
function consume_pending_jobs()
    global pending_queue
    global pending_queue_condition
    global finished_task_condition
    global interrupted_task
    while true
        wait(pending_queue_condition)
        if !(isempty(pending_queue)) && (interrupted_task == false)
            consume_pending_job()
        end
        if interrupted_task
            interrupted_task = false
            break
        end
    end
    notify(finished_task_condition)
end

"""
    consume_pending_job()

Consume a pending job form the `pending_queue` and executes it.

# Globals
- `pending_queue::Vector{ModelSelectionJob}`: The queue storing pending jobs.
- `current_job::ModelSelectionJob`: The current job being processed.

# Example
```julia
consume_pending_job()
```
"""
function consume_pending_job()
    global pending_queue
    global current_job
    current_job = pop!(pending_queue)
    run_job(current_job)
end

"""
    run_job(job::ModelSelectionJob)

Runs the specified `ModelSelectionJob`, reads the necessary data from the job's tempfile, 
and performs model selection. In case of any exception, sets the job status to FAILED and 
saves the error message.

# Parameters
- `job::ModelSelectionJob`: The `ModelSelectionJob` instance to run.

# Globals
- `finished_queue::Vector{ModelSelectionJob}`: The queue storing finished jobs.
- `current_job::ModelSelectionJob`: The current job being processed.

# Example
```julia
job = ModelSelectionJob(...)  # job is an instance of ModelSelectionJob
run_job(job)
```
"""
function run_job(job::ModelSelectionJob)
    global finished_queue
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
    push!(finished_queue, job)
end

"""
    get_pending_queue_length()

Returns the number of pending jobs.

# Globals
- `pending_queue::Vector{ModelSelectionJob}`: The queue storing pending jobs.

# Returns
 - `Int64`: The number of pending jobs jobs.

# Example
```julia
get_pending_queue_length()
```
"""
function get_pending_queue_length()
    global pending_queue
    return length(pending_queue)
end

"""
    add_job_file(filehash::String, tempfile::String, filename::String)

Stores a mapping from `filehash` to the specified `tempfile` and `filename`.

# Parameters
- `filehash::String`: The file hash.
- `tempfile::String`: The temporary file path.
- `filename::String`: The original file name.

# Globals
- `job_files::Dict{String, Dict{Symbol, String}}`: The dictionary that maps job hashes to their corresponding file information.

# Example
```julia
add_job_file("441c3a47-c302-43b6-8a2d-fe145baa29eb", "/tmp/data.csv", "data.csv")
```
"""
function add_job_file(filehash::String, tempfile::String, filename::String)
    global jobs_files
    push!(jobs_files, Pair(filehash, Dict(TEMP_FILENAME => tempfile, FILENAME => filename)))
end

"""
    get_job_file(filehash::String)

Returns the tempfile and filename associated with the specified `filehash`.

# Parameters
- `filehash::String`: The file hash.

# Globals
- `job_files::Dict{String, Dict{Symbol, String}}`: The dictionary that maps job hashes to their corresponding file information.

# Returns
- Dict{Symbol, String}: A Dict with the tempfile and filename.

# Example
```julia
get_job_file("441c3a47-c302-43b6-8a2d-fe145baa29eb")
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

# Parameters
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

# Parameters
- `queue::Vector{ModelSelectionJob}`: The queue to search.
- `id::String`: The job id.

# Returns
- `ModelSelectionJob`: The job with the specified `id`.
- `Nothing`: If the job is not found.

# Example
```julia
get_job(queue, "7182939d-c5a1-4e21-a06e-182195c961fa")
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

Returns the job with the specified `id` from the pending jobs, the current job, or the finished jobs. 
Returns `nothing` if the job is not found.

# Parameters
- `id::String`: The job id.

# Returns
- `ModelSelectionJob`: The job with the specified `id`.
- `Nothing`: If the job is not found.

# Example
```julia
get_job("7182939d-c5a1-4e21-a06e-182195c961fa")
```
"""
function get_job(id::String)
    job = get_pending_job(id)
    if job !== nothing
        return job
    end
    job = get_current_job(id)
    if job !== nothing
        return job
    end
    return get_finished_job(id)
end

"""
    set_current_job(job::ModelSelectionJob)

Sets the current job. If there is already a current job, it is replaced.

# Parameters
- `job::ModelSelectionJob`: The job.

# Globals
- `current_job::ModelSelectionJob`: The current job being processed.

# Example
```julia
job = ModelSelectionJob(...)
set_current_job(job)
```
"""
function set_current_job(job::ModelSelectionJob)
    global current_job
    current_job = job
end

"""
    get_pending_job(id::String)

Returns the job with the specified `id` from the pending jobs. 
Returns `nothing` if the job is not found.

# Parameters
- `id::String`: The job id.

# Globals
- `pending_queue::Vector{ModelSelectionJob}`: The queue storing pending jobs.

# Returns
- `ModelSelectionJob`: The job with the specified `id`.
- `Nothing`: If the job is not found.

# Example
```julia
get_pending_job("3ea06b21-844e-4505-a912-34828fa827a1")
```
"""
function get_pending_job(id::String)
    global pending_queue
    job = get_job(pending_queue, id)
    if job !== nothing
        return job
    end
    return nothing
end

"""
    get_current_job(id::Union{String,Nothing} = nothing)

Returns the current job. If `id` is specified, only returns the current job if its id matches `id`.
Returns `nothing` if there is no current job or if the id does not match.

# Parameters
- `id::Union{String,Nothing}`: The job id.

# Returns
- `ModelSelectionJob`: The current job or the current job with the specified `id`.
- `Nothing`: If the job is not found.

# Globals
- `current_job::ModelSelectionJob`: The current job being processed.

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
    get_finished_job(id::String)

Returns the job with the specified `id` from the finished jobs. 
Returns `nothing` if the job is not found.

# Parameters
- `id::String`: The job id.

# Globals
- `pending_queue::Vector{ModelSelectionJob}`: The queue storing pending jobs.

# Returns
- `ModelSelectionJob`: The job with the specified `id`.
- `Nothing`: If the job is not found.

# Example
```julia
get_finished_job("3ea06b21-844e-4505-a912-34828fa827a1")
```
"""
function get_finished_job(id::String)
    global finished_queue
    job = get_job(finished_queue, id)
    if job !== nothing
        return job
    end
    return nothing
end

"""
    clear_pending_queue()

Clear the jobs queue. 

# Globals
- `pending_queue::Vector{ModelSelectionJob}`: The queue storing pending jobs.

# Example
```julia
clear_pending_queue()
```
"""
function clear_pending_queue()
    global pending_queue
    pending_queue = Vector{ModelSelectionJob}()
end

"""
    clear_current_job()

Clear the current job.

# Globals
- `current_job::ModelSelectionJob`: The current job being processed.

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
    clear_finished_queue()

Clear all the finished jobs. 

# Globals
- `finished_queue::Vector{ModelSelectionJob}`: The queue storing finished jobs.

# Example
```julia
clear_finished_queue()
```
"""
function clear_finished_queue()
    global finished_queue
    finished_queue = Vector{ModelSelectionJob}()
end

"""
    clear_all_jobs()

Clears all job queues (pending, current, finished).

# Example
```julia
clear_all_jobs()
```
"""
function clear_all_jobs()
    clear_pending_queue()
    clear_current_job()
    clear_finished_queue()
end

"""
    start_task()

Starts the task of consuming pending jobs from the job queue in an asynchronous way. If there's already a task 
running, the function simply returns without starting a new one.

# Globals
- `JOB_TASK::Task`: The task consuming pending jobs.

# Example
```julia
start_task()
```
"""
function start_task()
    global JOB_TASK
    if JOB_TASK !== nothing
        return
    end
    JOB_TASK = @task consume_pending_jobs()
    schedule(JOB_TASK)
end

"""
    stop_task()

Interrupts the currently running task of object. If no task is running, the function does nothing.

# Globals
- `JOB_TASK::Task`: The task consuming pending jobs.
- `interrupted_task::Bool`: Whether the task has been interrupted.
- `pending_queue_condition::Condition`: The condition variable for the pending queue.
- `finished_task_condition::Condition`: The condition variable for the finished task.

# Example
```julia
stop_task()
```
"""
function stop_task()
    global JOB_TASK
    global interrupted_task
    global pending_queue_condition
    global finished_task_condition
    if JOB_TASK === nothing
        return
    end
    interrupted_task = true
    notify(pending_queue_condition)
    wait(finished_task_condition)
    JOB_TASK = nothing
end
