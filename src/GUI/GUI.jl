"""
    GUI

The `GUI` module provides functions to handle GUI operations, such as displaying the interface or documentation pages through windows.
"""
module GUI
import ModelSelectionGUI
import ModelSelectionGUI.Config: Settings
using Electron

include("strings.jl")
include("const.jl")
include("type.jl")
include("core.jl")

export ApplicationGUI,
    open_path,
    open_url,
    initialize_application,
    close_application,
    create_window,
    update_window,
    close_window,
    close_all_windows
end # module GUI
