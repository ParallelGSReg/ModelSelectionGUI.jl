@safetestset "Test types" begin
    @safetestset "ModelSelectionJob" begin
        using Dates
        using ModelSelectionGUI
        using ModelSelectionGUI: ModelSelectionJob

        estimator = :ols
        equation = "y x1 x2 x3"
        ttest = true
        filename = "data.csv"
        tempfile = "/temp/data.csv"
        filehash = "adbc7420-1597-4b1b-a798-fafd9ee5f671"
        parameters = Dict(:ttest => ttest)
        job =
            ModelSelectionJob(filename, tempfile, filehash, estimator, equation, parameters)

        @test job.id isa String
        @test job.filename isa String
        @test job.filename == filename
        @test job.filehash isa String
        @test job.filehash == filehash
        @test job.parameters isa Dict{Symbol,Any}
        @test haskey(job.parameters, :ttest)
        @test job.parameters[:ttest] == ttest
        @test job.status isa Symbol
        @test job.status == ModelSelectionGUI.PENDING
        @test job.time_enqueued isa DateTime
        @test job.time_started isa Nothing
        @test job.time_finished isa Nothing
        @test job.modelselection_data isa Nothing
        @test job.estimator isa Symbol
        @test job.estimator == estimator
        @test job.equation isa String
        @test job.equation == equation
        @test job.msg isa Nothing
    end
end
