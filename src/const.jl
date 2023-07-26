"""
    MODEL_SELECTION_NAME

Name of the ModelSelection package.
"""
const MODEL_SELECTION_NAME = "ModelSelection"

"""
    MODEL_SELECTION_VER

Version of the ModelSelection package.
"""
const MODEL_SELECTION_VER = get_pkg_version(MODEL_SELECTION_NAME)

"""
    ENV_FILE_DEFAULT

Default path for the .env file used for storing environment variables. The default path is `.envv.
"""
const ENV_FILE_DEFAULT = ".env"

"""
    SERVER_HOST_DEFAULT

Default base URL for the server. The default URL is `127.0.0.1`.
"""
const SERVER_HOST_DEFAULT = "127.0.0.1"

"""
    SERVER_PORT_DEFAULT

Default port number for the server. The default port is `8000`.
"""
const SERVER_PORT_DEFAULT = 8000

"""
    SSL_ENABLED_DEFAULT

Default value for whether SSL (Secure Socket Layer) is enabled in the application. The default value is `false`.
"""
const SSL_ENABLED_DEFAULT = false

"""
    OPEN_CLIENT_DEFAULT

Whether to open a window with the client automatically when the server starts. The default value is `false`.
"""
const OPEN_CLIENT_DEFAULT = false

"""
    OPEN_DOCUMENTATION_DEFAULT

Whether to open a window with documentation automatically when the server starts for Swagger documentation. The default value is `false`.
"""
const OPEN_DOCUMENTATION_DEFAULT = false

"""
    DATA

Symbol key representing data. Used as a key in various data structures throughout the application.
"""
const DATA = :data

"""
    FILEHASH

Symbol representing filehash. Used as a key in various data structures throughout the application.
"""
const FILEHASH = :filehash

"""
    FILENAME

Symbol representing filename. Used as a key in various data structures throughout the application.
"""
const FILENAME = :filename

"""
    ID

Symbol representing ID. Used as a key in various data structures throughout the application.
"""
const ID = :id

"""
    MESSAGE

Symbol representing message. Used as a key in various data structures throughout the application.
"""
const MESSAGE = :message

"""
    PARAMETERS

Symbol representing parameters. Used as a key in various data structures throughout the application.
"""
const PARAMETERS = :parameters

"""
    TEMP_FILENAME

Symbol representing temporary filename. Used as a key in various data structures throughout the application.
"""
const TEMP_FILENAME = :temp_filename

"""
    NCORES

Symbol representing the number of cores. Used as a key in various data structures throughout the application.
"""
const NCORES = :ncores

"""
    NWORKERS

Symbol representing the number of workers. Used as a key in various data structures throughout the application.
"""
const NWORKERS = :nworkers

"""
    MODEL_SELECTION_VERSION

Symbol representing the version of the Model Selection package. Used as a key in various data structures throughout the application.
"""
const MODEL_SELECTION_VERSION = :model_selection_version

"""
    JULIA_VERSION

Symbol representing the Julia version. Used as a key in various data structures throughout the application.
"""
const JULIA_VERSION = :julia_version

"""
    PENDING_QUEUE_SIZE

Symbol representing the size of the jobs queue. Used as a key in various data structures throughout the application.
"""
const PENDING_QUEUE_SIZE = :jobs_queue_size

"""
    STATUS

Symbol representing the status of an operation. Used as a key in various data structures throughout the application.
"""
const STATUS = :status

"""
    ENQUEUED

Symbol representing the enqueued status. Used to denote that a job has been added to the queue.
"""
const ENQUEUED = :enqueued

"""
    RUNNING

Symbol representing the running status. Used to denote that a job is currently being executed.
"""
const RUNNING = :running

"""
    FINISHED

Symbol representing the finished status. Used to denote that a job has completed execution.
"""
const FINISHED = :finished

"""
    FAILED

Symbol representing the failed status. Used to denote that a job has failed to execute.
"""
const FAILED = :failed

"""
    PENDING

Symbol representing the pending status. Used to denote that a job is in the queue, but not yet being executed.
"""
const PENDING = :pending

"""
    ESTIMATOR

Symbol representing an estimator. Used as a key in various data structures throughout the application.
"""
const ESTIMATOR = :estimator

"""
    EQUATION

Symbol representing an equation. Used as a key in various data structures throughout the application.
"""
const EQUATION = :equation

"""
    DATANAMES

Symbol representing data names. Used as a key in various data structures throughout the application.
"""
const DATANAMES = :datanames

"""
    NOBS

Symbol representing the number of observations. Used as a key in various data structures throughout the application.
"""
const NOBS = :nobs

"""
    TIME_ENQUEUED

Symbol representing the time that a job is enqueued. Used as a key in various data structures throughout the application.
"""
const TIME_ENQUEUED = :time_enqueued

"""
    TIME_STARTED

Symbol representing the time that a job started. Used as a key in various data structures throughout the application.
"""
const TIME_STARTED = :time_started

"""
    TIME_FINISHED

Symbol representing the time that a job finished. Used as a key in various data structures throughout the application.
"""
const TIME_FINISHED = :time_finished

"""
    MSG

Symbol representing an API message. Used as a key in various data structures throughout the application.
"""
const MSG = :msg

"""
    NAME

Symbol representing a name. Used as a key in various data structures throughout the application.
"""
const NAME = :name

"""
    ERROR 

Symbol representing an error. Used as a key in various data structures throughout the application.
"""
const ERROR = :error

"""
    ALLSUBSETREGRESSION

Symbol representing the All Subset Regression result type. Used as a key in various data structures throughout the application.
"""
const ALLSUBSETREGRESSION = :allsubsetregression

"""
    CROSSVALIDATION

Symbol representing the Cross Validation result type. Used as a key in various data structures throughout the application.
"""
const CROSSVALIDATION = :crossvalidation

"""
    SUMMARY

Symbol representing the Summary result type. Used as a key in various data structures throughout the application.
"""
const SUMMARY = :summary

"""
    AVAILABLE_RESULTS_TYPES

Array containing symbols that represent the different types of results available in the application.
"""
const AVAILABLE_RESULTS_TYPES = [ALLSUBSETREGRESSION, CROSSVALIDATION, SUMMARY]

"""
    DEFAULT_WS_CHANNEL

Symbol representing the default WebSockets channel. Used as a key in various data structures throughout the application.
"""
const DEFAULT_WS_CHANNEL = :sync

"""
    RESULTS

Symbol representing results. Used as a key in various data structures throughout the application.
"""
const RESULTS = :results

"""
    CSV_MIME

MIME type for CSV files.
"""
const CSV_MIME = "text/csv"

"""
    PLAIN_MIME

MIME type for CSV files.
"""
const PLAIN_MIME = "text/plain"

"""
    SWAGGER_DOCUMENT_FILE

The file path of the Swagger document.
"""
const SWAGGER_DOCUMENT_FILE = "./docs/swagger/swagger.json"

"""
    FRONTEND_FILE
The file path of the frontend HTML file.
"""
const FRONTEND_FILE = "./public/index.html"
