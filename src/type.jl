using Dates
using ModelSelection:
    Preprocessing, AllSubsetRegression, CrossValidation, ModelSelectionData

mutable struct ModelSelectionJob
    id::String
    filename::String
    tempfile::String
    hash::String
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
        filename::String,
        tempfile::String,
        hash::String,
        payload::Dict{Symbol,Any},
    )
        estimator = Symbol(payload[ESTIMATOR])
        equation = payload[EQUATION]
        delete!(payload, ESTIMATOR)
        delete!(payload, EQUATION)

        id = string(uuid4())
        time_enqueued = now()
        new(
            id,
            filename,
            tempfile,
            hash,
            payload,
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
