const DOTENV = "integration/.testenv"
const DATA_FILENAME = "data.csv"

@testset "Jobs" begin
    @testset "POST /job-enqueue/:filehash" begin
        using HTTP, JSON
        filehash = "adbc7420-1597-4b1b-a798-fafd9ee5f671"
        url = "$(ModelSelectionGUI.SERVER_URL):$(ModelSelectionGUI.SERVER_PORT)/job-enqueue/$(filehash)"
        filename = DATA_FILENAME
        tempfile = DATA_FILENAME
        ttest = true
        equation = "y x1 x2 x3"
        estimator = :ols
        ModelSelectionGUI.add_file(filehash, tempfile, filename)
        body = Dict(:estimator => estimator, :equation => equation, :ttest => ttest)
        reset_envvars()
        start(dotenv = DOTENV)
        response = HTTP.post(url, ["Content-Type" => "application/json"], JSON.json(body))
        msg = String(response.body)
        body = JSON.parse(msg)

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
        @test haskey(body, ID)
        @test body[ID] isa String

        @test response.status == 200
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
        @test haskey(body, TIME_ENQUEUED)
        @test body[TIME_ENQUEUED] isa String
        @test haskey(body, TIME_STARTED)
        @test haskey(body, TIME_FINISHED)

        @test haskey(body, ESTIMATOR)
        @test body[ESTIMATOR] isa String
        @test body[ESTIMATOR] == String(estimator)

        @test haskey(body, EQUATION)
        @test body[EQUATION] isa String
        @test body[EQUATION] == equation

        @test haskey(body, MSG)
        stop()
    end

    @testset "GET /job/:id" begin
        using HTTP, JSON, Dates
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
        job.modelselection_data = nothing
        job.msg = "msg"

        push!(ModelSelectionGUI.jobs_finished, job)

        reset_envvars()
        start(dotenv = DOTENV)
        response = HTTP.get(url)
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
        @test Dates.format(DateTime(body[TIME_ENQUEUED]), "yyyy-mm-ddTHH:MM:SS") ==
              time_equeued

        @test haskey(body, TIME_STARTED)
        @test body[TIME_STARTED] isa String
        @test Dates.format(DateTime(body[TIME_STARTED]), "yyyy-mm-ddTHH:MM:SS") ==
              time_started
        @test haskey(body, TIME_FINISHED)
        @test body[TIME_FINISHED] isa String
        @test Dates.format(DateTime(body[TIME_FINISHED]), "yyyy-mm-ddTHH:MM:SS") ==
              time_finished

        @test haskey(body, ESTIMATOR)
        @test body[ESTIMATOR] isa String
        @test body[ESTIMATOR] == String(estimator)

        @test haskey(body, EQUATION)
        @test body[EQUATION] isa String
        @test body[EQUATION] == equation

        @test haskey(body, MSG)
        @test body[MSG] isa String
        @test body[MSG] == msg

        ModelSelectionGUI.clear_pending_queue()
        ModelSelectionGUI.clear_current_job()
        ModelSelectionGUI.clear_finished_queue()
        stop()
    end
    @testset "GET /job/:id/results/summary" begin
        using HTTP, JSON, Dates, ModelSelection, CSV, DataFrames
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
        job.modelselection_data = gsr(job.estimator, job.equation, data; job.parameters...)

        push!(ModelSelectionGUI.jobs_finished, job)

        start(dotenv = DOTENV)
        response = HTTP.get(url)

        @test response.status == 200
        @test Dict(response.headers)["Content-Type"] == ModelSelectionGUI.PLAIN_MIME

        ModelSelectionGUI.clear_pending_queue()
        ModelSelectionGUI.clear_current_job()
        ModelSelectionGUI.clear_finished_queue()
        stop()
    end
    @testset "GET /job/:id/results/allsubsetregression" begin
        using HTTP, JSON, Dates, ModelSelection, CSV, DataFrames
        id = "83ecac9e-678d-4c80-9314-0ae4a67d5ace"
        filehash = "adbc7420-1597-4b1b-a798-fafd9ee5f671"
        url = "$(ModelSelectionGUI.SERVER_URL):$(ModelSelectionGUI.SERVER_PORT)/job/$(id)/results/allsubsetregression"
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
        time = "2023-01-01T01:01:01"
        job = ModelSelectionJob(filename, tempfile, filehash, payload)
        job.id = id
        job.status = ModelSelectionGUI.FINISHED
        job.time_enqueued = DateTime(time)
        job.time_started = DateTime(time)
        job.time_finished = DateTime(time)
        job.modelselection_data = nothing

        data = CSV.read(job.tempfile, DataFrame)
        job.modelselection_data = gsr(job.estimator, job.equation, data; job.parameters...)

        push!(ModelSelectionGUI.jobs_finished, job)

        start(dotenv = DOTENV)
        response = HTTP.get(url)

        @test response.status == 200
        @test Dict(response.headers)["Content-Type"] == ModelSelectionGUI.CSV_MIME

        ModelSelectionGUI.clear_pending_queue()
        ModelSelectionGUI.clear_current_job()
        ModelSelectionGUI.clear_finished_queue()
        stop()
    end
    @testset "GET /job/:id/results/crossvalidation" begin
        using HTTP, JSON, Dates, ModelSelection, CSV, DataFrames
        id = "83ecac9e-678d-4c80-9314-0ae4a67d5ace"
        filehash = "adbc7420-1597-4b1b-a798-fafd9ee5f671"
        url = "$(ModelSelectionGUI.SERVER_URL):$(ModelSelectionGUI.SERVER_PORT)/job/$(id)/results/crossvalidation"
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
        job.modelselection_data = gsr(job.estimator, job.equation, data; job.parameters...)

        push!(ModelSelectionGUI.jobs_finished, job)

        start(dotenv = DOTENV)
        response = HTTP.get(url)

        @test response.status == 200
        @test Dict(response.headers)["Content-Type"] == ModelSelectionGUI.CSV_MIME

        ModelSelectionGUI.clear_pending_queue()
        ModelSelectionGUI.clear_current_job()
        ModelSelectionGUI.clear_finished_queue()
        stop()
    end
end
