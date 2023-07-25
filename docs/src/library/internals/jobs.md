# Jobs

The section of the package is responsible for handle the jobs.

## Index

```@index
Pages = ["jobs.md"]
```

## Contents

```@docs
ModelSelectionGUI.pending_queue
ModelSelectionGUI.finished_queue
ModelSelectionGUI.jobs_files
ModelSelectionGUI.pending_queue_condition
ModelSelectionGUI.finished_task_condition
ModelSelectionGUI.current_job
ModelSelectionGUI.interrupted_task
ModelSelectionGUI.add_pending_job(job::ModelSelectionJob)
ModelSelectionGUI.get_job_file(filehash::String)
ModelSelectionGUI.consume_pending_jobs()
ModelSelectionGUI.consume_pending_job()
ModelSelectionGUI.run_job(job::ModelSelectionJob)
ModelSelectionGUI.get_pending_queue_length()
ModelSelectionGUI.add_job_file(filehash::String, tempfile::String, filename::String)
ModelSelectionGUI.job_notify(message::String, data::Union{Any,Nothing} = nothing)
ModelSelectionGUI.get_job(queue::Vector{ModelSelectionJob}, id::String)
ModelSelectionGUI.get_job(id::String)
ModelSelectionGUI.set_current_job(job::ModelSelectionJob)
ModelSelectionGUI.get_pending_job(id::String)
ModelSelectionGUI.get_current_job(id::Union{String,Nothing} = nothing)
ModelSelectionGUI.get_finished_job(id::String)
ModelSelectionGUI.clear_pending_queue()
ModelSelectionGUI.clear_current_job()
ModelSelectionGUI.clear_finished_queue()
ModelSelectionGUI.clear_all_jobs()
ModelSelectionGUI.start_task()
ModelSelectionGUI.stop_task()
```
