# Responses

This section of the package is responsible for response-generating. These functions ensure the proper structure for each endpoint response.

## Index

```@index
Pages = ["responses.md"]
```

## Contents

```@docs
ModelSelectionGUI.server_info_response(ncores::Int64, nworkers::Int64, model_selection_version::String, julia_version::String, jobs_queue_size::Int64)
ModelSelectionGUI.upload_response(filename::String, filehash::String, datanames::Array{String,1}, nobs::Int64)
ModelSelectionGUI.job_info_response(job::ModelSelectionJob)
ModelSelectionGUI.job_results_response(job::ModelSelectionJob, resulttype::Symbol)
```
