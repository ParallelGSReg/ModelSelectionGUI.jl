# Jobs

The section of the package is responsible for handle the jobs.

## Index

```@index
Pages = ["jobs.md"]
```

## Contents

```@docs
ModelSelectionGUI.enqueue_job(job::ModelSelectionJob)
ModelSelectionGUI.consume_job_queue()
ModelSelectionGUI.run_job(job::ModelSelectionJob)
ModelSelectionGUI.get_jobs_queue_length()
ModelSelectionGUI.add_job_file(filehash::String, tempfile::String, filename::String)
ModelSelectionGUI.get_job_file(filehash::String)
ModelSelectionGUI.job_notify(message::String, data::Union{Dict{Any,Any},Nothing} = nothing)
ModelSelectionGUI.get_job(queue::Vector{ModelSelectionJob}, id::String)
ModelSelectionGUI.get_job(id::String)
ModelSelectionGUI.get_job_queue(id::String)
ModelSelectionGUI.get_current_job(id::Union{String,Nothing} = nothing)
ModelSelectionGUI.get_job_finished(id::String)
ModelSelectionGUI.clear_jobs_queue()
ModelSelectionGUI.clear_current_job()
ModelSelectionGUI.clear_jobs_finished()
```
