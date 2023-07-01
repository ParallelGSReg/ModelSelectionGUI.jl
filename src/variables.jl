"""
    SERVER_HOST

Defines the base URL of the server. By default, it uses the value of `SERVER_HOST_DEFAULT`.
"""
SERVER_HOST = SERVER_HOST_DEFAULT

"""
    SERVER_PORT

The port number on which the web server will listen. By default, it uses the value of `SERVER_PORT_DEFAULT`.
"""
SERVER_PORT = SERVER_PORT_DEFAULT

"""
    SSL_ENABLED

Determines whether SSL (Secure Socket Layer) is enabled in the application.
"""
SSL_ENABLED = SSL_ENABLED_DEFAULT

"""
    OPEN_DOCUMENTATION

Open a window after starting the server with the documentation. By default, it uses the value of `OPEN_DOCUMENTATION_DEFAULT`.
"""
OPEN_DOCUMENTATION = OPEN_DOCUMENTATION_DEFAULT

"""
    OPEN_CLIENT

Open a window after starting the server with the client. By default, it uses the value of `OPEN_CLIENT_DEFAULT`.
"""
OPEN_CLIENT = OPEN_CLIENT_DEFAULT

"""
    ELECTRON_APPLICATION

Global variable that holds an instance of an Electron application. 
It is initialized to `nothing`, indicating that no instance of the application has been created yet.
"""
ELECTRON_APPLICATION = nothing

"""
    JOB_TASK

Global variable that holds the task that runs asynchronously being executed.
"""
JOB_TASK = nothing

"""
    load_envvars(path::String = ENV_FILE_DEFAULT)

Load environment variables from a `.env` file specified by `path`. If a certain environment variable is not defined in the file, the default value will be used.

# Parameters
- `path:String`: Path to the `.env` file. If not provided, the default path (as defined in `ENV_FILE_DEFAULT`) is used.

# Example
```julia
load_envvars("./path/to/.env")
```
"""
function load_envvars(path::String = ENV_FILE_DEFAULT)
    dotenv(path)
    set_envvars(
        server_host = ("SERVER_HOST" in keys(ENV)) ? ENV["SERVER_HOST"] : SERVER_HOST_DEFAULT,
        server_port = ("SERVER_PORT" in keys(ENV)) ? parse(Int64, ENV["SERVER_PORT"]) : SERVER_PORT_DEFAULT,
        ssl_enabled = ("SSL_ENABLED" in keys(ENV)) ? parse(Bool, ENV["SSL_ENABLED"]) : SSL_ENABLED_DEFAULT,
        open_documentation = ("OPEN_CLIENT" in keys(ENV)) ? parse(Bool, ENV["OPEN_CLIENT"]) : OPEN_CLIENT_DEFAULT,
        open_client = ("OPEN_DOCUMENTATION" in keys(ENV)) ? parse(Bool, ENV["OPEN_DOCUMENTATION"]) : OPEN_DOCUMENTATION_DEFAULT,
    )
end

"""
    set_envvars(;
        server_host::Union{String,Nothing} = nothing,
        server_port::Union{Int64,Nothing} = nothing,
        ssl_enabled::Union{Bool,Nothing} = nothing,
        open_documentation::Union{Bool,Nothing} = nothing,
        open_client::Union{Bool,Nothing} = nothing,
    )

Set environment variables. If a certain environment variable is not defined in the file, the corresponding global variable will be updated.

# Parameters
- `server_host::Union{String, Nothing}`: The server host address.
- `server_port::Union{Int64, Nothing}`: The server port number.
- `ssl_enabled::Union{Bool, Nothing}`: Indicates whether SSL encryption is enabled.
- `open_client::Union{Bool, Nothing}`: Indicates whether to open the client automatically.
- `open_documentation::Union{Bool, Nothing}`: Indicates whether to open the documentation automatically.

# Globals
- `SERVER_HOST::String`: The server host address.
- `SERVER_PORT::Int64`: The server port number.
- `SSL_ENABLED::Bool`: Indicates whether SSL encryption is enabled.
- `OPEN_DOCUMENTATION::Bool`: Indicates whether to open the documentation automatically.
- `OPEN_CLIENT::Bool`: Indicates whether to open the client automatically.

# Example
```julia
set_envvars(
    server_host = "localhost",
    server_port = 8000,
    ssl_enabled = false,
    open_client = true,
    open_documentation = true,
)
```
"""
function set_envvars(;
    server_host::Union{String,Nothing} = nothing,
    server_port::Union{Int64,Nothing} = nothing,
    ssl_enabled::Union{Bool,Nothing} = nothing,
    open_client::Union{Bool,Nothing} = nothing,
    open_documentation::Union{Bool,Nothing} = nothing,
)
    global SERVER_HOST
    global SERVER_PORT
    global SSL_ENABLED
    global OPEN_CLIENT
    global OPEN_DOCUMENTATION
    if server_host !== nothing
        SERVER_HOST = server_host
    end
    if server_port !== nothing
        SERVER_PORT = server_port
    end
    if ssl_enabled !== nothing
        SSL_ENABLED = ssl_enabled
    end
    if open_client !== nothing
        OPEN_CLIENT = open_client
    end
    if open_documentation !== nothing
        OPEN_DOCUMENTATION = open_documentation
    end
end

"""
    reset_envvars()

Reset environment variables to the default values.

# Globals
- `SERVER_HOST::String`: The server host address.
- `SERVER_PORT::Int64`: The server port number.
- `SSL_ENABLED::Bool`: Indicates whether SSL encryption is enabled.
- `OPEN_DOCUMENTATION::Bool`: Indicates whether to open the documentation automatically.
- `OPEN_CLIENT::Bool`: Indicates whether to open the client automatically.

# Example
```julia
reset_envvars()
```
"""
function reset_envvars()
    global SERVER_HOST
    global SERVER_PORT
    global SSL_ENABLED
    global OPEN_DOCUMENTATION
    global OPEN_CLIENT

    SERVER_HOST = SERVER_HOST_DEFAULT
    SERVER_PORT = SERVER_PORT_DEFAULT
    SSL_ENABLED = SSL_ENABLED_DEFAULT
    OPEN_DOCUMENTATION = OPEN_DOCUMENTATION_DEFAULT
    OPEN_CLIENT = OPEN_CLIENT_DEFAULT
end
