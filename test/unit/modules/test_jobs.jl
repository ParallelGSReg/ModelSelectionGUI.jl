@testset "Jobs Module" begin
    using ModelSelectionGUI.Jobs
    using ModelSelectionGUI.Jobs: to_dict
    using ModelSelection: ModelSelectionData
    using CSV, DataFrames, Dates
    function notify(message::String, data::Union{Dict{Any,Any},Nothing} = nothing) end

    data = CSV.read(DATA_FILENAME, DataFrame)
    datanames = names(data)
    nobs = size(data, 1)

    @testset "File" begin
        file = File(DATA_FILENAME, DATA_FILENAME, data)
        @test file.id isa String
        @test file.filename isa String
        @test file.filename == DATA_FILENAME
        @test file.tempfile isa String
        @test file.tempfile == DATA_FILENAME
        @test file.datanames isa Vector{String}
        @test file.datanames == datanames
        @test file.nobs isa Int64
        @test file.nobs == nobs

        dict = to_dict(file)
        @test dict isa Dict{Symbol,Any}
        @test haskey(dict, Jobs.ID)
        @test dict[Jobs.ID] == file.id
        @test haskey(dict, Jobs.FILENAME)
        @test dict[Jobs.FILENAME] == file.filename
        @test haskey(dict, Jobs.DATANAMES)
        @test dict[Jobs.DATANAMES] isa Vector{String}
        for (i, name) in enumerate(dict[Jobs.DATANAMES])
            @test name == file.datanames[i]
        end
        @test haskey(dict, Jobs.NOBS)
        @test dict[Jobs.NOBS] isa Int64
        @test dict[Jobs.NOBS] == file.nobs
    end
    @testset "JobManager" begin
        manager = JobManager(notify)
        @test manager.pending_queue isa Vector{ModelSelectionJob}
        @test manager.finished_queue isa Vector{ModelSelectionJob}
        @test manager.files isa Dict{String,File}
        @test manager.condition isa Condition
        @test manager.current === nothing
        @test manager.task === nothing
        @test manager.job_notify !== nothing

        manager = JobManager(notify)
        file1 = File(DATA_FILENAME, DATA_FILENAME, data)
        add_file(manager, file1)
        @test haskey(manager.files, file1.id)
        @test manager.files[file1.id] == file1
        @test length(collect(keys(manager.files))) == 1
        file2 = File(DATA_FILENAME, DATA_FILENAME, data)
        add_file(manager, file2)
        @test haskey(manager.files, file2.id)
        @test manager.files[file2.id] == file2
        @test length(collect(keys(manager.files))) == 2
        file = get_file(manager, file1.id)
        @test file isa File
        @test file == file1
        file = get_file(manager, file2.id)
        @test file isa File
        @test file == file2
        file = get_file(manager, "nonexistent")
        @test file === nothing
        @test manager.task === nothing
        start_task(manager)
        @test manager.task !== nothing
        start_task(manager)
        @test manager.task !== nothing
        stop_task(manager)
        @test manager.task === nothing
        stop_task(manager)
        @test manager.task === nothing

        file = File(DATA_FILENAME, DATA_FILENAME, data)
        manager = JobManager(notify)
        start_task(manager)
        add_file(manager, file)
        job = ModelSelectionJob(file, :ols, "y x1 x2 x3", Dict{Symbol,Any}())
        add_pending_job(manager, job)
        @test length(manager.pending_queue) == 1
        Jobs.consume_pending_job(manager)
        @test length(manager.pending_queue) == 0
        @test length(manager.finished_queue) == 1
        @test manager.current === nothing
        @test manager.finished_queue[1].status == FINISHED
        @test manager.finished_queue[1].modelselection_data isa ModelSelectionData
        job =
            ModelSelectionJob(file, :ols, "y x1 x2 x3", Dict{Symbol,Any}(:invalid => true))
        add_pending_job(manager, job)
        @test length(manager.pending_queue) == 1
        Jobs.consume_pending_job(manager)
        @test length(manager.pending_queue) == 0
        @test length(manager.finished_queue) == 2
        @test manager.current === nothing
        @test manager.finished_queue[2].status == FAILED
    end
    @testset "ModelSelectionJob" begin
        using Dates
        file = File("data.csv", "/temp/data.csv", data)
        estimator = :ols
        equation = "y x1 x2 x3"
        ttest = true
        parameters = Dict{Symbol,Any}(:ttest => ttest)
        job = ModelSelectionJob(file, estimator, equation, parameters)

        @test job.id isa String
        @test job.file isa File
        @test job.file == file
        @test job.estimator isa Symbol
        @test job.estimator == estimator
        @test job.equation isa String
        @test job.equation == equation
        @test job.parameters isa Dict{Symbol,Any}
        @test haskey(job.parameters, :ttest)
        @test job.parameters[:ttest] == ttest
        @test job.status isa Symbol
        @test job.status == PENDING
        @test job.time_enqueued isa DateTime
        @test job.time_started isa Nothing
        @test job.time_finished isa Nothing
        @test job.modelselection_data isa Nothing
        @test job.msg isa Nothing

        dict = to_dict(job)
        @test dict isa Dict{Symbol,Any}
        @test haskey(dict, Jobs.ID)
        @test dict[Jobs.ID] == job.id
        @test haskey(dict, Jobs.FILE)
        @test dict[Jobs.FILE] isa Dict{Symbol,Any}
        @test dict[Jobs.FILE][Jobs.ID] == job.file.id
        @test dict[Jobs.FILE][Jobs.FILENAME] == job.file.filename
        for (i, name) in enumerate(dict[Jobs.FILE][Jobs.DATANAMES])
            @test name == job.file.datanames[i]
        end
        @test dict[Jobs.FILE][Jobs.NOBS] == job.file.nobs
        @test haskey(dict, Jobs.ESTIMATOR)
        @test dict[Jobs.ESTIMATOR] == job.estimator
        @test haskey(dict, Jobs.EQUATION)
        @test dict[Jobs.EQUATION] == job.equation
        @test haskey(dict, Jobs.PARAMETERS)
        @test dict[Jobs.PARAMETERS] == job.parameters
        @test haskey(dict, Jobs.STATUS)
        @test dict[Jobs.STATUS] == job.status
        @test haskey(dict, Jobs.TIME_ENQUEUED)
        @test dict[Jobs.TIME_ENQUEUED] == job.time_enqueued
        @test haskey(dict, Jobs.TIME_STARTED)
        @test dict[Jobs.TIME_STARTED] == job.time_started
        @test haskey(dict, Jobs.TIME_FINISHED)
        @test dict[Jobs.TIME_FINISHED] == job.time_finished
        @test haskey(dict, Jobs.MSG)
        @test dict[Jobs.MSG] == job.msg
    end
    @testset "Jobs queue" begin
        using Dates
        manager = JobManager(notify)

        file = File(DATA_FILENAME, DATA_FILENAME, data)
        estimator = :ols
        equation = "y x1 x2 x3"
        ttest = true
        parameters = Dict{Symbol,Any}(:ttest => ttest)

        job1 = ModelSelectionJob(file, estimator, equation, parameters)
        add_pending_job(manager, job1)
        @test length(manager.pending_queue) == 1
        @test manager.pending_queue[1] == job1
        job2 = ModelSelectionJob(file, estimator, equation, parameters)
        add_pending_job(manager, job2)
        @test get_pending_queue_length(manager) == 2
        job3 = ModelSelectionJob(file, estimator, equation, parameters)
        push!(manager.finished_queue, job3)
        job4 = ModelSelectionJob(file, estimator, equation, parameters)
        manager.current = job4
        job = Jobs.get_job(manager.pending_queue, job1.id)
        @test job == job1
        job = Jobs.get_job(manager.pending_queue, job2.id)
        @test job == job2
        job = Jobs.get_job(manager.finished_queue, job3.id)
        @test job == job3
        job = Jobs.get_job(manager.finished_queue, "missing")
        @test job === nothing
        job = Jobs.get_job(manager, job1.id)
        @test job == job1
        job = Jobs.get_job(manager, job2.id)
        @test job == job2
        job = Jobs.get_job(manager, job3.id)
        @test job == job3
        job = Jobs.get_job(manager, job4.id)
        @test job == job4
        job = Jobs.get_job(manager, "missing")
        @test job === nothing
        job = Jobs.get_pending_job(manager, job1.id)
        @test job == job1
        job = Jobs.get_pending_job(manager, job2.id)
        @test job == job2
        job = Jobs.get_pending_job(manager, "missing")
        @test job === nothing
        job = Jobs.get_finished_job(manager, job3.id)
        @test job == job3
        job = Jobs.get_finished_job(manager, "missing")
        @test job === nothing
        job = Jobs.get_current_job(manager, job4.id)
        @test job == job4
        job = Jobs.get_current_job(manager, "missing")
        @test job === nothing
        job = Jobs.get_current_job(manager)
        @test job == job4
        Jobs.clear_pending_queue(manager)
        @test length(manager.pending_queue) == 0
        Jobs.clear_finished_queue(manager)
        @test length(manager.finished_queue) == 0
        Jobs.clear_current_job(manager)
        @test manager.current === nothing
        add_pending_job(manager, job1)
        add_pending_job(manager, job2)
        push!(manager.finished_queue, job3)
        manager.current = job4
        Jobs.clear_all_jobs(manager)
        @test length(manager.pending_queue) == 0
        @test length(manager.finished_queue) == 0
        @test manager.current === nothing
        job = Jobs.get_current_job(manager)
        @test job === nothing
    end
end
