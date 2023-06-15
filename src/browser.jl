"""
    browser(; path::Union{String, Nothing} = nothing, port::Int64 = CLIENT_PORT)

Open a new browser window with the specified `path` and `port` on the server. The server URL is taken from the `SERVER_URL` global variable.

- `path`: Optional string specifying the path on the server to open in the browser. If `nothing`, the root path of the server is opened.
- `port`: Port number to use. If not provided, the default client port (as defined in `CLIENT_PORT`) is used.

This function supports Windows, MacOS, and Linux operating systems.

# Examples
```julia
browser(path = "/docs", port = 8080)
```
"""
function browser(; path::Union{String,Nothing} = nothing, port::Int64 = CLIENT_PORT)
    url = "$(SERVER_URL):$(string(port))"
    if path !== nothing
        url *= path
    end
    if Sys.iswindows()
        run(`cmd /c start $url`)
    else
        start = (Sys.isapple() ? "open" : "xdg-open")
        run(Cmd([start, url]))
    end
end
