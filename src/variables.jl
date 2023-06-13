SERVER_PORT = SERVER_PORT_DEFAULT
CLIENT_PORT = SERVER_PORT + 1
OPEN_BROWSER = OPEN_BROWSER_DEFAULT
OPEN_CLIENT = OPEN_CLIENT_DEFAULT
SERVER_URL = SERVER_URL_DEFAULT

function load_dotenv(path::String = ENV_FILE_DEFAULT)
    global SERVER_PORT
    global CLIENT_PORT
    global OPEN_BROWSER
    global OPEN_CLIENT
    global SERVER_URL
    dotenv(path)
    SERVER_PORT =
        ("SERVER_PORT" in keys(ENV)) ? parse(Int64, ENV["SERVER_PORT"]) : SERVER_PORT_DEFAULT
    CLIENT_PORT =
        ("CLIENT_PORT" in keys(ENV)) ? parse(Int64, ENV["CLIENT_PORT"]) : SERVER_PORT + 1
    OPEN_BROWSER =
        ("OPEN_BROWSER" in keys(ENV)) ? parse(Bool, ENV["OPEN_BROWSER"]) : OPEN_BROWSER_DEFAULT
    OPEN_CLIENT =
        ("OPEN_CLIENT" in keys(ENV)) ? parse(Bool, ENV["OPEN_CLIENT"]) : OPEN_CLIENT_DEFAULT
    SERVER_URL = 
        ("SERVER_URL" in keys(ENV)) ? ENV["SERVER_URL"] : SERVER_URL_DEFAULT
end
