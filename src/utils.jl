using Chain, CSV, DataFrames, DelimitedFiles, Pkg

function get_pkg_version(name::AbstractString)
    @chain Pkg.dependencies() begin
        values
            [x for x in _ if x.name == name]
            only
            _.version
    end
end


function save_csv(name::String, data::DataFrame)
    header = names(data)
    data = Matrix(data)
    rows = vcat(permutedims(header), data)
    file = open(name, "w")
    writedlm(file, rows, ',')
    close(file)
end


function get_parameters(raw_payload::Dict{String,Any})
    parameters = Dict{Symbol,Any}()
    for (key, value) in raw_payload
        parameters[Symbol(key)] = value
    end    
end
