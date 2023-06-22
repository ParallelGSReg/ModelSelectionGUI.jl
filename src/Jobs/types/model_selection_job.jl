using Dates

"""
    ModelSelectionJob

A mutable struct that represents a job for performing model selection.

# Fields
- `id::String`: The unique identifier (UUID) of the model selection job.
- `file::File`: The file used for model selection.
- `parameters::Dict{Symbol,Any}`: The parameters used for model selection, including any additional parameters specified in the request.
- `status::Symbol`: The status of the model selection job (`"pending"`, `"running"`, `"finished"`, or `"failed"`).
- `time_enqueued::DateTime`: The timestamp when the model selection job was enqueued.
- `time_started::Union{DateTime, Nothing}`: The timestamp when the model selection job started, if applicable.
- `time_finished::Union{DateTime, Nothing}`: The timestamp when the model selection job finished, if applicable.
- `modelselection_data::Union{ModelSelectionData, Nothing}`: The data used for model selection. This is `Nothing` if the data is not available.
- `estimator::Symbol`: The estimator used for model selection.
- `equation::String`: The equation or formula used for model selection.
- `msg::Union{String, Nothing}`: A message associated with the job. This is typically used for reporting errors or other important information.

# Example
```julia
result = ModelSelectionJob(
    file = File("12413947-95bc-4573-a804-efcb2293e808", "data.csv", "/tmp/my_file.csv"),
    estimator = :ols,
    equation = "y x1 x2 x3",
    parameters = Dict(
        "ttest" => true,
    ),
)
```
"""
mutable struct ModelSelectionJob
    id::String
    file::File
    parameters::Dict{Symbol,Any}
    status::Symbol
    time_enqueued::DateTime
    time_started::Union{DateTime,Nothing}
    time_finished::Union{DateTime,Nothing}
    modelselection_data::Union{ModelSelectionData,Nothing}
    estimator::Symbol
    equation::String
    msg::Union{String,Nothing}

    function ModelSelectionJob(
        file::File,
        estimator::Symbol,
        equation::String,
        parameters::Dict{Symbol,Any},
    )
        id = string(uuid4())
        time_enqueued = now()
        new(
            id,
            file,
            parameters,
            PENDING,
            time_enqueued,
            nothing,
            nothing,
            nothing,
            estimator,
            equation,
            nothing,
        )
    end
end
