"""
    CSV_MIME

String representing the MIME type for CSV files. Used when handling CSV file data within the application.
"""
const CSV_MIME = "text/csv"

"""
    PLAIN_MIME

String representing the MIME type for CSV files. Used when handling plain txt file data within the application.
"""
const PLAIN_MIME = "text/plain"

"""
    DEFAULT_WS_CHANNEL

Symbol representing the default WebSockets channel. Used as a key in various data structures throughout the application.
"""
const DEFAULT_WS_CHANNEL = :sync

"""
    MODEL_SELECTION_VERSION

Symbol representing the version of the Model Selection package. Used as a key in an API response.
"""
const MODEL_SELECTION_VERSION = :model_selection_version

"""
    NCORES

Symbol representing the number of cores. Used as a key in an API response.
"""
const NCORES = :ncores

"""
    NWORKERS

Symbol representing the number of workers. Used as a key in an API response.
"""
const NWORKERS = :nworkers

"""
    JOBS_QUEUE_SIZE

Symbol representing the size of the jobs queue. Used as a key in various data structures throughout the application.
"""
const JOBS_QUEUE_SIZE = :jobs_queue_size

"""
    JULIA_VERSION

Symbol representing the Julia version. Used as a key in various data structures throughout the application.
"""
const JULIA_VERSION = :julia_version

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
