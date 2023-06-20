using Chain, CSV, DataFrames, DelimitedFiles, Pkg, JSON
using Genie

"""
    get_pkg_version(name::AbstractString)

Get the installed version of a Julia package by its name.

# Arguments
- `name::AbstractString`: The name of the Julia package.

# Returns
- The version of the specified package.

# Example
```Julia
get_pkg_version("ModelSelection")
```
"""
function get_pkg_version(name::AbstractString)
    @chain Pkg.dependencies() begin
        values
        [x for x in _ if x.name == name]
        only
        _.version
    end
end

"""
    save_tempfile(name::String, data::DataFrame)

Save a DataFrame to a temporary CSV file.

# Arguments
- `name::String`: The name of the temporary file.
- `data::DataFrame`: The DataFrame to save.

# Returns
- The filepath where the DataFrame was saved.

# Example
```Julia
save_tempfile("temp.csv", DataFrame(A = 1:3, B = 4:6))
```
"""
function save_tempfile(name::String, data::DataFrame)
    CSV.write(name, data)
end

"""
    get_csv_filename(filename::String, result::ModelSelection.AllSubsetRegression.AllSubsetRegressionResult)

Get a filename for a CSV file that stores the results of an all subset regression.

# Arguments
- `filename::String`: The original filename.
- `result::ModelSelection.AllSubsetRegression.AllSubsetRegressionResult`: The result of the all subset regression.

# Returns
- The filename for the CSV file.

# Example
```Julia
get_csv_filename("data.csv", result)
```
"""
function get_csv_filename(
    filename::String,
    result::ModelSelection.AllSubsetRegression.AllSubsetRegressionResult,
)
    return replace(filename, ".csv" => "") * "_allsubsetregression.csv"
end

"""
    get_csv_filename(filename::String, result::ModelSelection.CrossValidation.CrossValidationResult)

Get a filename for a CSV file that stores the results of cross validation.

# Arguments
- `filename::String`: The original filename.
- `result::ModelSelection.CrossValidation.CrossValidationResult`: The result of cross validation.

# Returns
- The filename for the CSV file.

# Example
```Julia
get_csv_filename("data.csv", result)
```
"""
function get_csv_filename(
    filename::String,
    result::ModelSelection.CrossValidation.CrossValidationResult,
)
    return replace(filename, ".csv" => "") * "_crossvalidation.csv"
end

"""
    get_txt_filename(filename::String)

Get a filename for a TXT file that stores summary data.

# Arguments
- `filename::String`: The original filename.

# Returns
- The filename for the TXT file.
"""
function get_txt_filename(filename::String)
    return replace(filename, ".csv" => "") * "_summary.txt"
end

"""
    get_csv_from_result(filename::String, result::ModelSelectionResult)

Get CSV formatted data from a result of a model selection process.

# Arguments
- `filename::String`: The original filename.
- `result::ModelSelectionResult`: The result of the model selection process.

# Returns
- A dictionary containing the filename and CSV data.

# Example
```Julia
get_csv_from_result("data.csv", result)
```
"""
function get_csv_from_result(filename::String, result::ModelSelectionResult)
    header = []
    for dataname in result.datanames
        push!(header, String(dataname))
    end
    rows = vcat(permutedims(header), result.data)
    io = IOBuffer()
    writedlm(io, rows, ',')
    data = String(take!(io))
    return Dict(FILENAME => get_csv_filename(filename, result), DATA => data)
end

"""
    get_parameters(raw_payload::Dict{String,Any})

Convert a dictionary with string keys to a dictionary with symbol keys.

# Arguments
- `raw_payload::Dict{String,Any}`: A dictionary with string keys.

# Returns
- A dictionary with the same keys and values, but with the keys converted to symbols.

# Example
```Julia
get_parameters(Dict("a" => 1, "b" => 2))
```
"""
function get_parameters(raw_payload::Dict{String,Any})
    parameters = Dict{Symbol,Any}()
    for (key, value) in raw_payload
        parameters[Symbol(key)] = value
    end
    if :fixedvariables in keys(parameters)
        parameters[:fixedvariables] = [Symbol(x) for x in parameters[:fixedvariables]]
    end
    return parameters
end

"""
    to_dict(job::ModelSelectionJob)

Convert a ModelSelectionJob object to a dictionary.

# Arguments
- `job::ModelSelectionJob`: The job to convert.

# Returns
- A dictionary representation of the job.

# Example
```Julia
to_dict(job)
```
"""
function to_dict(job::ModelSelectionJob)
    return Dict(
        ID => job.id,
        FILENAME => job.filename,
        FILEHASH => job.filehash,
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
    get_request_job_id(params::Any)

Get the job id from a set of parameters.

# Arguments
- `params::Any`: The parameters to search.

# Returns
- The job id if it exists, nothing otherwise.

# Example
```Julia
get_request_job_id(Dict("id" => 1))
```
"""
function get_request_job_id(params::Any)
    try
        return string(params(:id))
    catch e
        return nothing
    end
end

"""
    get_request_filehash(params::Any)

Get the file hash from a set of parameters.

# Arguments
- `params::Any`: The parameters to search.

# Returns
- The file hash if it exists, nothing otherwise.

# Example
```Julia
get_request_filehash(Dict("filehash" => "abc"))
```
"""
function get_request_filehash(params::Any)
    try
        return string(params(:filehash))
    catch e
        return nothing
    end
end
