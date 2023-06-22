using Genie, Genie.Router
using JSON


function start(application::Application, settings::Union{Config.Settings,Nothing} = nothing)
    if settings !== nothing
        application.settings = settings
    end
    if application.gui === nothing
        application.gui = GUI.ApplicationGUI(settings)
    end
    if application.manager === nothing
        application.manager = Jobs.JobManager(ModelSelectionGUI.job_notify)
    end

    Genie.config.websockets_server = true
    Router.route("/", frontend_view)
    Router.route("/docs", docs_view)
    Router.route("/server-info", server_info_view, method = GET)
    Router.route("/upload-file", upload_file_view, method = POST)
    Router.route("/job-enqueue/:filehash", job_enqueue_view, method = POST)
    Router.route("/job/:id", job_info_view, method = GET)
    Router.route("/job/:id/results/:resulttype", job_results_view, method = GET)
    Router.channel("/$(string(DEFAULT_WS_CHANNEL))/$(Genie.config.webchannels_subscribe_channel)", websocket_channel_view)

    start_task(application.manager)
    application.server = up(settings.server_port, settings.server_host, async = true)
    if settings.open_client || settings.open_documentation
        initialize_application(application.gui)
        if settings.open_client
            open_path(application.gui, :documentation, "/docs")
        end
        if settings.open_documentation
            open_path(application.gui, :frontend)
        end
    end
    APPLICATION = application
end

function stop(application::Application)
    stop_task(application.manager)
    close_application(application.gui)
    application.server = down()
end
