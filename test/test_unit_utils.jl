@safetestset "Test utils" begin
    @safetestset "get_pkg_version" begin
        using Pkg
        using ModelSelectionGUI, ModelSelection

        function get_pkg_version(name::AbstractString)
            version = nothing
            for dependency in Pkg.dependencies()
                if dependency[2].name == name
                    return dependency[2].version
                end
            end
            return version
        end
        version = get_pkg_version("ModelSelection")
        pkg_version = ModelSelectionGUI.get_pkg_version("ModelSelection")

        @test pkg_version == version
    end

    @safetestset "save_tempfile" begin
        using CSV, DataFrames
        using ModelSelectionGUI

        name = tempname()
        data = DataFrame([1 2 3 4; 5 6 7 8], ["y", "x1", "x2", "x3"])
        ModelSelectionGUI.save_tempfile(name, data)
        new_data = CSV.read(name, DataFrame)
        old_names = names(data)
        new_names = names(new_data)

        for i = 1:3
            @test old_names[i] == new_names[i]
        end
        for i = 1:2
            for j = 1:3
                @test data[i, j] == new_data[i, j]
            end
        end
    end

    @safetestset "get_csv_filename AllSubsetRegressionResult" begin
        using ModelSelectionGUI, ModelSelection

        csv_filename = "data_allsubsetregression.csv"
        filename = "data.csv"
        result = ModelSelection.AllSubsetRegression.AllSubsetRegressionResult(
            :ols,
            [:a, :b, :c],
            :qr_32,
            nothing,
            nothing,
            [:r2adj],
            false,
            false,
            false,
        )
        @test csv_filename == ModelSelectionGUI.get_csv_filename(filename, result)
    end

    @safetestset "get_csv_filename CrossValidationResult" begin
        using ModelSelectionGUI, ModelSelection

        csv_filename = "data_crossvalidation.csv"
        filename = "data.csv"
        result = ModelSelection.CrossValidation.CrossValidationResult(
            1,
            2,
            false,
            [:a, :b],
            nothing,
            nothing,
            [],
        )

        @test csv_filename == ModelSelectionGUI.get_csv_filename(filename, result)
    end

    @safetestset "get_txt_filename" begin
        using ModelSelectionGUI

        txt_filename = "data_summary.txt"
        filename = "data.csv"

        @test txt_filename == ModelSelectionGUI.get_txt_filename(filename)
    end

    @safetestset "get_csv_from_result" begin
        using CSV, DataFrames
        using ModelSelectionGUI, ModelSelection

        DATA_FILENAME = joinpath(dirname(@__FILE__), "data.csv")
        csv_filename = "data_allsubsetregression.csv"
        data = CSV.read(DATA_FILENAME, DataFrame)
        modelselection_data = gsr(:ols, "y x1 x2 x3", data)
        result = ModelSelectionGUI.get_csv_from_result(
            DATA_FILENAME,
            modelselection_data.results[1],
        )

        @test result isa Dict
        @test result[ModelSelectionGUI.FILENAME] == csv_filename
        @test result[ModelSelectionGUI.DATA] isa String
    end

    @safetestset "get_parameters" begin
        using ModelSelectionGUI

        a = 1
        b = 2
        c = 3
        fixedvariables = ["a", "b", "c"]
        params = Dict("a" => a, "b" => b, "c" => c, "fixedvariables" => fixedvariables)
        parameters = ModelSelectionGUI.get_parameters(params)

        @test haskey(parameters, :a)
        @test parameters[:a] == a
        @test haskey(parameters, :b)
        @test parameters[:b] == b
        @test haskey(parameters, :c)
        @test parameters[:c] == c
        @test haskey(parameters, :fixedvariables)
        @test parameters[:fixedvariables][1] == Symbol(fixedvariables[1])
        @test parameters[:fixedvariables][2] == Symbol(fixedvariables[2])
        @test parameters[:fixedvariables][3] == Symbol(fixedvariables[3])
    end

    @safetestset "to_dict" begin
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
        id = "83ecac9e-678d-4c80-9314-0ae4a67d5ace"
        status = ModelSelectionGUI.FINISHED
        time_enqueued = DateTime("2023-01-01T01:01:01")
        time_started = DateTime("2023-02-02T02:02:02")
        time_finished = DateTime("2023-02-02T02:02:02")
        modelselection_data = nothing
        msg = "A msg"

        job.id = id
        job.filename = filename
        job.filehash = filehash
        job.status = ModelSelectionGUI.FINISHED
        job.time_enqueued = time_enqueued
        job.time_started = time_started
        job.time_finished = time_finished
        job.modelselection_data = nothing
        job.msg = msg

        dict = ModelSelectionGUI.to_dict(job)

        @test haskey(dict, ModelSelectionGUI.ID)
        @test dict[ModelSelectionGUI.ID] == id
        @test haskey(dict, ModelSelectionGUI.FILENAME)
        @test dict[ModelSelectionGUI.FILENAME] == filename
        @test haskey(dict, ModelSelectionGUI.FILEHASH)
        @test dict[ModelSelectionGUI.FILEHASH] == filehash
        @test haskey(dict, ModelSelectionGUI.PARAMETERS)
        @test haskey(dict[ModelSelectionGUI.PARAMETERS], :ttest)
        @test dict[ModelSelectionGUI.PARAMETERS][:ttest] == ttest
        @test haskey(dict, ModelSelectionGUI.STATUS)
        @test dict[ModelSelectionGUI.STATUS] == status
        @test haskey(dict, ModelSelectionGUI.TIME_ENQUEUED)
        @test dict[ModelSelectionGUI.TIME_ENQUEUED] == time_enqueued
        @test haskey(dict, ModelSelectionGUI.TIME_STARTED)
        @test dict[ModelSelectionGUI.TIME_STARTED] == time_started
        @test haskey(dict, ModelSelectionGUI.TIME_FINISHED)
        @test dict[ModelSelectionGUI.TIME_FINISHED] == time_finished
        @test haskey(dict, ModelSelectionGUI.ESTIMATOR)
        @test dict[ModelSelectionGUI.ESTIMATOR] == estimator
        @test haskey(dict, ModelSelectionGUI.EQUATION)
        @test dict[ModelSelectionGUI.EQUATION] == equation
        @test haskey(dict, ModelSelectionGUI.MSG)
        @test dict[ModelSelectionGUI.MSG] == msg
    end

    @safetestset "get_request_job_id" begin
        using ModelSelectionGUI

        function func1(key::Symbol)
            dict = Dict(:id => "job_id")
            return dict[key]
        end
        function func2(key::Symbol)
            dict = Dict(:filehash => "job_id")
            return dict[key]
        end

        @test ModelSelectionGUI.get_request_job_id(func1) == "job_id"
        @test ModelSelectionGUI.get_request_job_id(func2) isa Nothing
    end

    @safetestset "get_request_filehash" begin
        using ModelSelectionGUI

        function func1(key::Symbol)
            dict = Dict(:filehash => "filehash")
            return dict[key]
        end
        function func2(key::Symbol)
            dict = Dict(:id => "filehash")
            return dict[key]
        end

        @test ModelSelectionGUI.get_request_filehash(func1) == "filehash"
        @test ModelSelectionGUI.get_request_filehash(func2) isa Nothing
    end
end
