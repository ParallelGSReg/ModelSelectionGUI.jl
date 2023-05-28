using ConfigEnv
dotenv()

const SERVER_BASE_DIR = "../front/dist"
const MODEL_SELECTION_NAME = "ModelSelection"
const MODEL_SELECTION_VER = get_pkg_version(MODEL_SELECTION_NAME)

const SERVER_PORT_DEFAULT = 8000
const OPEN_BROWSER_DEFAULT = true
const SERVER_PORT = ("SERVER_PORT" in keys(ENV)) ? parse(Int64, ENV["SERVER_PORT"]) : SERVER_PORT_DEFAULT
const CLIENT_PORT = ("CLIENT_PORT" in keys(ENV)) ? parse(Int64, ENV["CLIENT_PORT"]) : SERVER_PORT + 1
const OPEN_BROWSER = ("OPEN_BROWSER" in keys(ENV)) ? parse(Bool, ENV["OPEN_BROWSER"]) : OPEN_BROWSER_DEFAULT

const TEMPFILE = :tempfile
const FILENAME = :filename
const FILEHASH = :filehash
const PARAMETERS = :parameters
const DATA = :data

const NCORES = :ncores
const NWORKERS = :nworkers
const MODEL_SELECTION_VERSION = :model_selecion_version
const JULIA_VERSION = :julia_version
const JOBS_QUEUE_SIZE = :jobs_queue_size
const STATUS = :status
const JOB_ID = :job_id
const ENQUEUED = :enqueued
const RUNNING = :running
const FINISHED = :finished
const FAILED = :failed
const PENDING = :pending

const ESTIMATOR = :estimator
const EQUATION = :equation
const DATANAMES = :datanames
const NOBS = :nobs

const ALLSUBSETREGRESSION = :allsubsetregression
const CROSSVALIDATION = :crossvalidation
const SUMMARY = :summary
const AVAILABLE_RESULTS_TYPES = [ALLSUBSETREGRESSION, CROSSVALIDATION, SUMMARY]
