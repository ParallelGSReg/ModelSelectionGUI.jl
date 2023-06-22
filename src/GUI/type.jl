"""
    ApplicationGUI

A mutable struct represents a GUI application with a set of windows and optional settings.

# Fields
- `app::Union{Application,Nothing}`: The `Electron.Application` object.
- `windows::Dict{Symbol,Electron.Window}`: This is a dictionary where the keys are Symbols representing window names, and the values are Electron.Window objects representing the windows of the application.
- `settings::Union{Settings,Nothing}`: Indicates whether SSL is enabled. Default is `SSL_ENABLED_DEFAULT`.
- `open_client::Bool`: The Settings object holds the configuration parameters for the application.

# Example
````julia
settings = Settings()
application = ApplicationGUI() # Creates an application without settings
application = ApplicationGUI(settings) # Creates an application with settings
```
"""
mutable struct ApplicationGUI
    app::Union{Application,Nothing}
    windows::Dict{Symbol,Electron.Window}
    settings::Union{Settings,Nothing}

    function ApplicationGUI(settings::Union{Settings,Nothing} = nothing)
        new(nothing, Dict{Symbol,Electron.Window}(), settings)
    end
end
