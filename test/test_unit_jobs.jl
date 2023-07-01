@safetestset "Test jobs" begin
    
    @safetestset "ModelSelectionJob" begin
        using CSV, DataFrames, Dates
        using ModelSelectionGUI
        using ModelSelectionGUI: ModelSelectionJob
        
        filename = "data.csv"
        tempfile = "/temp/data.csv"
        filehash = "96c12b9b-c132-405c-af22-b4c1d8053b1e"
        estimator = :ols
        equation = "y x1 x2 x3"
        ttest = true
        parameters = Dict{Symbol,Any}(:ttest => ttest)
        status = ModelSelectionGUI.PENDING

        job = ModelSelectionJob(filename, tempfile, filehash, estimator, equation, parameters)

        @test job.id isa String
        @test job.filename == filename
        @test job.tempfile == tempfile
        @test job.filehash == filehash
        @test job.estimator == estimator
        @test job.equation == equation
        @test job.parameters isa Dict{Symbol,Any}
        @test haskey(job.parameters, :ttest)
        @test job.parameters[:ttest] == ttest
        @test job.status == status
        @test job.time_started isa Nothing
        @test job.time_finished isa Nothing
        @test job.modelselection_data isa Nothing
        @test job.msg isa Nothing

        dict = ModelSelectionGUI.to_dict(job)
        
        @test dict isa Dict{Symbol,Any}
        @test dict[ModelSelectionGUI.ID] == job.id
        @test dict[ModelSelectionGUI.FILENAME] == filename
        @test dict[ModelSelectionGUI.FILEHASH] == filehash
        @test dict[ModelSelectionGUI.ESTIMATOR] == estimator
        @test dict[ModelSelectionGUI.EQUATION] == equation
        @test dict[ModelSelectionGUI.PARAMETERS][:ttest] == parameters[:ttest]
        @test dict[ModelSelectionGUI.STATUS] == status
        @test dict[ModelSelectionGUI.TIME_ENQUEUED] isa DateTime
        @test dict[ModelSelectionGUI.TIME_STARTED] isa Nothing
        @test dict[ModelSelectionGUI.TIME_FINISHED] isa Nothing
        @test dict[ModelSelectionGUI.MSG] isa Nothing
    end

    @safetestset "Files" begin
        using ModelSelectionGUI

        filehash1 = "96c12b9b-c132-405c-af22-b4c1d8053b1e"
        filename1 = "data1.csv"
        tempfile1 = "/temp/data1.csv"
        ModelSelectionGUI.add_job_file(filehash1, tempfile1, filename1)
        
        filehash2 = "16c12b9b-c132-405c-af22-b4c1d8053b1e"
        filename2 = "data2.csv"
        tempfile2 = "/temp/data2.csv"
        ModelSelectionGUI.add_job_file(filehash2, tempfile2, filename2)

        @test ModelSelectionGUI.get_job_file(filehash1)[ModelSelectionGUI.FILENAME] == filename1
        @test ModelSelectionGUI.get_job_file(filehash2)[ModelSelectionGUI.FILENAME] == filename2
    end

    @safetestset "Jobs queue" begin
        using Dates
        using ModelSelectionGUI
        using ModelSelectionGUI: ModelSelectionJob
        using ModelSelection: ModelSelectionData

        DATA_FILENAME = joinpath(dirname(@__FILE__), "data.csv")
        filename = DATA_FILENAME
        tempfile = DATA_FILENAME
        filehash = "96c12b9b-c132-405c-af22-b4c1d8053b1e"
        estimator = :ols
        equation = "y x1 x2 x3"
        ttest = true
        parameters = Dict{Symbol,Any}(:ttest => ttest)

        job1 = ModelSelectionJob(filename, tempfile, filehash, estimator, equation, parameters)
        ModelSelectionGUI.add_pending_job(job1)
        @test length(ModelSelectionGUI.pending_queue) == 1
        @test ModelSelectionGUI.get_pending_queue_length() == length(ModelSelectionGUI.pending_queue)
        @test ModelSelectionGUI.pending_queue[1] == job1

        job2 = ModelSelectionJob(filename, tempfile, filehash, estimator, equation, parameters)
        ModelSelectionGUI.add_pending_job(job2)
        @test length(ModelSelectionGUI.pending_queue) == 2
        @test ModelSelectionGUI.get_pending_queue_length() == length(ModelSelectionGUI.pending_queue)
        @test ModelSelectionGUI.pending_queue[2] == job2

        job3 = ModelSelectionJob(filename, tempfile, filehash, estimator, equation, parameters)
        push!(ModelSelectionGUI.finished_queue, job3)

        job4 = ModelSelectionJob(filename, tempfile, filehash, estimator, equation, parameters)
        ModelSelectionGUI.set_current_job(job4)

        @test ModelSelectionGUI.get_job(ModelSelectionGUI.pending_queue, job1.id) == job1
        @test ModelSelectionGUI.get_job(ModelSelectionGUI.pending_queue, job2.id) == job2
        @test ModelSelectionGUI.get_job(ModelSelectionGUI.pending_queue, "missing") === nothing
        @test ModelSelectionGUI.get_job(ModelSelectionGUI.finished_queue, job3.id) == job3
        @test ModelSelectionGUI.get_job(ModelSelectionGUI.finished_queue, "missing") === nothing

        @test ModelSelectionGUI.get_job(job1.id) == job1
        @test ModelSelectionGUI.get_job(job2.id) == job2
        @test ModelSelectionGUI.get_job(job3.id) == job3
        @test ModelSelectionGUI.get_job(job4.id) == job4
        @test ModelSelectionGUI.get_job("missing") === nothing

        @test ModelSelectionGUI.get_pending_job(job1.id) == job1
        @test ModelSelectionGUI.get_pending_job(job2.id) == job2
        @test ModelSelectionGUI.get_pending_job(job3.id) === nothing

        @test ModelSelectionGUI.get_finished_job(job3.id) == job3
        @test ModelSelectionGUI.get_finished_job(job2.id) === nothing

        @test ModelSelectionGUI.get_current_job(job4.id) == job4
        @test ModelSelectionGUI.get_current_job() == job4
        @test ModelSelectionGUI.get_current_job(job1.id) === nothing

        ModelSelectionGUI.clear_pending_queue()
        @test length(ModelSelectionGUI.pending_queue) == 0

        ModelSelectionGUI.clear_finished_queue()
        @test length(ModelSelectionGUI.finished_queue) == 0

        ModelSelectionGUI.clear_current_job()
        @test ModelSelectionGUI.current_job === nothing

        ModelSelectionGUI.add_pending_job(job1)
        ModelSelectionGUI.add_pending_job(job2)
        push!(ModelSelectionGUI.finished_queue, job3)
        ModelSelectionGUI.set_current_job(job4)
        ModelSelectionGUI.clear_all_jobs()
        
        @test length(ModelSelectionGUI.pending_queue) == 0
        @test length(ModelSelectionGUI.finished_queue) == 0
        @test ModelSelectionGUI.current_job === nothing
        @test ModelSelectionGUI.get_current_job() === nothing
    
        job = ModelSelectionJob(filename, tempfile, filehash, estimator, equation, parameters)
        ModelSelectionGUI.run_job(job)
        job.status == ModelSelectionGUI.FINISHED
        @test length(ModelSelectionGUI.finished_queue) == 1
        @test ModelSelectionGUI.finished_queue[1] == job
        @test job.modelselection_data isa ModelSelectionData
        @test job.time_started isa DateTime
        @test job.time_finished isa DateTime

        job = ModelSelectionJob(filename, tempfile, filehash, estimator, equation, Dict{Symbol,Any}(:invalid => "error"))
        ModelSelectionGUI.run_job(job)
        job.status == ModelSelectionGUI.FAILED
        @test length(ModelSelectionGUI.finished_queue) == 2
        @test ModelSelectionGUI.finished_queue[2] == job
        @test job.modelselection_data isa Nothing
        @test job.time_started isa DateTime
        @test job.time_finished isa DateTime
        @test job.msg isa String

        job = ModelSelectionJob(filename, tempfile, filehash, estimator, equation)
        ModelSelectionGUI.add_pending_job(job)
        ModelSelectionGUI.consume_pending_job()
        @test length(ModelSelectionGUI.finished_queue) == 3
        @test ModelSelectionGUI.finished_queue[3] == job
        @test job.modelselection_data isa ModelSelectionData
        @test job.time_started isa DateTime
        @test job.time_finished isa DateTime
    end
end
