# Rest API Endpoints

The Rest API endpoints are the core communication to interact with the backend services. 

```@contents
Pages = ["index.md"]
```

## Server info
Retrieves information about the server.

### Request

- URL: `/server-info`
- Method: `GET`

### Response

- Status Code: `200 (OK)`
- Content-Type: `application/json` 
- Body:
    - `julia_version`: The version of Julia running on the server.
    - `model_selection_version`: The version of the ModelSelection package being used.
    - `ncores`: The number of CPU cores available on the server.
    - `nworkers`: The number of workers available for parallel processing.
    - `jobs_queue_size`: The number of jobs currently in the queue.

### Example

cURL request:
```bash
curl "http://127.0.0.1:8000/server-info"
```

JSON response:
```json
{
    "julia_version": "1.6.7",
    "model_selection_version": "1.2.0",
    "ncores": 8,
    "nworkers": 4,
    "jobs_queue_size": 0
}
```

## File upload
Uploads a CSV file to the server. Upon successful upload, the server will process the uploaded file for further operations.

### Request

- URL: `/upload-file`
- Method: `POST`
- Content-Type: `form-data`
- Body: 
    - `data`: The CSV file to upload.

### Response

- Status Code: `200 (OK)`
- Content-Type: `application/json`
- Body:
    - `filename`: The name of the uploaded file.
    - `filehash`: The unique identifier (UUID) for the uploaded file.
    - `datanames`: The names of the columns in the CSV file.
    - `nobs`: The number of observations (rows) in the CSV file.

### Example

cURL request:
```bash
curl "http://127.0.0.1:8000/upload-file" --form "data=@data.csv;type=text/csv"
```

JSON response:
```json
{
    "filename": "data.csv",
    "filehash": "6c48451b-af17-43cb-a251-e847abc94472",
    "datanames": ["y", "x1", "x2", "x3", "x4", "x5"],
    "nobs": 100
}
```

## Enqueue a job
Enqueues a model selection job for the specified file. The task will be executed after the previously queued tasks have finished.

### Request

- URL: `/job-enqueue/:filehash`
- Method: `POST`
- Query parameter:
    - `filehash`: The unique identifier (UUID) of the uploaded file to perform model selection on.
- Content-Type: `application/json`
- Body:
  - `estimator`: The estimator to use for model selection (e.g., `"ols"`).
  - `equation`: The equation or formula specifying the dependent and independent variables.
  - `ttest`: Flag indicating whether to perform t-tests. Default is true.

!!! note
    Please refer to the **ModelSelection.jl** package documentation for additional parameters that can be included in the request.

### Response

- Status Code: `200 (OK)`
- Content-Type: `application/json`
- Body:
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

### Example

cURL request:
```bash
curl "http://127.0.0.1:8000/job-enqueue/64486929-0f7b-459a-a1d2-292258eb6580" \
--header "Content-Type: application/json" \
--data "{
    \"estimator\": \"ols\",
    \"equation\": \"y x1 x2 x3\",
    \"fixedvariables\": [\"x4\"],
    \"modelavg\": true,
    \"ttest\": true,
    \"kfoldcrossvalidation\": true,
    \"numfolds\": 5
}"
```

JSON response:
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
        "ttest": true
    }
}
```

!!! note
    The response contains detailed information about the initiated model selection process, including the current status and the parameters used.

## Get job info

Retrieves the info of a model selection job. If the job is finished, it also includes the summary of a model selection job.

### Request
- URL: `job/:id`
- Method: `GET`
- Query parameter:
    - `id`: The unique identifier (UUID) of the model selection job.

### Response

- Status Code: `200 (OK)`
- Content-Type: `application/json`
- Body:
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

### Example

cURL request:
```bash
curl "http://127.0.0.1:8000/job/99e36de3-4c47-4285-873d-7f92ed0c42ea"
```

JSON response:
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

!!! note
    The response contains detailed information about the initiated model selection job, including the current status and the parameters used.

!!! note
    If the job is finished, it also includes the summary of a model selection job.

## Get job results
Retrieves the result file of a specific type for a model selection job.

### Request

- URL: `/job/:id/results/:type`
- Method: `GET`
- Query parameters:
  - `id`: The unique identifier (UUID) of the model selection job.
  - `type`: The type of result file to retrieve. Possible values: `summary`, `allsubsetregression`, `crossvalidation`.

### Response

- Status Code: `200 (OK)`
- Content-Type:
    - summary: `text/plain`
    - allsubsetregression: `text/csv`
    - crossvalidation: `text/csv`
- Body: The response returns the result file in the corresponding format based on the `type` specified.

!!! note
    The response should include appropriate headers to indicate the file type and provide options for file download or display.
    
!!! note
    The filename is a concatenation of the original data filename and the type.
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
