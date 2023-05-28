using Genie, Genie.Router

function start(;server_port::Int=SERVER_PORT, client_port::Int=CLIENT_PORT, open_browser::Bool=OPEN_BROWSER)
    route("/", home)
    route("/server-info", server_info, method = GET)
    
    route("/upload-file", upload_file, method = POST)
    route("/run/:filehash", run, method = POST)
    route("/status/:id", status, method = GET)
    route("/summary/:id", get_summary, method = GET)
    route("/download-result/:id/:resulttype", download_result, method = GET)

    schedule(Task(consume_job_queue))

    up(server_port, async = true)
    if open_browser
        browser(port=client_port)
    end
end
