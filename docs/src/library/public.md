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
load_envvars(path::String = ENV_FILE_DEFAULT)
reset_envvars()
start(; server_port::Union{Int, Nothing} = nothing, client_port::Union{Int, Nothing} = nothing, open_browser::Union{Bool, Nothing} = nothing, open_client::Union{Bool, Nothing} = nothing, dotenv::String = ENV_FILE_DEFAULT)
stop()
```
