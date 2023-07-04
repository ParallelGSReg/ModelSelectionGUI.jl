@safetestset "Test const" begin
    using ModelSelectionGUI

    MODEL_SELECTION_NAME = "ModelSelection"
    MODEL_SELECTION_VER = ModelSelectionGUI.get_pkg_version(MODEL_SELECTION_NAME)
    ENV_FILE_DEFAULT = ".env"
    SERVER_HOST_DEFAULT = "127.0.0.1"
    SERVER_PORT_DEFAULT = 8000
    SSL_ENABLED_DEFAULT = false
    OPEN_DOCUMENTATION_DEFAULT = false
    OPEN_CLIENT_DEFAULT = false
    DATA = :data
    FILEHASH = :filehash
    FILENAME = :filename
    ID = :id
    MESSAGE = :message
    PARAMETERS = :parameters
    TEMP_FILENAME = :temp_filename
    NCORES = :ncores
    NWORKERS = :nworkers
    MODEL_SELECTION_VERSION = :model_selection_version
    JULIA_VERSION = :julia_version
    PENDING_QUEUE_SIZE = :jobs_queue_size
    STATUS = :status
    ENQUEUED = :enqueued
    RUNNING = :running
    FINISHED = :finished
    FAILED = :failed
    PENDING = :pending
    ESTIMATOR = :estimator
    EQUATION = :equation
    DATANAMES = :datanames
    NOBS = :nobs
    TIME_ENQUEUED = :time_enqueued
    TIME_STARTED = :time_started
    TIME_FINISHED = :time_finished
    MSG = :msg
    ALLSUBSETREGRESSION = :allsubsetregression
    CROSSVALIDATION = :crossvalidation
    SUMMARY = :summary
    AVAILABLE_RESULTS_TYPES = [ALLSUBSETREGRESSION, CROSSVALIDATION, SUMMARY]
    DEFAULT_WS_CHANNEL = :sync
    RESULTS = :results
    CSV_MIME = "text/csv"
    PLAIN_MIME = "text/plain"

    @test ModelSelectionGUI.MODEL_SELECTION_NAME == MODEL_SELECTION_NAME
    @test ModelSelectionGUI.MODEL_SELECTION_VER == MODEL_SELECTION_VER
    @test ModelSelectionGUI.ENV_FILE_DEFAULT == ENV_FILE_DEFAULT
    @test ModelSelectionGUI.SERVER_HOST_DEFAULT == SERVER_HOST_DEFAULT
    @test ModelSelectionGUI.SERVER_PORT_DEFAULT == SERVER_PORT_DEFAULT
    @test ModelSelectionGUI.SSL_ENABLED_DEFAULT == SSL_ENABLED_DEFAULT
    @test ModelSelectionGUI.OPEN_DOCUMENTATION_DEFAULT == OPEN_DOCUMENTATION_DEFAULT
    @test ModelSelectionGUI.OPEN_CLIENT_DEFAULT == OPEN_CLIENT_DEFAULT
    @test ModelSelectionGUI.DATA == DATA
    @test ModelSelectionGUI.FILEHASH == FILEHASH
    @test ModelSelectionGUI.FILENAME == FILENAME
    @test ModelSelectionGUI.ID == ID
    @test ModelSelectionGUI.MESSAGE == MESSAGE
    @test ModelSelectionGUI.PARAMETERS == PARAMETERS
    @test ModelSelectionGUI.TEMP_FILENAME == TEMP_FILENAME
    @test ModelSelectionGUI.NCORES == NCORES
    @test ModelSelectionGUI.NWORKERS == NWORKERS
    @test ModelSelectionGUI.MODEL_SELECTION_VERSION == MODEL_SELECTION_VERSION
    @test ModelSelectionGUI.JULIA_VERSION == JULIA_VERSION
    @test ModelSelectionGUI.PENDING_QUEUE_SIZE == PENDING_QUEUE_SIZE
    @test ModelSelectionGUI.STATUS == STATUS
    @test ModelSelectionGUI.ENQUEUED == ENQUEUED
    @test ModelSelectionGUI.RUNNING == RUNNING
    @test ModelSelectionGUI.FINISHED == FINISHED
    @test ModelSelectionGUI.FAILED == FAILED
    @test ModelSelectionGUI.PENDING == PENDING
    @test ModelSelectionGUI.ESTIMATOR == ESTIMATOR
    @test ModelSelectionGUI.EQUATION == EQUATION
    @test ModelSelectionGUI.DATANAMES == DATANAMES
    @test ModelSelectionGUI.NOBS == NOBS
    @test ModelSelectionGUI.TIME_ENQUEUED == TIME_ENQUEUED
    @test ModelSelectionGUI.TIME_STARTED == TIME_STARTED
    @test ModelSelectionGUI.TIME_FINISHED == TIME_FINISHED
    @test ModelSelectionGUI.MSG == MSG
    @test ModelSelectionGUI.ALLSUBSETREGRESSION == ALLSUBSETREGRESSION
    @test ModelSelectionGUI.CROSSVALIDATION == CROSSVALIDATION
    @test ModelSelectionGUI.SUMMARY == SUMMARY
    for i = 1:length(ModelSelectionGUI.AVAILABLE_RESULTS_TYPES)
        @test ModelSelectionGUI.AVAILABLE_RESULTS_TYPES[i] == AVAILABLE_RESULTS_TYPES[i]
    end
    @test ModelSelectionGUI.DEFAULT_WS_CHANNEL == DEFAULT_WS_CHANNEL
    @test ModelSelectionGUI.RESULTS == RESULTS
    @test ModelSelectionGUI.CSV_MIME == CSV_MIME
    @test ModelSelectionGUI.PLAIN_MIME == PLAIN_MIME
end
