using Electron

"""
    create_application()

Create a new Electron application.

This function creates a new Electron application by closing any existing Electron application
and initializing a new `Application` object.

# Example
```julia
create_application()
```
"""
function create_application()
    global ELECTRON_APPLICATION
    if ELECTRON_APPLICATION !== nothing
        try
            Electron.close(ELECTRON_APPLICATION)
        catch
        end
        ELECTRON_APPLICATION = nothing
    end
    ELECTRON_APPLICATION = Application()
end

"""
    open_window(; path::Union{String, Nothing} = nothing)

Open a window with the specified `path` of the server. The server host and port are taken from the `SERVER_HOST` and `SERVER_PORT` global variable.

- `path`: Optional string specifying the path on the server to open in the window. If `nothing`, the root path of the server is opened.

# Example
```julia
open_window(path = "/docs")
```
"""
function open_window(; path::Union{String,Nothing} = nothing)
    url = get_url_from_path(path)
    open_window(url)
end

"""
    open_window(url::String)

Open a window with the specified `url`.

- `url`: String specifying the url to open in the window. If `nothing`.

# Example
```julia
open_window("http://localhost:8000")
```
"""
function open_window(url::String)
    global ELECTRON_APPLICATION
    Window(ELECTRON_APPLICATION, URI(url))
end

"""
    close_windows()

Open a window with the specified `url`.

- `url`: String specifying the url to open in the window. If `nothing`.

# Example
```julia
close_windows(path = "/docs", port = 8080)
```
"""
function close_windows()
    global ELECTRON_APPLICATION
    if ELECTRON_APPLICATION === nothing
        return
    end
    try
        Electron.close(ELECTRON_APPLICATION)
    catch
    end
end

"""
    get_url_from_path(path::Union{String,Nothing} = nothing)

Generates a URL string based on the provided path and global settings `SERVER_HOST`, 
`SERVER_PORT`, and `SSL_ENABLED`.

# Parameters
- `path::Union{String,Nothing}`: an optional argument which denotes the specific path to be appended 
  to the base URL. If not provided, the function generates a base URL only.

# Returns
- `String`: The URL as a string.

# Example
```julia
url = get_url_from_path("/api/data")
```
"""
function get_url_from_path(path::Union{String,Nothing} = nothing)
    url = "http://"
    if SSL_ENABLED
        url = "https://"
    end
    url = "$(url)$(SERVER_HOST)"
    if !((SSL_ENABLED && SERVER_PORT == 443) || (!SSL_ENABLED && SERVER_PORT == 80))
        url *= ":$(string(SERVER_PORT))"
    end
    if path !== nothing
        url *= path
    end
    return url
end
