# Rest API

The Rest API endpoints are the core communication to interact with the backend services. 

## API Endpoints List

- [GET /server-info](#get-server-info)
- [POST /upload-file](#post-upload-file)
- [POST /job-enqueue/:filehash](#post-job-enqueuefilehash)
- [GET /job/:id](#get-jobid)
- [GET /job/:id/results/:type](#get-jobidresulttype)

## API Endpoints Details

### `GET /server-info`

Retrieves information about the server.

#### Response

- Status Code: 200 (OK)
- Body: JSON
    - `julia_version`: The version of Julia running on the server.
    - `model_selection_version`: The version of the ModelSelection package being used.
    - `ncores`: The number of CPU cores available on the server.
    - `nworkers`: The number of workers available for parallel processing.
    - `jobs_queue_size`: The number of jobs currently in the queue.

Example JSON response:
```json
{
    "julia_version": "1.6.7",
    "model_selection_version": "1.2.0",
    "ncores": 8,
    "nworkers": 4,
    "jobs_queue_size": 0
}
```

[Return to the top](#api-endpoints-list)

### `POST /upload-file`

Uploads a CSV file to the server. Upon successful upload, the server will process the uploaded file for further operations.

#### Request

- Method: POST
- Body: form-data
  - Parameter: `data`
    - Description: The CSV file to upload.
    - Type: File

#### Response

- Status Code: 200 (OK).
- Body: JSON
    - `filename`: The name of the uploaded file.
    - `datanames`: The names of the columns in the CSV file.
    - `nobs`: The number of observations (rows) in the CSV file.
    - `filehash`: The unique identifier (UUID) for the uploaded file.

Example JSON response:
```json
{
    "filename": "data.csv",
    "datanames": ["y", "x1", "x2", "x3", "x4", "x5"],
    "nobs": 100,
    "filehash": "6c48451b-af17-43cb-a251-e847abc94472"
}
```

[Return to the top](#api-endpoints-list)


### `POST /job-enqueue/:filehash`

Enqueues a model selection job for the specified file. The task will be executed after the previously queued tasks have finished.

#### Request

- Method: POST
- Query parameter:
    - `filehash`: The unique identifier (UUID) of the uploaded file to perform model selection on.
- Body: JSON
  - `estimator`: The estimator to use for model selection (e.g., `"ols"`).
  - `equation`: The equation or formula specifying the dependent and independent variables.
  - `ttest`: Flag indicating whether to perform t-tests. Default is true.

Example JSON Request:
```json
{
    "estimator": "ols",
    "equation": "y x1 x2 x3",
    "ttest": true,
}
```

**Note:** Please refer to the **ModelSelection** package documentation for additional parameters that can be included in the request.

#### Response

- Status Code: 200 (OK).
- Body: JSON
  - `id`: The unique identifier (UUID) of the model selection job.
  - `filehash`: The unique identifier (UUID) of the file used for model selection.
  - `filename`: The name of the file used for model selection.
  - `status`: The status of the model selection job (`"pending"`, `"running"`, `"finished"`, or `"failed"`).
  - `msg`: A message associated with the status, if any.
  - `time_enqueued`: The timestamp when the model selection job was enqueued.
  - `time_started`: The timestamp when the model selection job started, if applicable.
  - `time_finished`: The timestamp when the model selection job finished, if applicable.
  - `estimator`: The estimator used for model selection.
  - `equation`: The equation or formula used for model selection.
  - `parameters`: The parameters used for model selection, including any additional parameters specified in the request.

Example JSON response:
```json
{
    "id": "adbc7420-1597-4b1b-a798-fafd9ee5f671",
    "filehash": "12413947-95bc-4573-a804-efcb2293e808",
    "filename": "data.csv",
    "status": "pending",
    "msg": null,
    "time_enqueued": "2023-06-07T16:38:11.18",
    "time_started": null,
    "time_finished": null,
    "estimator": "ols",
    "equation": "y x1 x2 x3",
    "parameters": {
        "ttest": true,
    }
}
```

**Note:** The response contains detailed information about the initiated model selection process, including the current status and the parameters used.

[Return to the top](#api-endpoints-list)


### `GET /job/:id`

Retrieves the info of a model selection job. If the job is finished, it also includes the summary of a model selection job.

#### Request

- Method: GET
- Query parameter:
    - `id`: The unique identifier (UUID) of the model selection job.

#### Response

- Status Code: 200 (OK).
- Body: JSON
  - `id`: The unique identifier (UUID) of the model selection job.
  - `filehash`: The unique identifier (UUID) of the file used for model selection.
  - `filename`: The name of the file used for model selection.
  - `status`: The status of the model selection job (`"pending"`, `"running"`, `"finished"`, or `"failed"`).
  - `msg`: A message associated with the status, if any.
  - `time_enqueued`: The timestamp when the model selection job was enqueued.
  - `time_started`: The timestamp when the model selection job started, if applicable.
  - `time_finished`: The timestamp when the model selection job finished, if applicable.
  - `estimator`: The estimator used for model selection.
  - `equation`: The equation or formula used for model selection.
  - `parameters`: The parameters used for model selection, including any additional parameters specified in the request.
  - `results`: The results of the model selection job, including different types of analysis, if finished.

Example JSON response:
```json
{
    "id": "adbc7420-1597-4b1b-a798-fafd9ee5f671",
    "filehash": "12413947-95bc-4573-a804-efcb2293e808",
    "filename": "data.csv",
    "status": "pending",
    "msg": null,
    "time_enqueued": "2023-06-07T16:38:11.18",
    "time_started": null,
    "time_finished": null,
    "estimator": "ols",
    "equation": "y x1 x2 x3",
    "parameters": {
        "ttest": true,
    },
    "results": {
        "crossvalidation": {
            "average": {},
            "median": {}
        },
        "allsubsetregression": {
            "modelavg": {}
        },
    }
}
```

**Note:** The response contains detailed information about the initiated model selection job, including the current status and the parameters used.

[Return to the top](#api-endpoints-list)


### `GET /job/:id/results/:type`

Retrieves the result file of a specific type for a model selection job.

#### Request

- Method: GET
- Query parameters:
  - `id`: The unique identifier (UUID) of the model selection job.
  - `type`: The type of result file to retrieve. Possible values: `summary`, `allsubsetregression`, `crossvalidation`.

#### Response

- Status Code: 200 (OK)
- Body: The response returns the result file in the corresponding format based on the `type` specified.

**Note:** The response should include appropriate headers to indicate the file type and provide options for file download or display. The filename is a concatenation of the original data filename and the type.

Example: If the `type` is `summary` and the response is a plain text file, the following headers can be set:

```
Content-Type: text/plain
Content-Disposition: inline; filename=summary.txt
```

Example: If the `type` is `allsubsetregression` or `crossvalidation` and the response is a CSV file, the following headers can be set:

```
Content-Type: text/csv
Content-Disposition: attachment; filename=result.csv
```

[Return to the top](#api-endpoints-list)

