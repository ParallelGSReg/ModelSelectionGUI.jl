"""
    Config

The `Config` module provides functions to handle environment variables and application settings.
"""
module Config
import ModelSelectionGUI
using ConfigEnv

include("const.jl")
include("type.jl")
include("core.jl")

export Settings,
    load_settings,
    reset_settings,
    SERVER_HOST_DEFAULT,
    SERVER_PORT_DEFAULT,
    SSL_ENABLED_DEFAULT,
    OPEN_CLIENT_DEFAULT,
    OPEN_DOCUMENTATION_DEFAULT
end # module Config
