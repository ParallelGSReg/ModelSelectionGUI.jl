# Development

# Public Documentation

Documentation for `Documenter.jl`'s public interface.

See the Internals section of the manual for internal package docs covering all submodules.

## Index

```@index
Pages = ["public.md"]
```

## Contents

```@docs
set_envvars(;
    server_host::Union{String,Nothing} = nothing,
    server_port::Union{Int64,Nothing} = nothing,
    ssl_enabled::Union{Bool,Nothing} = nothing,
    open_documentation::Union{Bool,Nothing} = nothing,
    open_client::Union{Bool,Nothing} = nothing,
)
load_envvars(path::String = ENV_FILE_DEFAULT)
reset_envvars()
start(; server_port::Union{Int, Nothing} = nothing, client_port::Union{Int, Nothing} = nothing, OPEN_DOCUMENTATION::Union{Bool, Nothing} = nothing, open_client::Union{Bool, Nothing} = nothing, dotenv::String = ENV_FILE_DEFAULT, no_task::Bool = false)
stop()
ModelSelectionGUI.to_dict(job::ModelSelectionJob)
```
