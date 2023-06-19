"""
    SERVER_PORT

The port number on which the web server will listen. By default, it uses the value of `SERVER_PORT_DEFAULT`.
"""
SERVER_PORT = SERVER_PORT_DEFAULT

"""
    CLIENT_PORT

The port number on which the client will listen. It's set to be one port number higher than the server's listening port (`SERVER_PORT` + 1).
"""
CLIENT_PORT = SERVER_PORT + 1

"""
    OPEN_BROWSER

Open the web browser after starting the server with the documentation. By default, it uses the value of `OPEN_BROWSER_DEFAULT`.
"""
OPEN_BROWSER = OPEN_BROWSER_DEFAULT

"""
    OPEN_CLIENT

Open the web browser after starting the server with the client. By default, it uses the value of `OPEN_CLIENT_DEFAULT`.
"""
OPEN_CLIENT = OPEN_CLIENT_DEFAULT

"""
    SERVER_URL

Defines the base URL of the server. By default, it uses the value of `SERVER_URL_DEFAULT`.
"""
SERVER_URL = SERVER_URL_DEFAULT

"""
    load_envvars(path::String = ENV_FILE_DEFAULT)

Load environment variables from a `.env` file specified by `path`. If a certain environment variable is defined in the file, the corresponding global variable will be updated. Otherwise, the default value will be used.

- `path`: Path to the `.env` file. If not provided, the default path (as defined in `ENV_FILE_DEFAULT`) is used.

Global variables updated by this function are `SERVER_PORT`, `CLIENT_PORT`, `OPEN_BROWSER`, `OPEN_CLIENT`, and `SERVER_URL`.

# Examples
```julia
load_envvars("./path/to/.env")
```
"""
function load_envvars(path::String = ENV_FILE_DEFAULT)
    global SERVER_PORT
    global CLIENT_PORT
    global OPEN_BROWSER
    global OPEN_CLIENT
    global SERVER_URL
    dotenv(path)
    SERVER_PORT =
        ("SERVER_PORT" in keys(ENV)) ? parse(Int64, ENV["SERVER_PORT"]) :
        SERVER_PORT_DEFAULT
    CLIENT_PORT =
        ("CLIENT_PORT" in keys(ENV)) ? parse(Int64, ENV["CLIENT_PORT"]) : SERVER_PORT + 1
    OPEN_BROWSER =
        ("OPEN_BROWSER" in keys(ENV)) ? parse(Bool, ENV["OPEN_BROWSER"]) :
        OPEN_BROWSER_DEFAULT
    OPEN_CLIENT =
        ("OPEN_CLIENT" in keys(ENV)) ? parse(Bool, ENV["OPEN_CLIENT"]) : OPEN_CLIENT_DEFAULT
    SERVER_URL = ("SERVER_URL" in keys(ENV)) ? ENV["SERVER_URL"] : SERVER_URL_DEFAULT
end

"""
    reset_envvars()

Reset environment variables to the default values.

Global variables updated by this function are `SERVER_PORT`, `CLIENT_PORT`, `OPEN_BROWSER`, `OPEN_CLIENT`, and `SERVER_URL`.

# Examples
```julia
reset_envvars()
```
"""
function reset_envvars()
    global SERVER_PORT
    global CLIENT_PORT
    global OPEN_BROWSER
    global OPEN_CLIENT
    global SERVER_URL
    
    SERVER_PORT = SERVER_PORT_DEFAULT
    CLIENT_PORT = SERVER_PORT + 1
    OPEN_BROWSER = OPEN_BROWSER_DEFAULT
    OPEN_CLIENT = OPEN_CLIENT_DEFAULT
    SERVER_URL = SERVER_URL_DEFAULT
end
