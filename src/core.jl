using Genie, Genie.Router

function start(;server_port::Int=SERVER_PORT, client_port::Int=CLIENT_PORT, open_browser::Bool=OPEN_BROWSER)
    route("/", home)
    route("/server-info", server_info, method = GET)
    route("/upload", upload, method = POST)
    route("/solve/:hash/:options", solve, method = POST)
    route("/result", result, method = GET)

    up(server_port, async = true)
    if open_browser
        browser(port=client_port)
    end
end
