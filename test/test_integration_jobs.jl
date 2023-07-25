@safetestset "Test jobs" begin
    @safetestset "POST /job-enqueue/:filehash" begin
        using HTTP, JSON
        using ModelSelectionGUI

        DATA_FILENAME = joinpath(dirname(@__FILE__), "data.csv")
        filehash = "adbc7420-1597-4b1b-a798-fafd9ee5f671"
        url = "http://$(ModelSelectionGUI.SERVER_HOST):$(ModelSelectionGUI.SERVER_PORT)/job-enqueue/$(filehash)"

        reset_envvars()
        start(no_task = true)

        filename = DATA_FILENAME
        tempfile = DATA_FILENAME
        ttest = true
        equation = "y x1 x2 x3"
        estimator = :ols
        ModelSelectionGUI.add_job_file(filehash, tempfile, filename)
        body = Dict(:estimator => estimator, :equation => equation, :ttest => ttest)
        response = HTTP.post(
            url,
            ["Content-Type" => "application/json"],
            JSON.json(body);
            connect_timeout = 60,
        )
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
        @test body[ID] isa String
        @test haskey(body, FILENAME)
        @test body[FILENAME] == filename
        @test haskey(body, FILEHASH)
        @test body[FILEHASH] == filehash
        @test haskey(body, PARAMETERS)
        @test body[PARAMETERS] isa Dict
        @test haskey(body[PARAMETERS], TTEST)
        @test body[PARAMETERS][TTEST] == ttest
        @test body[STATUS] isa String
        @test body[TIME_ENQUEUED] isa String
        @test haskey(body, TIME_STARTED)
        @test haskey(body, TIME_FINISHED)
        @test body[ESTIMATOR] == String(estimator)
        @test body[EQUATION] == equation
        @test haskey(body, MSG)

        filehash = "adbc7420-1597-4b1b-a798-fafd9ee5f672"
        url = "http://$(ModelSelectionGUI.SERVER_HOST):$(ModelSelectionGUI.SERVER_PORT)/job-enqueue/$(filehash)"
        body = Dict(:estimator => estimator, :equation => equation, :ttest => ttest)
        @test_throws HTTP.Exceptions.StatusError HTTP.post(
            url,
            ["Content-Type" => "application/json"],
            JSON.json(body);
            connect_timeout = 60,
        )

        filehash = "adbc7420-1597-4b1b-a798-fafd9ee5f672"
        ModelSelectionGUI.add_job_file(filehash, "invalid.csv", "data.csv")
        url = "http://$(ModelSelectionGUI.SERVER_HOST):$(ModelSelectionGUI.SERVER_PORT)/job-enqueue/$(filehash)"
        body = Dict(:estimator => estimator, :equation => equation, :ttest => ttest)
        @test_throws HTTP.Exceptions.StatusError HTTP.post(
            url,
            ["Content-Type" => "application/json"],
            JSON.json(body);
            connect_timeout = 60,
        )

        filehash = "adbc7420-1597-4b1b-a798-fafd9ee5f671"
        url = "http://$(ModelSelectionGUI.SERVER_HOST):$(ModelSelectionGUI.SERVER_PORT)/job-enqueue/$(filehash)"
        body = Dict(:equation => equation, :ttest => ttest)
        @test_throws HTTP.Exceptions.StatusError HTTP.post(
            url,
            ["Content-Type" => "application/json"],
            JSON.json(body);
            connect_timeout = 60,
        )

        filehash = "adbc7420-1597-4b1b-a798-fafd9ee5f671"
        url = "http://$(ModelSelectionGUI.SERVER_HOST):$(ModelSelectionGUI.SERVER_PORT)/job-enqueue/$(filehash)"
        body = Dict(:estimator => estimator, :ttest => ttest)
        @test_throws HTTP.Exceptions.StatusError HTTP.post(
            url,
            ["Content-Type" => "application/json"],
            JSON.json(body);
            connect_timeout = 60,
        )

        stop()
    end

    @safetestset "GET /jobs/:id" begin
        using Dates, HTTP, JSON
        using ModelSelectionGUI
        using ModelSelectionGUI: ModelSelectionJob

        reset_envvars()
        start(no_task = true)

        DATA_FILENAME = joinpath(dirname(@__FILE__), "data.csv")
        id = "83ecac9e-678d-4c80-9314-0ae4a67d5ace"
        url = "http://$(ModelSelectionGUI.SERVER_HOST):$(ModelSelectionGUI.SERVER_PORT)/jobs/$(id)"

        filehash = "adbc7420-1597-4b1b-a798-fafd9ee5f671"
        filename = DATA_FILENAME
        tempfile = DATA_FILENAME
        estimator = :ols
        equation = "y x1 x2 x3"
        ttest = true
        parameters = Dict(:ttest => ttest)
        time_equeued = "2023-01-01T01:01:01"
        time_started = "2023-02-02T02:02:02"
        time_finished = "2023-03-03T03:03:03"
        status = ModelSelectionGUI.RUNNING
        msg = "msg"
        job =
            ModelSelectionJob(filename, tempfile, filehash, estimator, equation, parameters)

        job.id = id
        job.status = status
        job.time_enqueued = DateTime(time_equeued)
        job.time_started = DateTime(time_started)
        job.time_finished = DateTime(time_finished)
        job.modelselection_data = nothing
        job.msg = "msg"

        push!(ModelSelectionGUI.finished_queue, job)

        response = HTTP.get(url; connect_timeout = 60)
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
        @test body[ID] isa String
        @test body[FILENAME] == filename
        @test body[FILEHASH] == filehash
        @test body[PARAMETERS] isa Dict
        @test haskey(body[PARAMETERS], TTEST)
        @test body[PARAMETERS][TTEST] == ttest
        @test body[STATUS] == String(status)
        @test body[TIME_ENQUEUED] isa String
        @test Dates.format(DateTime(body[TIME_ENQUEUED]), "yyyy-mm-ddTHH:MM:SS") ==
              time_equeued
        @test Dates.format(DateTime(body[TIME_STARTED]), "yyyy-mm-ddTHH:MM:SS") ==
              time_started
        @test Dates.format(DateTime(body[TIME_FINISHED]), "yyyy-mm-ddTHH:MM:SS") ==
              time_finished
        @test body[ESTIMATOR] == String(estimator)
        @test body[EQUATION] == equation
        @test body[MSG] == msg

        id = "83ecac9e-678d-4c80-9314-0ae4a67d5acd"
        url = "http://$(ModelSelectionGUI.SERVER_HOST):$(ModelSelectionGUI.SERVER_PORT)/jobs/$(id)"
        @test_throws HTTP.Exceptions.StatusError HTTP.get(url; connect_timeout = 60)

        ModelSelectionGUI.clear_pending_queue()
        ModelSelectionGUI.clear_current_job()
        ModelSelectionGUI.clear_finished_queue()
        stop()
    end
    @safetestset "GET /jobs/:id/results/summary" begin
        using CSV, DataFrames, Dates, HTTP, JSON
        using ModelSelectionGUI, ModelSelection
        using ModelSelectionGUI: ModelSelectionJob

        reset_envvars()
        start(no_task = true)

        DATA_FILENAME = joinpath(dirname(@__FILE__), "data.csv")
        id = "83ecac9e-678d-4c80-9314-0ae4a67d5ace"
        url = "http://$(ModelSelectionGUI.SERVER_HOST):$(ModelSelectionGUI.SERVER_PORT)/jobs/$(id)/results/summary"

        filehash = "adbc7420-1597-4b1b-a798-fafd9ee5f671"
        filename = DATA_FILENAME
        tempfile = DATA_FILENAME
        estimator = :ols
        equation = "y x1 x2 x3"
        ttest = true
        parameters = Dict(:ttest => ttest)
        time = "2023-01-01T01:01:01"
        job =
            ModelSelectionJob(filename, tempfile, filehash, estimator, equation, parameters)
        job.id = id
        job.status = ModelSelectionGUI.FINISHED
        job.time_enqueued = DateTime(time)
        job.time_started = DateTime(time)
        job.time_finished = DateTime(time)
        job.modelselection_data = nothing

        data = CSV.read(job.tempfile, DataFrame)
        job.modelselection_data = gsr(job.estimator, job.equation, data; job.parameters...)

        push!(ModelSelectionGUI.finished_queue, job)

        response = HTTP.get(url; connect_timeout = 60)

        @test response.status == 200
        @test Dict(response.headers)["Content-Type"] == ModelSelectionGUI.PLAIN_MIME

        url = "http://$(ModelSelectionGUI.SERVER_HOST):$(ModelSelectionGUI.SERVER_PORT)/jobs/$(id)/results/nothing"
        @test_throws HTTP.Exceptions.StatusError HTTP.get(url; connect_timeout = 60)

        id = "83ecac9e-678d-4c80-9314-0ae4a67d5acd"
        url = "http://$(ModelSelectionGUI.SERVER_HOST):$(ModelSelectionGUI.SERVER_PORT)/jobs/$(id)/results/summary"
        @test_throws HTTP.Exceptions.StatusError HTTP.get(url; connect_timeout = 60)

        ModelSelectionGUI.clear_pending_queue()
        ModelSelectionGUI.clear_current_job()
        ModelSelectionGUI.clear_finished_queue()
        stop()
    end
    @safetestset "GET /jobs/:id/results/allsubsetregression" begin
        using CSV, DataFrames, Dates, HTTP, JSON
        using ModelSelectionGUI, ModelSelection
        using ModelSelectionGUI: ModelSelectionJob

        reset_envvars()
        start(no_task = true)

        DATA_FILENAME = joinpath(dirname(@__FILE__), "data.csv")
        id = "83ecac9e-678d-4c80-9314-0ae4a67d5ace"
        url = "http://$(ModelSelectionGUI.SERVER_HOST):$(ModelSelectionGUI.SERVER_PORT)/jobs/$(id)/results/allsubsetregression"

        filehash = "adbc7420-1597-4b1b-a798-fafd9ee5f671"
        filename = DATA_FILENAME
        tempfile = DATA_FILENAME
        estimator = :ols
        equation = "y x1 x2 x3"
        ttest = true
        parameters = Dict(:ttest => ttest)
        time = "2023-01-01T01:01:01"
        job =
            ModelSelectionJob(filename, tempfile, filehash, estimator, equation, parameters)
        job.id = id
        job.status = ModelSelectionGUI.FINISHED
        job.time_enqueued = DateTime(time)
        job.time_started = DateTime(time)
        job.time_finished = DateTime(time)
        job.modelselection_data = nothing

        data = CSV.read(job.tempfile, DataFrame)
        job.modelselection_data = gsr(job.estimator, job.equation, data; job.parameters...)

        push!(ModelSelectionGUI.finished_queue, job)

        response = HTTP.get(url; connect_timeout = 60)

        @test response.status == 200
        @test Dict(response.headers)["Content-Type"] == ModelSelectionGUI.CSV_MIME

        url = "http://$(ModelSelectionGUI.SERVER_HOST):$(ModelSelectionGUI.SERVER_PORT)/jobs/$(id)/results/nothing"
        @test_throws HTTP.Exceptions.StatusError HTTP.get(url; connect_timeout = 60)

        id = "83ecac9e-678d-4c80-9314-0ae4a67d5acd"
        url = "http://$(ModelSelectionGUI.SERVER_HOST):$(ModelSelectionGUI.SERVER_PORT)/jobs/$(id)/results/allsubsetregression"
        @test_throws HTTP.Exceptions.StatusError HTTP.get(url; connect_timeout = 60)

        ModelSelectionGUI.clear_pending_queue()
        ModelSelectionGUI.clear_current_job()
        ModelSelectionGUI.clear_finished_queue()
        stop()
    end
    @safetestset "GET /jobs/:id/results/crossvalidation" begin
        using DataFrames, Dates, CSV, HTTP, JSON
        using ModelSelectionGUI, ModelSelection
        using ModelSelectionGUI: ModelSelectionJob

        reset_envvars()
        start(no_task = true)

        DATA_FILENAME = joinpath(dirname(@__FILE__), "data.csv")
        id = "83ecac9e-678d-4c80-9314-0ae4a67d5ace"
        url = "http://$(ModelSelectionGUI.SERVER_HOST):$(ModelSelectionGUI.SERVER_PORT)/jobs/$(id)/results/crossvalidation"

        filehash = "adbc7420-1597-4b1b-a798-fafd9ee5f671"
        filename = DATA_FILENAME
        tempfile = DATA_FILENAME
        estimator = :ols
        equation = "y x1 x2 x3"
        ttest = true
        parameters = Dict(:ttest => ttest, :kfoldcrossvalidation => true)
        time = "2023-01-01T01:01:01"
        job =
            ModelSelectionJob(filename, tempfile, filehash, estimator, equation, parameters)
        job.id = id
        job.status = ModelSelectionGUI.FINISHED
        job.time_enqueued = DateTime(time)
        job.time_started = DateTime(time)
        job.time_finished = DateTime(time)
        job.modelselection_data = nothing

        data = CSV.read(job.tempfile, DataFrame)
        job.modelselection_data = gsr(job.estimator, job.equation, data; job.parameters...)

        push!(ModelSelectionGUI.finished_queue, job)

        response = HTTP.get(url; connect_timeout = 60)

        @test response.status == 200
        @test Dict(response.headers)["Content-Type"] == ModelSelectionGUI.CSV_MIME

        url = "http://$(ModelSelectionGUI.SERVER_HOST):$(ModelSelectionGUI.SERVER_PORT)/jobs/$(id)/results/nothing"
        @test_throws HTTP.Exceptions.StatusError HTTP.get(url; connect_timeout = 60)

        id = "83ecac9e-678d-4c80-9314-0ae4a67d5acd"
        url = "http://$(ModelSelectionGUI.SERVER_HOST):$(ModelSelectionGUI.SERVER_PORT)/jobs/$(id)/results/crossvalidation"
        @test_throws HTTP.Exceptions.StatusError HTTP.get(url; connect_timeout = 60)

        ModelSelectionGUI.clear_pending_queue()
        ModelSelectionGUI.clear_current_job()
        ModelSelectionGUI.clear_finished_queue()
        stop()
    end
end
