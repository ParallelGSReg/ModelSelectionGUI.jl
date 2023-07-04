"""
    MISSING_JOB_ID

This constant is a string template for error messages indicating that a job with a given ID does not exist. 
It's typically used in a context where you're trying to find a job by its ID and the ID does not match any existing job.
"""
const MISSING_JOB_ID = ["The job with id ", " does not exists"]

"""
    FILE_NOT_SENT

This constant is used when a required file was not provided or transmitted as expected in a file operation or request.
"""
const FILE_NOT_SENT = "The file was not sent"

"""
    FILE_NOT_FOUND

This constant is used when a file was expected to be found in a certain location or under a certain name, but wasn't.
"""
const FILE_NOT_FOUND = "The file was not found"

"""
    INVALID_CSV

This constant indicates that a file that was expected to be in the CSV format was not valid CSV.
"""
const INVALID_CSV = "The file is not a valid CSV file"

"""
    FILE_NOT_SAVED

This constant is used when there was a problem or an error when attempting to save a file.
"""
const FILE_NOT_SAVED = "The file could not be saved"

"""
    FILEHASH_NOT_VALID

This constant is a string template for error messages indicating that a given file hash is not valid.
It's typically used when you're validating the hash of a file.
"""
const FILEHASH_NOT_VALID = ["The filehash ", " is not valid"]

"""
    ESTIMATOR_MISSING

This constant is used when an expected estimator was not provided in the context of a model or analysis.
"""
const ESTIMATOR_MISSING = "The estimator was not sent"

"""
    EQUATION_MISSING

This constant is used when an equation, which is required for a particular calculation or operation, was not provided.
"""
const EQUATION_MISSING = "The equation was not sent"

"""
    MISSING_RESULT_TYPE

This constant is used when a result type, which is required to process or categorize an output, is not provided.
"""
const MISSING_RESULT_TYPE = "The result type is missing"

"""
    INVALID_RESULT_TYPE

This constant is a string template for error messages indicating that a given result type is not valid. 
It's typically used in a context where you're trying to request a result by its type and the type does not match any known result types.
"""
const INVALID_RESULT_TYPE =
    ["The result type ", " is not valid. [Available result types: ", "]"]

"""
    JOB_HAS_NOT_RESULTTYPE

This constant is a string template for error messages indicating that a job does not have a result of a specified type.
It's typically used when you're trying to request a result by its type from a job and the job does not have a result of that type.
"""
const JOB_HAS_NOT_RESULTTYPE = "The job does not have a result of type "
