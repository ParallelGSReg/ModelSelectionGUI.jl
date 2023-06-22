"""
    load_settings(
        settings::Settings,
        path::String;
        server_host::Union{String,Nothing} = nothing,
        server_port::Union{Int64,Bool,Nothing} = nothing,
        ssl_enabled::Union{Bool,Nothing} = nothing,
        open_client::Union{Bool,Nothing} = nothing,
        open_documentation::Union{Bool,Nothing} = nothing,
    )

This function loads the environment variables from a dotenv file to a `Settings` object.
If these variables are not defined in the dotenv file, it uses the provided default values.
This function also accepts optional arguments to overwrite these default or dotenv values.

# Arguments
- `settings::Settings`: The `Settings` object to update.
- `path::String`: Path to the dotenv file.
- `ssl_enabled::Union{Bool,Nothing}`: Optional argument to manually set the `SSL_ENABLED`. If `nothing`, the value from .env file or default is used.
- `server_host::Union{String,Nothing}`: Optional argument to manually set the `SERVER_HOST`. If `nothing`, the value from .env file or default is used.
- `server_port::Union{Int64,Bool,Nothing}`: Optional argument to manually set the `SERVER_PORT`. If `nothing`, the value from .env file or default is used. If `false`, the value will be empty.
- `open_client::Union{Bool,Nothing}`: Optional argument to manually set the `OPEN_CLIENT`. If `nothing`, the value from .env file or default is used.
- `open_documentation::Union{Bool,Nothing}`: Optional argument to manually set the `OPEN_DOCUMENTATION`. If `nothing`, the value from .env file or default is used.

# Returns
- `Settings`: The updated `Settings` object.

# Examples
```julia
settings = Settings()
load_settings(settings, ".env")
load_settings(settings, ".env", server_port=8080)
```
"""
function load_settings(
    settings::Settings,
    path::String;
    server_host::Union{String,Nothing} = nothing,
    server_port::Union{Int64,Nothing,Bool} = nothing,
    ssl_enabled::Union{Bool,Nothing} = nothing,
    open_client::Union{Bool,Nothing} = nothing,
    open_documentation::Union{Bool,Nothing} = nothing,
)
    dotenv(path)

    if "SERVER_HOST" in keys(ENV) && server_host === nothing
        server_host = ENV["SERVER_HOST"]
    end

    if "SERVER_PORT" in keys(ENV) && server_port === nothing
        server_port = ENV["SERVER_PORT"]
        if server_port == "false"
            server_port = false
        else
            server_port = parse(Int64, server_port)
        end
    end

    if "SSL_ENABLED" in keys(ENV) && ssl_enabled === nothing
        ssl_enabled = parse(Bool, ENV["SSL_ENABLED"])
    end

    if "OPEN_DOCUMENTATION" in keys(ENV) && open_documentation === nothing
        open_documentation = parse(Bool, ENV["OPEN_DOCUMENTATION"])
    end

    if "OPEN_CLIENT" in keys(ENV) && open_client === nothing
        open_client = parse(Bool, ENV["OPEN_CLIENT"])
    end

    return load_settings(
        settings,
        server_host = server_host,
        server_port = server_port,
        ssl_enabled = ssl_enabled,
        open_client = open_client,
        open_documentation = open_documentation,
    )
end

"""
    load_settings(
        settings::Settings;
        server_host::Union{String,Nothing} = nothing,
        server_port::Union{Int64,Bool,Nothing} = nothing,
        ssl_enabled::Union{Bool,Nothing} = nothing,
        open_client::Union{Bool,Nothing} = nothing,
        open_documentation::Union{Bool,Nothing} = nothing,
    )

This function set the defined variables to a `Settings` object.
If these variables are not defined, it uses the provided default values.

# Arguments
- `settings::Settings`: The `Settings` object to update.
- `server_host::Union{String,Nothing}`: Optional string specifying the server host. If `nothing`, default is used.
- `server_port::Union{Int64,Bool,Nothing}`: Optional integer specifying the server port. If `false`, the value will be empty.  If `nothing`, default is used
- `ssl_enabled::Union{Bool,Nothing}`: Optional boolean specifying whether SSL is enabled. If `nothing`, default is used
- `open_client::Union{Bool,Nothing}`: Optional boolean specifying whether to open the client.  If `nothing`, default is used
- `open_documentation::Union{Bool,Nothing}`: Optional boolean specifying whether to open the documentation.  If `nothing`, default is used

# Returns
- `Settings`: The updated `Settings` object.

# Examples
```julia
settings = Settings()
load_settings(settings, server_host="localhost", server_port=false, ssl_enabled=true)
```
"""
function load_settings(
    settings::Settings;
    server_host::Union{String,Nothing} = nothing,
    server_port::Union{Int64,Bool,Nothing} = nothing,
    ssl_enabled::Union{Bool,Nothing} = nothing,
    open_client::Union{Bool,Nothing} = nothing,
    open_documentation::Union{Bool,Nothing} = nothing,
)
    reset_settings(settings)
    if server_host !== nothing
        settings.server_host = server_host
    end
    if server_port !== nothing
        settings.server_port = server_port
    end
    if server_port == false
        settings.server_port = nothing
    end
    if open_documentation !== nothing
        settings.open_documentation = open_documentation
    end
    if open_client !== nothing
        settings.open_client = open_client
    end
    if ssl_enabled !== nothing
        settings.ssl_enabled = ssl_enabled
    end
    return settings
end

"""
    reset_settings(settings::Settings)

Resets the fields of the given `Settings` object to their default values.

# Arguments
- `settings::Settings`: The `Settings` object to reset.

# Returns
- `Settings`: The updated settings object.

# Examples
```julia
settings = Settings(
    server_host="localhost",
    server_port=8080,
    ssl_enabled=true,
    open_client=true,
    open_documentation=true,
)
reset_settings(settings)
```
"""
function reset_settings(settings::Settings)
    settings.server_host = SERVER_HOST_DEFAULT
    settings.server_port = SERVER_PORT_DEFAULT
    settings.ssl_enabled = SSL_ENABLED_DEFAULT
    settings.open_client = OPEN_CLIENT_DEFAULT
    settings.open_documentation = OPEN_DOCUMENTATION_DEFAULT
    return settings
end
