"""
    start_task(manager::JobManager)

Starts the task of consuming pending jobs from the job queue in an asynchronous way. If there's already a task 
running, the function simply returns without starting a new one.
    
# Arguments
- `manager::JobManager`: The `JobManager` object.

# Returns
- `JobManager`: The `JobManager` object.

# Example
```julia
manager = JobManager()
start_task(manager)
```
"""
function start_task(manager::JobManager)
    if manager.task !== nothing
        return manager
    end
    manager.task = @task consume_pending_jobs(manager)
    schedule(manager.task)
    return manager
end

"""
    stop_task(manager::JobManager)

Interrupts the currently running task of the `JobManager` object. If no task is running, the function does nothing.

# Arguments
- `manager::JobManager`: The `JobManager` object.

# Returns
- `JobManager`: The `JobManager` object.

# Example
```julia
stop_task(manager)
```
"""
function stop_task(manager::JobManager)
    if manager.task !== nothing
        @async Base.throwto(manager.task, InterruptException())
        manager.task = nothing
    end
    return manager
end

"""
    add_pending_job(manager::JobManager, job::ModelSelectionJob)

Adds the given job to the pending queue of the `JobManager` object. After adding the job, the function notifies any waiting 
threads on the the `JobManager` object's condition variable.

# Arguments
- `manager::JobManager`: The `JobManager` object.
- `job::ModelSelectionJob`: The job to be added to the pending queue.

# Returns
- `JobManager`: The `JobManager` object.

# Example
```julia
manager = JobManager()
job = ModelSelectionJob()
add_pending_job(manager, job)
```
"""
function add_pending_job(manager::JobManager, job::ModelSelectionJob)
    push!(manager.pending_queue, job)
    Base.notify(manager.condition)
    return job
end

"""
    add_file(manager::JobManager, file::File)

Add a new file to the `JobManager` object's files.

# Arguments
- `manager::JobManager`: The `JobManager` object.
- `file::File`: The file to be added.

# Example
```julia
manager = JobManager()
file = File("data.csv", "/tmp/data.csv", data)
add_file(manager, file)
```
"""
function add_file(manager::JobManager, file::File)
    manager.files[file.id] = file
end

"""
    get_file(manager::JobManager, filehash::String)

Returns the file associated with the given `filehash` in the `JobManager` object's files. If no file with the given hash 
exists, the function returns `nothing`.

# Arguments
- `manager::JobManager`: The `JobManager` object.
- `filehash::String`: The hash of the file to retrieve.

# Returns
- `File`: The file associated with the given hash, or `nothing` if no such file exists.

# Example
```julia
manager = JobManager()
file = get_file(manager, ""12413947-95bc-4573-a804-efcb2293e808"")
```
"""
function get_file(manager::JobManager, filehash::String)
    file = try
        manager.files[filehash]
    catch
        return nothing
    end
    return file
end

"""
    get_pending_queue_length(manager::JobManager)

Returns the number of pending jobs in the `JobManager` object's job queue.

# Arguments
- `manager::JobManager`: The `JobManager` object.

# Returns
- `Int`: The number of jobs currently in the pending queue.

# Example
```julia
manager = JobManager(job_notify)
length = get_pending_queue_length(manager)
```
"""
function get_pending_queue_length(manager::JobManager)
    return length(manager.pending_queue)
end

"""
    to_dict(job::ModelSelectionJob)

Convert a `ModelSelectionJob` object to a `Dict`.

# Arguments
- `job::ModelSelectionJob`: The `ModelSelectionJob` object to convert.

# Returns
- A `Dict` representation of the `ModelSelectionJob` object.

# Example
```Julia
to_dict(job)
```
"""
function to_dict(job::ModelSelectionJob)
    return Dict{Symbol,Any}(
        ID => job.id,
        FILE => Jobs.to_dict(job.file),
        PARAMETERS => job.parameters,
        STATUS => job.status,
        TIME_ENQUEUED => job.time_enqueued,
        TIME_STARTED => job.time_started,
        TIME_FINISHED => job.time_finished,
        ESTIMATOR => job.estimator,
        EQUATION => job.equation,
        MSG => job.msg,
    )
end

"""
    to_dict(job::Jobs.File)

Convert a `File` object to a `Dict`.

# Arguments
- `file::File`: The `File` object to convert.

# Returns
- A `Dict` representation of the `File` object.

# Example
```Julia
to_dict(file)
```
"""
function to_dict(file::Jobs.File)
    return Dict{Symbol,Any}(
        ID => file.id,
        FILENAME => file.filename,
        DATANAMES => file.datanames,
        NOBS => file.nobs,
    )
end

"""
    consume_job_task(manager::JobManager)

Task that continuously waits for and executes jobs from the pending queue of the `JobManager`. The function runs in a loop, 
waiting on the the `JobManager`'s condition variable if the queue is empty.
# Arguments
- `manager::JobManager`: The `JobManager` object that maintains the state of jobs and related tasks.

# Example
```julia
manager = JobManager()
consume_job_task(manager)
```
"""
function consume_job_task(manager)
    while true
        Base.wait(manager.condition)
        while !(isempty(manager.pending_queue))
            consume_pending_jobs(manager)
        end
    end
end

"""
    consume_pending_job(manager::JobManager)

Consume a pending job form the `pending_queue` and executes it.

# Arguments
- `manager::JobManager`: The `JobManager` object.

# Example
```julia
manager = JobManager()
consume_pending_job(manager)
```
"""
function consume_pending_job(manager::JobManager)
    current = pop!(manager.pending_queue)
    execute_job(manager, current)
end

"""
    execute_job(manager::JobManager, job::ModelSelectionJob)

Executes the specified model selection job on the given `JobManager`. The job is read from its 
associated file, then model selection is performed using the GSR algorithm with the parameters 
provided in the job.

While the job is executing, it's status is set to `RUNNING` and the `JobManager`'s current job is 
set to the given job. If the job execution completes successfully, its status is updated to `FINISHED`. 
Otherwise, if an error is encountered, the status is set to `FAILED` and the error message is saved.

Once the job is done (either successfully or with failure), it is added to the the `JobManager`'s finished 
queue and the current job is reset to `nothing`.

# Arguments
- `manager::JobManager`: The `JobManager` object that maintains the state of jobs and related tasks.
- `job::ModelSelectionJob`: The job to be executed.

# Example
```julia
manager = JobManager()
job = ModelSelectionJob()
execute_job(manager, job)
```
"""
function execute_job(manager::JobManager, job::ModelSelectionJob)
    manager.current = job
    job.time_started = now()
    job.status = RUNNING
    try
        data = CSV.read(job.file.tempfile, DataFrame)
        job.modelselection_data = gsr(
            job.estimator,
            job.equation,
            data;
            notify = manager.job_notify,
            job.parameters...,
        )
        job.status = FINISHED
    catch e
        bt = backtrace()
        job.status = FAILED
        job.msg = sprint(showerror, e, bt)
    end
    job.time_finished = now()
    manager.current = nothing
    push!(manager.finished_queue, job)
end

"""
    get_job(queue::Vector{ModelSelectionJob}, id::String)

Searches for a job in the specified queue using its unique `id`.

# Arguments
- `queue::Vector{ModelSelectionJob}`: The queue where the job is searched.
- `id::String`: The unique identifier (UUID) of the job.

# Returns
- `ModelSelectionJob` or `Nothing`: The job if it's found in the queue; `Nothing` otherwise.

# Example
```julia
manager = JobManager()
job = get_job(manager.pending_queue, "12413947-95bc-4573-a804-efcb2293e808")
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
    get_job(manager::JobManager, id::String)

Searches for a job across all the job queues (pending, current, and finished) managed by the `JobManager`.

# Arguments
- `manager::JobManager`: The `JobManager` object handling the job queues.
- `id::String`: The unique identifier (UUID) of the job.

# Returns
- `ModelSelectionJob` or `Nothing`: The job if it's found; `Nothing` otherwise.

# Example
```julia
manager = JobManager()
job = get_job(manager, "12413947-95bc-4573-a804-efcb2293e808")
```
"""
function get_job(manager::JobManager, id::String)
    job = get_pending_job(manager, id)
    if job !== nothing
        return job
    end
    job = get_current_job(manager, id)
    if job !== nothing
        return job
    end
    return get_finished_job(manager, id)
end

"""
    get_pending_job(manager::JobManager, id::String)

Searches for a job across in the pending job queue managed by the `JobManager`.

# Arguments
- `manager::JobManager`: The `JobManager` object handling the job queues.
- `id::String`: The unique identifier (UUID) of the job.

# Returns
- `ModelSelectionJob` or `Nothing`: The job if it's found; `Nothing` otherwise.

# Example
```julia
manager = JobManager()
job = get_pending_job(manager, "12413947-95bc-4573-a804-efcb2293e808")
```
"""
function get_pending_job(manager::JobManager, id::String)
    job = get_job(manager.pending_queue, id)
    if job !== nothing
        return job
    end
    return nothing
end

"""
    get_current_job(manager::JobManager, id::Union{String,Nothing} = nothing)

Gets the current job from the `JobManager` if it exists. The current job can be optionally
specified by its unique `id`.

# Arguments
- `manager::JobManager`: The `JobManager` object handling the job queues.
- `id::Union{String,Nothing}`: The unique identifier (UUID) of the job (optional).

# Returns
- `ModelSelectionJob` or `Nothing`: If the `id` is not specified, it returns the current job 
  if it exists; `Nothing` otherwise. If the `id` is specified, it returns the current job only 
  if its `id` matches the specified `id`; `Nothing` otherwise.

# Examples
```julia
manager = JobManager()
get_current_job(manager) # Get the current job
get_current_job(manager, "12413947-95bc-4573-a804-efcb2293e808") # Get the current job only if its id is ""12413947-95bc-4573-a804-efcb2293e808""
```
"""
function get_current_job(manager::JobManager, id::Union{String,Nothing} = nothing)
    if manager.current === nothing
        return nothing
    end

    if (id === nothing) || (id !== nothing && manager.current.id == id)
        return manager.current
    end

    return nothing
end

"""
    get_finished_job(manager::JobManager, id::String)

Get a specific finished job from the `JobManager` using its unique `id`.

# Arguments
- `manager::JobManager`: The `JobManager` object handling the job queues.
- `id::String`: The unique identifier (UUID) of the job.

# Returns
- `ModelSelectionJob` or `Nothing`: Returns the finished job with the specified `id` if it exists; `Nothing` otherwise.

# Examples
```julia
manager = JobManager()
get_finished_job(manager, ""12413947-95bc-4573-a804-efcb2293e808"") # Get the finished job with id ""12413947-95bc-4573-a804-efcb2293e808""
```
"""
function get_finished_job(manager::JobManager, id::String)
    job = get_job(manager.finished_queue, id)
    if job !== nothing
        return job
    end
    return nothing
end

"""
    clear_pending_queue(manager::JobManager)

Clears the pending queue in the provided `JobManager`.

# Arguments
- `manager::JobManager`: The `JobManager` object whose pending queue is to be cleared.

# Examples
```julia
manager = JobManager()
clear_pending_queue(manager) # Clears the pending job queue
```
"""
function clear_pending_queue(manager::JobManager)
    manager.pending_queue = Vector{ModelSelectionJob}()
end

"""
    clear_current_job(manager::JobManager)

Clears the current job in the provided `JobManager`.

# Arguments
- `manager::JobManager`: The `JobManager` object whose current job is to be cleared.

# Examples
```julia
manager = JobManager()
clear_current_job(manager) # Clears the current job
```
"""
function clear_current_job(manager::JobManager)
    manager.current = nothing
end

"""
    clear_finished_queue(manager::JobManager)

Clears the finished queue in the provided the `JobManager`.

# Arguments
- `manager::JobManager`: The `JobManager` object whose finished queue is to be cleared.

# Examples
```julia
manager = JobManager()
clear_finished_queue(manager) # Clears the finished job queue
```
"""
function clear_finished_queue(manager::JobManager)
    manager.finished_queue = Vector{ModelSelectionJob}()
end

"""
    clear_all_jobs(manager::JobManager)

Clears all job queues (pending, current, finished) in the provided the `JobManager`.

# Arguments
- `manager::JobManager`: The `JobManager` object whose job queues are to be cleared.

# Examples
```julia
manager = JobManager()
clear_all_jobs(manager) # Clears all job queues
```
"""
function clear_all_jobs(manager::JobManager)
    clear_pending_queue(manager)
    clear_current_job(manager)
    clear_finished_queue(manager)
end
