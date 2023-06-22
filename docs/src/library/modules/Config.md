# Config module

The `Config` module provides functions to handle application settings and environment variables.

## Contents

```@contents
Pages = ["Config.md"]
```

## Index

```@index
Pages = ["Config.md"]
```

## How to use
```julia
settings = Settings()
load_settings(
    settings,
    server_host = "localhost",
    server_port = 80,
    ssl_enabled = false,
    open_client = true,
    open_documentation = true,
)
```

## Types
```@docs
Settings
```

## Functions
```@docs
load_settings(
    settings::Settings,
    path::String;
    server_host::Union{String,Nothing} = nothing,
    server_port::Union{Int64,Bool,Nothing} = nothing,
    ssl_enabled::Union{Bool,Nothing} = nothing,
    open_client::Union{Bool,Nothing} = nothing,
    open_documentation::Union{Bool,Nothing} = nothing,
)
load_settings(
    settings::Settings;
    server_host::Union{String,Nothing} = nothing,
    server_port::Union{Int64,Bool,Nothing} = nothing,
    ssl_enabled::Union{Bool,Nothing} = nothing,
    open_client::Union{Bool,Nothing} = nothing,
    open_documentation::Union{Bool,Nothing} = nothing,
)
reset_settings(settings::Config.Settings)
```

## Constants
```@docs
SERVER_HOST_DEFAULT
SERVER_PORT_DEFAULT
SSL_ENABLED_DEFAULT
OPEN_CLIENT_DEFAULT
OPEN_DOCUMENTATION_DEFAULT
```
