using Genie, Genie.Router
using JSON
using SwagUI
using ConfigEnv

options = Options()
options.show_explorer = false
swagger_document = JSON.parsefile("./docs/swagger/swagger.json")

"""
    start(; server_port::Union{Int, Nothing} = nothing, client_port::Union{Int, Nothing} = nothing, open_browser::Union{Bool, Nothing} = nothing, open_client::Union{Bool, Nothing} = nothing, dotenv::String = ENV_FILE_DEFAULT)

Initiate the server with optional parameters. Default values are loaded from environment variables if the parameters are not provided.

- `server_port`: Port number for the server. If `nothing`, the default server port (as defined in the environment variables) is used.
- `client_port`: Port number for the client. If `nothing`, the default client port (as defined in the environment variables) is used.
- `open_browser`: If `true`, opens a new browser window with the server port after server starts. If `nothing`, follows the default setting in the environment variables.
- `open_client`: If `true`, opens a new browser window with the client port after server starts. If `nothing`, follows the default setting in the environment variables.
- `dotenv`: Specifies the path to the file containing environment variables.

This function also sets up several routes, a WebSocket channel, and initiates a background task.

# Examples
```julia
start(server_port = 8080, open_browser = true)
```
"""
function start(;
    server_port::Union{Int,Nothing} = nothing,
    client_port::Union{Int,Nothing} = nothing,
    open_browser::Union{Bool,Nothing} = nothing,
    open_client::Union{Bool,Nothing} = nothing,
    dotenv::String = ENV_FILE_DEFAULT,
)
    load_dotenv(dotenv)

    if server_port === nothing
        server_port = SERVER_PORT
    end

    if client_port === nothing
        client_port = CLIENT_PORT
    end

    if open_browser === nothing
        open_browser = OPEN_BROWSER
    end

    if open_client === nothing
        open_client = OPEN_CLIENT
    end

    Genie.config.websockets_server = true
    route("/", home_view)
    route("/docs") do
        render_swagger(swagger_document, options = options)
    end

    route("/server-info", server_info_view, method = GET)
    route("/upload-file", upload_file_view, method = POST)
    route("/job-enqueue/:filehash", job_enqueue_view, method = POST)
    route("/job/:id", job_info_view, method = GET)
    route("/job/:id/results/:resulttype", job_results_view, method = GET)
    Router.channel(
        "/$(string(DEFAULT_WS_CHANNEL))/$(Genie.config.webchannels_subscribe_channel)",
        websocket_channel_view,
    )
    schedule(Task(consume_job_queue))
    up(server_port, async = true)
    if open_browser || open_client
        sleep(3)
        if open_browser
            browser(path = "/docs", port = server_port)
        end
        if open_client
            browser(port = client_port)
        end
    end
end

"""
    stop()

Shut down the server.

This function calls the `down()` function to stop the server.

# Examples
```julia
stop()
```
"""
function stop()
    down()
end
