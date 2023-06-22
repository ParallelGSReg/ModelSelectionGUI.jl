"""
    Jobs

The `Jobs` module provides functions to handle the jobs.
"""
module Jobs
using CSV, DataStructures, DataFrames, Dates, UUIDs
using ModelSelection: gsr, ModelSelectionData

include("const.jl")
include("types/file.jl")
include("types/model_selection_job.jl")
include("types/job_manager.jl")
include("core.jl")

export ModelSelectionJob,
    JobManager,
    File,
    start_task,
    stop_task,
    add_pending_job,
    add_file,
    get_file,
    get_pending_queue_length,
    to_dict,
    ESTIMATOR,
    EQUATION,
    PENDING,
    RUNNING,
    FINISHED,
    FAILED

end # module Jobs
