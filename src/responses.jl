using Printf
using ModelSelection

"""
    server_info_response(ncores::Int64, nworkers::Int64, model_selection_version::String, julia_version::String, jobs_queue_size::Int64)

Creates a JSON object with server information.

# Parameters
- `ncores::Int64`: The number of cores on the server.
- `nworkers::Int64`: The number of worker threads on the server.
- `model_selection_version::String`: The version number of the ModelSelection package.
- `julia_version::String`: The version number of Julia being used.
- `jobs_queue_size::Int64`: The size of the job queue.

# Returns
- `Object`: A JSON object containing the server information.

# Example
```julia
server_info_response(4, 8, "1.0.0", "1.6.1", 10)
```
"""
function server_info_response(
    ncores::Int64,
    nworkers::Int64,
    model_selection_version::String,
    julia_version::String,
    jobs_queue_size::Int64,
)
    data = Dict(
        NCORES => ncores,
        NWORKERS => nworkers,
        MODEL_SELECTION_VERSION => model_selection_version,
        JULIA_VERSION => julia_version,
        PENDING_QUEUE_SIZE => jobs_queue_size,
    )
    return Genie.Renderer.Json.json(data)
end

"""
    upload_response(filename::String, filehash::String, datanames::Array{String,1}, nobs::Int64)

Creates a JSON object to provide a response for a file upload operation.

# Parameters
- `filename::String`: The name of the uploaded file.
- `filehash::String`: The hash value of the uploaded file.
- `datanames::Array{String,1}`: An array of data names from the uploaded file.
- `nobs::Int64`: The number of observations in the uploaded file.

# Returns
- `Object`: A JSON object with details about the uploaded file.

# Example
```julia
upload_response("data.csv", "abc123", ["col1", "col2"], 100)
```
"""
function upload_response(
    filename::String,
    filehash::String,
    datanames::Array{String,1},
    nobs::Int64,
)
    data = Dict(
        FILENAME => filename,
        FILEHASH => filehash,
        DATANAMES => datanames,
        NOBS => nobs,
    )
    return Genie.Renderer.Json.json(data)
end

"""
    job_info_response(job::ModelSelectionJob)

Creates a JSON object that provides information about a `ModelSelectionJob`.

# Parameters
- `job::ModelSelectionJob`: The `ModelSelectionJob` instance to extract information from.

# Returns
- `Object`: A JSON object with the details of the `ModelSelectionJob`.

# Example
```julia
job = ModelSelectionJob(...)  # job is an instance of ModelSelectionJob
job_info_response(job)
```
"""
function job_info_response(job::ModelSelectionJob)
    response = to_dict(job)
    response[RESULTS] = nothing
    if job.modelselection_data !== nothing
        response[RESULTS] = ModelSelection.to_dict(job.modelselection_data)
    end
    return Genie.Renderer.Json.json(response)
end

"""
    job_results_response(job::ModelSelectionJob, resulttype::Symbol)

Generates an HTTP response with information about the results of a `ModelSelectionJob` 
depending on the specified result type.

# Parameters
- `job::ModelSelectionJob`: The `ModelSelectionJob` instance from which to extract results.
- `resulttype::Symbol`: The type of result to extract. This can be one of: `:summary`, 
`:allsubsetregression`, `:crossvalidation`.

# Returns
- `HTTP.Response`: A HTTP response object.
  - If `resulttype` is `:summary`, the response body is a text string 
  containing a summary of the job's results.
  - If `resulttype` is `:allsubsetregression` or 
  `:crossvalidation`, the response body is a CSV-formatted string of the corresponding results. 
  - If there are no results of the requested type, a 400 (Bad Request) HTTP response is returned.

# Example
```julia
job = ModelSelectionJob(...)  # job is an instance of ModelSelectionJob
job_results_response(job, :summary)
```
"""
function job_results_response(job::ModelSelectionJob, resulttype::Symbol)
    if resulttype == SUMMARY
        io_buffer = IOBuffer()
        outputstr = ""
        for result in job.modelselection_data.results
            if typeof(result) == ModelSelection.CrossValidation.CrossValidationResult
                outputstr =
                    outputstr * ModelSelection.CrossValidation.to_string(
                        job.modelselection_data,
                        result,
                    )
            elseif typeof(result) ==
                   ModelSelection.AllSubsetRegression.AllSubsetRegressionResult
                outputstr =
                    outputstr * ModelSelection.AllSubsetRegression.to_string(
                        job.modelselection_data,
                        result,
                    )
            end
        end
        body = String(take!(io_buffer))
        filename = get_txt_filename(job.filename)
        headers = Dict(
            "Content-Type" => "text/plain",
            "Content-Disposition" => "attachment; filename=$filename",
        )
        return HTTP.Response(200, headers, body = body)
    end

    data = nothing
    if resulttype == ALLSUBSETREGRESSION
        for result in job.modelselection_data.results
            if typeof(result) ==
               ModelSelection.AllSubsetRegression.AllSubsetRegressionResult
                filename = get_csv_filename(job.filename, result)
                data = get_csv_from_result(filename, result)
                break
            end
        end
    elseif resulttype == CROSSVALIDATION
        for result in job.modelselection_data.results
            if typeof(result) == ModelSelection.CrossValidation.CrossValidationResult
                filename = get_csv_filename(job.filename, result)
                data = get_csv_from_result(filename, result)
                break
            end
        end
    end

    if data === nothing
        return bad_request_exception(JOB_HAS_NOT_RESULTTYPE * string(resulttype))
    end

    body = data[DATA]
    filename = data[FILENAME]
    headers = Dict(
        "Content-Type" => "text/csv",
        "Content-Disposition" => "attachment; filename=$filename",
    )
    return HTTP.Response(200, headers, body = body)
end

"""
    estimators_response(estimators::Dict{Symbol, Dict{Symbol, Any}})

Create a response dictionary containing estimators. This function takes a dictionary `estimators` as input, where the keys are symbols representing the names of estimators, and the values are dictionaries containing information about each estimator.

# Parameters
- `estimators::Dict{Symbol, Dict{Symbol, Any}}`: A dictionary of estimators.

# Returns
- `HTTP.Response`: A HTTP response object.

# Example
```julia
estimators = const ESTIMATORS = Dict(
    "OLS" => Dict("name" => "Ordinary Least Squares"),
    "Logit" => Dict("name" => "Logistic Regression"),
)
estimators_response(estimators)
```
"""
function estimators_response(estimators::Dict{Symbol, Dict{Symbol, Any}})
    response = Vector{Dict{Symbol, Any}}()
    CRITERIA = ModelSelection.AllSubsetRegression.CRITERIA
    METHOD = ModelSelection.AllSubsetRegression.METHOD
    for estimator in estimators
        estimator_dict = Dict{Any, Any}()
        estimator_dict[NAME] = estimator
        estimator_dict[CRITERIA] = estimators[estimator][CRITERIA]
        estimator_dict[METHOD] = estimators[estimator][METHOD]
        push!(response, estimator_dict)
    end
    return Genie.Renderer.Json.json(response)
end
