using Genie, Genie.Router
using JSON
using ConfigEnv

"""
    start(; server_host::Union{String,Nothing} = nothing, server_port::Union{Int, Nothing} = nothing, client_port::Union{Int, Nothing} = nothing, OPEN_DOCUMENTATION::Union{Bool, Nothing} = nothing, open_client::Union{Bool, Nothing} = nothing, dotenv::String = ENV_FILE_DEFAULT, no_task::Bool = false)

Initiate the server with optional parameters. Default values are loaded from environment variables if the parameters are not provided.
This function also sets up several routes, a WebSocket channel, and initiates a background task.

# Parameters

- `server_host::String`: The server host address.
- `server_port::Int64`: Port number for the server.
- `ssl_enabled::Bool`: Indicates whether SSL encryption is enabled.
- `open_client::Bool`: Indicates whether to open a client window automatically.
- `open_documentation::Bool`: Indicates whether to open a documentation window automatically.
- `dotenv::String`: Specifies the path to the file containing environment variables. Default value is `.env`.
- `no_task::Bool`: If `true`, does not initiate a background task. Dafault value is `false`.

# Example
```julia
start(server_port = 8080, OPEN_DOCUMENTATION = true)
```
"""
function start(;
    server_host::Union{String,Nothing} = nothing,
    server_port::Union{Int,Nothing} = nothing,
    ssl_enabled::Union{Bool,Nothing} = nothing,
    open_documentation::Union{Bool,Nothing} = nothing,
    open_client::Union{Bool,Nothing} = nothing,
    dotenv::String = ENV_FILE_DEFAULT,
    no_task::Bool = false,
)
    load_envvars(dotenv)

    if server_host === nothing
        server_host = SERVER_HOST
    end

    if server_port === nothing
        server_port = SERVER_PORT
    end

    if ssl_enabled === nothing
        ssl_enabled = SSL_ENABLED
    end

    if open_documentation === nothing
        open_documentation = OPEN_DOCUMENTATION
    end

    if open_client === nothing
        open_client = OPEN_CLIENT
    end

    Genie.config.websockets_server = true
    route("/", home_view)
    route("/docs", docs_view)
    route("/server-info", server_info_view, method = GET)
    route("/upload-file", upload_file_view, method = POST)
    route("/job-enqueue/:filehash", job_enqueue_view, method = POST)
    route("/job/:id", job_info_view, method = GET)
    route("/job/:id/results/:resulttype", job_results_view, method = GET)
    Router.channel(
        "/$(string(DEFAULT_WS_CHANNEL))/$(Genie.config.webchannels_subscribe_channel)",
        websocket_channel_view,
    )
    if !no_task
        start_task()
    end
    up(server_port, async = true)
    if open_documentation || open_client
        create_application()
        sleep(3)
        if open_documentation
            open_window(path = "/docs")
        end
        if open_client
            open_window(path = "/")
        end
    end
end

"""
    stop()

Shut down the server, close all windows and stop backgound tasks.

# Example
```julia
stop()
```
"""
function stop()
    stop_task()
    close_windows()
    down()
end
