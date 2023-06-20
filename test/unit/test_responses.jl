const DATA_FILENAME = "data.csv"

@testset "Test responses" begin
    @testset "server_info_response" begin
        using JSON
        version = v"1.3.0" # TODO: Update this version when the package is updated.
        pkg_version = ModelSelectionGUI.get_pkg_version("ModelSelection")
        
        ncores = 2
        nworkers = 1
        model_selection_version = "1.3.0"
        julia_version = "1.6.1"
        jobs_queue_size = 2
        content_type = "application/json"
        charset = "utf-8"

        response = ModelSelectionGUI.server_info_response(
            ncores,
            nworkers,
            model_selection_version, 
            julia_version,
            jobs_queue_size,
        )
        
        headers = split(Dict(response.headers)["Content-Type"])
        headers[1] = replace(headers[1], ";"=>"")
        headers[2] = replace(headers[2], "charset="=>"")
        msg = String(response.body)
        body = JSON.parse(msg)
        
        
        @test response.status == 200
        @test headers[1] == content_type
        @test headers[2] == charset
        JULIA_VERSION = String(ModelSelectionGUI.JULIA_VERSION)
        MODEL_SELECTION_VERSION = String(ModelSelectionGUI.MODEL_SELECTION_VERSION)
        NCORES = String(ModelSelectionGUI.NCORES)
        NWORKERS = String(ModelSelectionGUI.NWORKERS)
        JOBS_QUEUE_SIZE = String(ModelSelectionGUI.JOBS_QUEUE_SIZE)

        @test response.status == 200
        @test haskey(body, JULIA_VERSION)
        @test body[JULIA_VERSION] isa String
        @test body[JULIA_VERSION] == julia_version
        @test haskey(body, MODEL_SELECTION_VERSION)
        @test body[MODEL_SELECTION_VERSION] isa String
        @test body[MODEL_SELECTION_VERSION] == model_selection_version
        @test haskey(body, NCORES)
        @test body[NCORES] isa Int64
        @test body[NCORES] == ncores
        @test haskey(body, NWORKERS)
        @test body[NWORKERS] isa Int64
        @test body[NWORKERS] == nworkers
        @test haskey(body, JOBS_QUEUE_SIZE)
        @test body[JOBS_QUEUE_SIZE] isa Int64
        @test body[JOBS_QUEUE_SIZE] == jobs_queue_size
    end

    @testset "upload_response" begin
        using JSON
        filename = "data.csv"
        filehash = "1234567890"
        datanames = ["a", "b", "c"]
        nobs = 2
        content_type = "application/json"
        charset = "utf-8"
        response = ModelSelectionGUI.upload_response(
            filename,
            filehash,
            datanames,
            nobs,
        )

        headers = split(Dict(response.headers)["Content-Type"])
        headers[1] = replace(headers[1], ";"=>"")
        headers[2] = replace(headers[2], "charset="=>"")
        msg = String(response.body)
        body = JSON.parse(msg)
                
        @test response.status == 200
        @test headers[1] == content_type
        @test headers[2] == charset

        FILENAME = String(ModelSelectionGUI.FILENAME)
        FILEHASH = String(ModelSelectionGUI.FILEHASH)
        DATANAMES = String(ModelSelectionGUI.DATANAMES)
        NOBS = String(ModelSelectionGUI.NOBS)

        @test haskey(body, FILENAME)
        @test body[FILENAME] isa String
        @test body[FILENAME] == filename
        @test haskey(body, FILEHASH)
        @test body[FILEHASH] isa String
        @test body[FILEHASH] == filehash
        @test haskey(body, DATANAMES)
        @test body[DATANAMES] isa Vector
        for i in 1:lastindex(datanames)
            @test body[DATANAMES][i] == datanames[i]
        end
        @test haskey(body, NOBS)
        @test body[NOBS] isa Int64
        @test body[NOBS] == nobs
    end
    @testset "job_info_response" begin
        using Dates, JSON
        content_type = "application/json"
        charset = "utf-8"
        id = "83ecac9e-678d-4c80-9314-0ae4a67d5ace"
        filehash = "adbc7420-1597-4b1b-a798-fafd9ee5f671"
        url = "$(ModelSelectionGUI.SERVER_URL):$(ModelSelectionGUI.SERVER_PORT)/job/$(id)"
        filename = DATA_FILENAME
        tempfile = DATA_FILENAME
        estimator = :ols
        equation = "y x1 x2 x3"
        ttest = true        
        payload = Dict(
            ModelSelectionGUI.ESTIMATOR => estimator,
            ModelSelectionGUI.EQUATION => equation,
            :ttest => ttest,
        )
        time_equeued = "2023-01-01T01:01:01"
        time_started = "2023-02-02T02:02:02"
        time_finished = "2023-03-03T03:03:03"
        status = ModelSelectionGUI.RUNNING
        msg = "msg"
        job = ModelSelectionJob(filename, tempfile, filehash, payload)

        job.id = id
        job.status = status
        job.time_enqueued = DateTime(time_equeued)
        job.time_started = DateTime(time_started)
        job.time_finished = DateTime(time_finished)
        job.msg = "msg"
        
        data = CSV.read(job.tempfile, DataFrame)
        job.modelselection_data = gsr(
            job.estimator,
            job.equation,
            data;
            job.parameters...,
        )

        response = ModelSelectionGUI.job_info_response(job)
        headers = split(Dict(response.headers)["Content-Type"])
        headers[1] = replace(headers[1], ";"=>"")
        headers[2] = replace(headers[2], "charset="=>"")
        body = String(response.body)
        body = JSON.parse(body)

        ID = String(ModelSelectionGUI.ID)
        FILENAME = String(ModelSelectionGUI.FILENAME)
        FILEHASH = String(ModelSelectionGUI.FILEHASH)
        PARAMETERS = String(ModelSelectionGUI.PARAMETERS)
        STATUS = String(ModelSelectionGUI.STATUS)
        TIME_ENQUEUED = String(ModelSelectionGUI.TIME_ENQUEUED)
        TIME_STARTED = String(ModelSelectionGUI.TIME_STARTED)
        TIME_FINISHED = String(ModelSelectionGUI.TIME_FINISHED)
        ESTIMATOR = String(ModelSelectionGUI.ESTIMATOR)
        EQUATION = String(ModelSelectionGUI.EQUATION)
        MSG = String(ModelSelectionGUI.MSG)
        TTEST = "ttest"

        @test response.status == 200
        @test headers[1] == content_type
        @test headers[2] == charset
        @test haskey(body, ID)
        @test body[ID] isa String
        @test haskey(body, FILENAME)
        @test body[FILENAME] isa String
        @test body[FILENAME] == filename

        @test haskey(body, FILEHASH)
        @test body[FILEHASH] isa String
        @test body[FILEHASH] == filehash

        @test haskey(body, PARAMETERS)
        @test body[PARAMETERS] isa Dict
        @test haskey(body[PARAMETERS], TTEST)
        @test body[PARAMETERS][TTEST] isa Bool
        @test body[PARAMETERS][TTEST] == ttest

        @test haskey(body, STATUS)
        @test body[STATUS] isa String
        @test body[STATUS] == String(status)
        @test haskey(body, TIME_ENQUEUED)
        @test body[TIME_ENQUEUED] isa String
        @test Dates.format(DateTime(body[TIME_ENQUEUED]), "yyyy-mm-ddTHH:MM:SS") == time_equeued
        
        @test haskey(body, TIME_STARTED)
        @test body[TIME_STARTED] isa String
        @test Dates.format(DateTime(body[TIME_STARTED]), "yyyy-mm-ddTHH:MM:SS") == time_started
        @test haskey(body, TIME_FINISHED)
        @test body[TIME_FINISHED] isa String
        @test Dates.format(DateTime(body[TIME_FINISHED]), "yyyy-mm-ddTHH:MM:SS") == time_finished

        @test haskey(body, ESTIMATOR)
        @test body[ESTIMATOR] isa String
        @test body[ESTIMATOR] == String(estimator)

        @test haskey(body, EQUATION)
        @test body[EQUATION] isa String
        @test body[EQUATION] == equation

        @test haskey(body, MSG)
        @test body[MSG] isa String
        @test body[MSG] == msg
    end
    @testset "job_results_response" begin
        using JSON, Dates, ModelSelection, CSV, DataFrames
        id = "83ecac9e-678d-4c80-9314-0ae4a67d5ace"
        filehash = "adbc7420-1597-4b1b-a798-fafd9ee5f671"
        url = "$(ModelSelectionGUI.SERVER_URL):$(ModelSelectionGUI.SERVER_PORT)/job/$(id)/results/summary"
        filename = DATA_FILENAME
        tempfile = DATA_FILENAME
        estimator = :ols
        equation = "y x1 x2 x3"
        ttest = true        
        payload = Dict(
            ModelSelectionGUI.ESTIMATOR => estimator,
            ModelSelectionGUI.EQUATION => equation,
            :ttest => ttest,
            :kfoldcrossvalidation => true,
        )
        time = "2023-01-01T01:01:01"
        job = ModelSelectionJob(filename, tempfile, filehash, payload)
        job.id = id
        job.status = ModelSelectionGUI.FINISHED
        job.time_enqueued = DateTime(time)
        job.time_started = DateTime(time)
        job.time_finished = DateTime(time)
        job.modelselection_data = nothing
        
        data = CSV.read(job.tempfile, DataFrame)
        job.modelselection_data = gsr(
            job.estimator,
            job.equation,
            data;
            job.parameters...,
        )

        response = ModelSelectionGUI.job_results_response(job, :summary)
        @test response.status == 200
        @test Dict(response.headers)["Content-Type"] == ModelSelectionGUI.PLAIN_MIME

        response = ModelSelectionGUI.job_results_response(job, :allsubsetregression)
        @test response.status == 200
        @test Dict(response.headers)["Content-Type"] == ModelSelectionGUI.CSV_MIME

        response = ModelSelectionGUI.job_results_response(job, :crossvalidation)
        @test response.status == 200
        @test Dict(response.headers)["Content-Type"] == ModelSelectionGUI.CSV_MIME

        response = ModelSelectionGUI.job_results_response(job, :invalid)
        @test response.status == 400
    end
end
