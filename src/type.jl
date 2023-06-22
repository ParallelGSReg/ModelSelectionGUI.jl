using Genie

mutable struct Application
    settings::Union{Config.Settings,Nothing}
    gui::GUI.Union{ApplicationGUI,Nothing}
    manager::Union{Jobs.JobManager,Nothing}
    server::Union{Genie.Server.ServersCollection,Nothing}

    function Application(settings::Union{Config.Settings,Nothing} = nothing)
        new(settings)
    end
end
