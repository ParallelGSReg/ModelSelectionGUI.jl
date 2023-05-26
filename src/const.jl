using ConfigEnv
dotenv()

const SERVER_BASE_DIR = "../front/dist"
const MODEL_SELECTION_NAME = "ModelSelection"
const MODEL_SELECTION_VERSION = get_pkg_version(MODEL_SELECTION_NAME)

const SERVER_PORT_DEFAULT = 8000
const OPEN_BROWSER_DEFAULT = true
const SERVER_PORT = ("SERVER_PORT" in keys(ENV)) ? parse(Int64, ENV["SERVER_PORT"]) : SERVER_PORT_DEFAULT
const CLIENT_PORT = ("CLIENT_PORT" in keys(ENV)) ? parse(Int64, ENV["CLIENT_PORT"]) : SERVER_PORT + 1
const OPEN_BROWSER = ("OPEN_BROWSER" in keys(ENV)) ? parse(Bool, ENV["OPEN_BROWSER"]) : OPEN_BROWSER_DEFAULT

const FILEHASH = :filehash
const PARAMETERS = :parameters
