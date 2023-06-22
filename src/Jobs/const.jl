"""
    PENDING

Symbol representing the pending status. Used to denote that a job is in the queue, but not yet being executed.
"""
const PENDING = :pending

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
    ID

Symbol representing ID. Used as a key in various data structures throughout the application.
"""
const ID = :id

"""
    FILE
Symbol representing file. Used as a key in various data structures throughout the application.
"""
const FILE = :file

"""
    FILENAME

Symbol representing filename. Used as a key in various data structures throughout the application.
"""
const FILENAME = :filename

"""
    FILEHASH

Symbol representing filehash. Used as a key in various data structures throughout the application.
"""
const FILEHASH = :filehash

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
    PARAMETERS

Symbol representing parameters. Used as a key in various data structures throughout the application.
"""
const PARAMETERS = :parameters

"""
    STATUS

Symbol representing the status of an operation. Used as a key in various data structures throughout the application.
"""
const STATUS = :status

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
    MSG

Symbol representing an API message. Used as a key in various data structures throughout the application.
"""
const MSG = :msg
