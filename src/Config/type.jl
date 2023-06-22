"""
    Settings

A mutable struct representing the settings for the server and GUI windows.

# Fields
- `server_host::String`: Server host URL for the application. This is the URL where the server will be running and listening for incoming requests. The default URL is `SERVER_HOST_DEFAULT`.
- `server_port::Union{Int64,Nothing}`: The port number on which the web server will listen. The default port is `SERVER_PORT_DEFAULT`.
- `ssl_enabled::Bool`: Indicates whether SSL is enabled. Default is `SSL_ENABLED_DEFAULT`.
- `open_client::Bool`: Determines whether the client window should be opened at startup. The default value is `OPEN_CLIENT_DEFAULT`.
- `open_documentation::Bool`: Determines whether the documentation window should be opened at startup. The default value is `OPEN_DOCUMENTATION_DEFAULT`.

# Example
```julia
settings = Settings(
    server_host = "127.0.0.1",
    server_port = 8000,
    ssl_enabled = false,
    open_client = false,
    open_documentation = true,
)
```
"""
mutable struct Settings
    server_host::String
    server_port::Union{Int64,Nothing}
    ssl_enabled::Bool
    open_client::Bool
    open_documentation::Bool

    function Settings(;
        server_host::String = SERVER_HOST_DEFAULT,
        server_port::Union{Int64,Nothing} = SERVER_PORT_DEFAULT,
        ssl_enabled::Bool = SSL_ENABLED_DEFAULT,
        open_client::Bool = OPEN_CLIENT_DEFAULT,
        open_documentation::Bool = OPEN_DOCUMENTATION_DEFAULT,
    )
        new(server_host, server_port, ssl_enabled, open_client, open_documentation)
    end
end
