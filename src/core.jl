using Genie, Genie.Router
using JSON
using SwagUI

options = Options()
options.show_explorer = false
swagger_document = JSON.parsefile("./docs/swagger/swagger.json")

function start(;
    server_port::Int = SERVER_PORT,
    client_port::Int = CLIENT_PORT,
    open_browser::Bool = OPEN_BROWSER,
    open_client::Bool = OPEN_CLIENT,
)
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
