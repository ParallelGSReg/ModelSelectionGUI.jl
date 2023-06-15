using Genie, Genie.Router
using JSON
using SwagUI
using ConfigEnv

options = Options()
options.show_explorer = false
swagger_document = JSON.parsefile("./docs/swagger/swagger.json")

function start(;
    server_port::Union{Int, Nothing} = nothing,
    client_port::Union{Int, Nothing} = nothing,
    open_browser::Union{Bool, Nothing} = nothing,
    open_client::Union{Bool, Nothing} = nothing,
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
        render_swagger(swagger_document, options=options)
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
    if open_browser
        browser(path="/docs", port = server_port)
    end
    if open_client
        browser(port = client_port)
    end
end

function stop()
    down()
end
