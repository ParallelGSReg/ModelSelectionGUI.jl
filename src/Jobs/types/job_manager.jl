"""
    JobManager

A mutable struct to manage model selection jobs. It maintains queues for pending and finished jobs, a dictionary of files, 
and state and task information for the current job. It is initialized with a notification mechanism (`job_notify`).

# Fields:
- `pending_queue::Vector{ModelSelectionJob}`: A queue of model selection jobs yet to be processed.
- `finished_queue::Vector{ModelSelectionJob}`: A queue of model selection jobs that have been completed.
- `files::Dict{String,File}`: A dictionary mapping filehashes to `File` objects representing the files associated with jobs.
- `condition::Condition`: A condition variable for managing the state of the current job.
- `current::Union{ModelSelectionJob,Nothing}`: The current job being processed, or `nothing` if no job is being processed.
- `task::Union{Task,Nothing}`: The task that runs asynchronously being executed.
- `job_notify::Any`: A function as a callback for sending notifications about the state of jobs.

# Examples
```julia
manager = JobManager(notify)
```
"""
mutable struct JobManager
    pending_queue::Vector{ModelSelectionJob}
    finished_queue::Vector{ModelSelectionJob}
    files::Dict{String,File}
    condition::Condition
    current::Union{ModelSelectionJob,Nothing}
    task::Union{Task,Nothing}
    job_notify::Any

    function JobManager(job_notify::Any)
        pending_queue = Vector{ModelSelectionJob}()
        finished_queue = Vector{ModelSelectionJob}()
        files = Dict{String,Dict{Symbol,String}}()
        condition = Condition()
        current = nothing
        task = nothing
        new(pending_queue, finished_queue, files, condition, current, task, job_notify)
    end
end
