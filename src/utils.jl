using Chain, CSV, DataFrames, DelimitedFiles, Pkg, JSON
using Genie

function get_pkg_version(name::AbstractString)
    @chain Pkg.dependencies() begin
        values
        [x for x in _ if x.name == name]
        only
        _.version
    end
end


function save_tempfile(name::String, data::DataFrame)
    CSV.write(name, data)
end


function get_csv_filename(
    filename::String,
    result::ModelSelection.AllSubsetRegression.AllSubsetRegressionResult,
)
    return replace(filename, ".csv" => "") * "_allsubsetregression.csv"
end


function get_csv_filename(
    filename::String,
    result::ModelSelection.CrossValidation.CrossValidationResult,
)
    return replace(filename, ".csv" => "") * "_crossvalidation.csv"
end

function get_txt_filename(filename::String)
    return replace(filename, ".csv" => "") * "_summary.txt"
end


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


function get_parameters(raw_payload::Dict{String,Any})
    parameters = Dict{Symbol,Any}()
    for (key, value) in raw_payload
        parameters[Symbol(key)] = value
    end
    if :fixedvariables in keys(parameters)
        parameters[:fixedvariables] = [Symbol(x) for x in parameters[:fixedvariables]]
    end
    if :criteria in keys(parameters)
        parameters[:criteria] = [Symbol(x) for x in parameters[:criteria]]
    end
    if :seasonaladjustment in keys(parameters)
        parameters[:seasonaladjustment] = [Symbol(x) for x in parameters[:seasonaladjustment]]
    end
    #agregar las demas opciones con variebles quizas conviene hacer una constante
    #con las variables y las que esten (que se enviaron por json) hace el parceo
    #criteria 
    return parameters
end


function to_dict(job::ModelSelectionJob)
    return Dict(
        :id => job.id,
        FILENAME => job.filename,
        FILEHASH => job.hash,
        PARAMETERS => job.parameters,
        STATUS => job.status,
        :time_enqueued => job.time_enqueued,
        :time_started => job.time_started,
        :time_finished => job.time_finished,
        :estimator => String(job.estimator),
        :equation => job.equation,
        :msg => job.msg,
    )
end


function get_request_job_id(params::Any)
    try
        return string(params(:id))
    catch e
        return nothing
    end
end


function get_request_filehash(params::Any)
    try
        return string(params(:filehash))
    catch e
        return nothing
    end
end
