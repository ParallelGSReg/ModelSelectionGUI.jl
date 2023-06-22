"""
    open_path(application::ApplicationGUI, name::Symbol, path::String = DEFAULT_PATH)

Opens a new window or update an existing one with the specified `path`. If the window name already exists, updates the window with the new path.

# Arguments
- `application::ApplicationGUI`: The `ApplicationGUI`` object.
- `name::Symbol`: The name of the window to be created or updated.
- `path::String`: The path to open in the window. Default is `DEFAULT_PATH`.

# Returns
- `ApplicationGUI`: The `ApplicationGUI`  object.

# Examples
```julia
application = ApplicationGUI()
open_path(application, :documentation; path = "/docs")
```
"""
function open_path(application::ApplicationGUI, name::Symbol, path::String = DEFAULT_PATH)
    if application.settings === nothing
        error(SETTINGS_NOT_DEFINED_EXCEPTION)
    end
    url = "http://"
    if application.settings.ssl_enabled
        url = "https://"
    end
    url = "$(url)$(application.settings.server_host)"
    if application.settings.server_port !== nothing
        url = "$(url):$(application.settings.server_port)"
    end
    url = "$(url)$(path)"
    return open_url(application, name, url)
end

"""
    open_url(application::ApplicationGUI, name::Symbol; url::String)

Creates a new window or updates an existing one with the specified `url`. If the window name already exists, updates the window with the new url.

# Arguments
- `application::ApplicationGUI`: The `ApplicationGUI` object.
- `name::Symbol`: The name of the window to be created or updated.
- `url::String`: The url to open in the window. If `nothing`, an empty window is opened.

# Returns
- `ApplicationGUI`: The `ApplicationGUI` object.

# Examples
```julia
application = ApplicationGUI()
open_url(application, :documentation; url = "http://localhost/docs")
```
"""
function open_url(
    application::ApplicationGUI,
    name::Symbol,
    url::Union{String,Nothing} = nothing,
)
    create_window(application, name, url)
    return application
end


"""
    initialize_application(application::ApplicationGUI)

Initialize the `ApplicationGUI` by creating a new `Electron.Application` if not already exists. 

# Arguments
- `application::ApplicationGUI`: The `ApplicationGUI` object to be initialized. 

# Returns
- `ApplicationGUI`: The initialized `ApplicationGUI` object.

# Example
```julia
application = ApplicationGUI()
initialize_application(application)
```

# Note
This function is idempotent. If called multiple times on the same `ApplicationGUI`, it will only create the `Electron.Application` on the first call. Subsequent calls will return the `ApplicationGUI` unchanged.
"""
function initialize_application(application::ApplicationGUI)
    if application.app === nothing
        application.app = Application()
    end
    return application
end

"""
    close_application(application::ApplicationGUI)

Close the `ApplicationGUI` by closing the `Electron.Application` and clearing all associated windows.

# Arguments
- `application::ApplicationGUI`: The `ApplicationGUI` object to be closed. 

# Returns
- `ApplicationGUI`: The closed `ApplicationGUI` object.

# Example
```julia
application = ApplicationGUI()
initialize_application(application)
close_application(application)
```

# Note
This function is safe to call even if the `ApplicationGUI` is already closed. If the `Electron.Application` does not exist, the function simply returns the `ApplicationGUI` unchanged.
"""
function close_application(application::ApplicationGUI)
    if application.app === nothing
        return application
    end
    Base.close(application.app)
    application.windows = Dict{Symbol,Electron.Window}()
    application.app = nothing
    return application
end

"""
    create_window(application::ApplicationGUI, name::Symbol, url::Union{String,Nothing} = nothing)

Creates a new window in the `ApplicationGUI`. If the window already exists, its content is replaced.

# Arguments
- `application::ApplicationGUI`: The `ApplicationGUI` object where the window will be created.
- `name::Symbol`: The name of the window to be created.
- `url::Union{String,Nothing} = nothing`: Optional. The URL to be loaded in the window. If not provided, a blank page ("about:blank") is loaded.

# Returns
- `ApplicationGUI`: The updated `ApplicationGUI` object.

# Example
```julia
application = ApplicationGUI()
initialize_application(application)
create_window(application, :myWindow, "http://example.com")
```

# Note
If a window with the same name already exists in the `ApplicationGUI`, its content is replaced by the new URL or a blank page if no URL is provided.
"""
function create_window(
    application::ApplicationGUI,
    name::Symbol,
    url::Union{String,Nothing} = nothing,
)
    initialize_application(application)
    window = get_window(application, name)
    if window !== nothing
        if url === nothing
            load(window, URI("about:blank"))
        else
            load(window, URI(url))
        end
        return application
    end
    if url === nothing
        application.windows[name] = Window(application.app)
    else
        application.windows[name] = Window(application.app, URI(url))
    end
    application.windows[name] = Electron.Window(application.app)
    return application
end

"""
    update_window(application::ApplicationGUI, name::Symbol, url::Union{String,Nothing} = nothing)

Updates the content of a window in the `ApplicationGUI` with the given URL. If the window doesn't exist, a new window is created.

# Arguments
- `application::ApplicationGUI`: The `ApplicationGUI` object where the window resides.
- `name::Symbol`: The name of the window to be updated.
- `url::Union{String,Nothing} = nothing`: Optional. The URL to be loaded in the window. If not provided, a blank page ("about:blank") is loaded.

# Returns
- `ApplicationGUI`: The updated `ApplicationGUI` object.

# Example
```julia
application = ApplicationGUI()
initialize_application(application)
update_window(application, :myWindow, "http://example.com")
```

# Note
If a window with the given name doesn't exist in the `ApplicationGUI`, a new window is created with the provided URL or a blank page if no URL is provided.
"""
function update_window(
    application::ApplicationGUI,
    name::Symbol,
    url::Union{String,Nothing} = nothing,
)
    window = get_window(application, name)
    if window === nothing
        return create_window(application, name, url)
    end
    if url === nothing
        load(window, URI("about:blank"))
    else
        load(window, URI(url))
    end
    return application
end

"""
    close_window(application::ApplicationGUI, name::Symbol)

Closes a specific window within the `ApplicationGUI` instance.

# Arguments
- `application::ApplicationGUI`: The `ApplicationGUI` instance where the window resides.
- `name::Symbol`: The name of the window to be closed.

# Returns
- `ApplicationGUI`: The updated `ApplicationGUI` object.

# Example
```julia
app_gui = ApplicationGUI()
initialize_application(app_gui)
create_window(app_gui, :myWindow)
close_window(app_gui, :myWindow)
```

# Note
If a window with the given name does not exist within the `ApplicationGUI`, the function will return the `ApplicationGUI` object without making any changes.
"""
function close_window(application::ApplicationGUI, name::Symbol)
    window = get_window(application, name)
    if window === nothing
        return application
    end
    Base.close(window)
    delete!(application.windows, name)
    return application
end
"""
    close_all_windows(application::ApplicationGUI)

Closes all windows within the `ApplicationGUI` instance.

# Arguments
- `application::ApplicationGUI`: The `ApplicationGUI` instance whose windows are to be closed.

# Returns
- `ApplicationGUI`: The `ApplicationGUI` object.

# Example
```julia
app_gui = ApplicationGUI()
initialize_application(app_gui)
create_window(app_gui, :myWindow)
create_window(app_gui, :mySecondWindow)
close_all_windows(app_gui)
```
"""
function close_all_windows(application::ApplicationGUI)
    for (name, window) in application.windows
        close_window(application, name)
    end
    return application
end

"""
    get_window(application::ApplicationGUI, name::Symbol)

Returns the window associated with the given `name` or `nothing` if the window does not exists.

# Arguments
- `application::ApplicationGUI`: The `ApplicationGUI` object.
- `name::Symbol`: The name of the window to be fetched.

# Returns
- `Electron.Window`: The window associated with the `name`.
- `nothing`: If the window does not exists.

# Examples
```julia
window = get_window(application, :documentation)
```
"""
function get_window(application::ApplicationGUI, name::Symbol)
    if !haskey(application.windows, name)
        return nothing
    end
    return application.windows[name]
end
