module ModelSelectionGUI
using ModelSelection

APPLICATION = nothing

include("Config/Config.jl")
include("Jobs/Jobs.jl")
include("GUI/GUI.jl")

include("type.jl")

include("strings.jl")
include("utils.jl")
include("const.jl")
include("exceptions.jl")
include("views.jl")
include("core.jl")

export start, stop, to_dict
export
    Settings,
    load_settings,
    reset_settings,
    SERVER_HOST_DEFAULT,
    SERVER_PORT_DEFAULT,
    SSL_ENABLED_DEFAULT,
    OPEN_CLIENT_DEFAULT,
    OPEN_DOCUMENTATION_DEFAULT

end # module ModelSelectionGUI
