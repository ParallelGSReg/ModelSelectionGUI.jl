# Jobs module

The `Jobs` module provides functions to handle the jobs that calls ModelSelection asynchronously.

## Contents

```@contents
Pages = ["Jobs.md"]
```

## Index

```@index
Pages = ["Jobs.md"]
```

## How to use
```julia
function notify(message::String, data::Union{Dict{Any,Any},Nothing} = nothing)
    # ...
end

manager = JobManager(notify)

start_task(manager)

stop_task(manager)
```

## Types
```@docs
JobManager
ModelSelectionJob
File
```

## Functions
```@docs
start_task(manager::JobManager)
stop_task(manager::JobManager)
add_pending_job(manager::JobManager, job::ModelSelectionJob)
add_file(manager::JobManager, file::File)
get_file(manager::JobManager, filehash::String)
get_pending_queue_length(manager::JobManager)
Jobs.to_dict(file::File)
Jobs.to_dict(job::ModelSelectionJob)
```

## Constants
```@docs
ESTIMATOR
PENDING
RUNNING
FINISHED
FAILED
```

## Internals

### Functions
```@docs
Jobs.consume_job_task(manager::JobManager)
Jobs.consume_pending_job(manager::JobManager)
Jobs.execute_job(manager::JobManager, job::ModelSelectionJob)
Jobs.get_job(queue::Vector{ModelSelectionJob}, id::String)
Jobs.get_job(manager::JobManager, id::String)
Jobs.get_pending_job(manager::JobManager, id::String)
Jobs.get_current_job(manager::JobManager, id::Union{String,Nothing} = nothing)
Jobs.get_finished_job(manager::JobManager, id::String)
Jobs.clear_pending_queue(manager::JobManager)
Jobs.clear_current_job(manager::JobManager)
Jobs.clear_finished_queue(manager::JobManager)
Jobs.clear_all_jobs(manager::JobManager)
```

### Constants
```@docs
Jobs.ID
Jobs.FILENAME
Jobs.FILEHASH
Jobs.FILE
Jobs.PARAMETERS
Jobs.STATUS
Jobs.TIME_ENQUEUED
Jobs.TIME_STARTED
Jobs.TIME_FINISHED
Jobs.EQUATION
Jobs.MSG
```
