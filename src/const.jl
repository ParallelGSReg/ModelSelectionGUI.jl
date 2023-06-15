const MODEL_SELECTION_NAME = "ModelSelection"
const MODEL_SELECTION_VER = get_pkg_version(MODEL_SELECTION_NAME)

const ENV_FILE_DEFAULT = ".env"
const SERVER_PORT_DEFAULT = 8000
const OPEN_BROWSER_DEFAULT = false
const OPEN_CLIENT_DEFAULT = false
const SERVER_URL_DEFAULT = "http://127.0.0.1"

const TEMP_FILENAME = :temp_filename
const FILENAME = :filename
const FILEHASH = :filehash
const PARAMETERS = :parameters
const DATA = :data
const MESSAGE = :message
const ID = :id

const NCORES = :ncores
const NWORKERS = :nworkers
const MODEL_SELECTION_VERSION = :model_selection_version
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
const DEFAULT_WS_CHANNEL = :sync
const RESULTS = :results

const CSV_MIME = "text/csv"
