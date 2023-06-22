"""
    File

A mutable struct to represent a file.

# Fields
- `id::String`: The unique identifier (UUID) of the file.
- `filename::String`: The original name of the file.
- `tempfile::String`: A temporary file location, saved in the server.
- `datanames::Vector{String}`: The names of the columns of the file.
- `nobs::Int64`: The number of observations in the file.

# Examples
```julia
file = File("data.csv", "/tmp/data.csv", data)
```
"""
mutable struct File
    id::String
    filename::String
    tempfile::String
    datanames::Vector{String}
    nobs::Int64

    function File(filename::String, tempfile::String, data::DataFrame)
        id = string(uuid4())
        datanames = names(data)
        nobs = size(data, 1)
        new(id, filename, tempfile, datanames, nobs)
    end
end
