@testset  "Jobs" begin
    @testset "POST /job-enqueue/:filehash" begin
        using HTTP, JSON
        
        filename = "data.csv"
        tempfile = "data.csv"
        filehash = "3ecf376b-2e64-416e-ab13-423cad91c67c"
        ModelSelectionGUI.add_job_file(filehash, tempfile, filename)

        params = Dict(
            "estimator" => "ols",
            "equation" => "y x1 x2 x3",
            "ttest" => true,
        )

        URL = "/job-enqueue/$(filehash)"
        dotenv = "jobs/$(DOTENV_FILENAME)"
        url = "$(ModelSelectionGUI.SERVER_URL):$(ModelSelectionGUI.SERVER_PORT)$(URL)"

		start(dotenv=dotenv)

        response = HTTP.post(url, [], params)
        msg = String(response.body)
        body = JSON.parse(msg)


        ID = "id"
        FILEHASH = "filehash"
        FILENAME = "filename"
        STATUS = "status"
        MSG = "msg"
        TIME_ENQUEUED = "time_enqueued"
        TIME_STARTED = "time_started"
        TIME_FINISHED = "time_finished"
        ESTIMATOR = "estimator"
        EQUATION = "equation"
        TTEST = "ttest"
        PARAMETERS = "parameters"

		@test response.status == 200
		@test haskey(body, ID)
        @test body[ID] isa String
        @test haskey(body, FILEHASH)
        @test body[FILEHASH] isa String
        @test body[FILEHASH] == filehash
        @test haskey(body, FILENAME)
        @test body[FILENAME] isa String
        @test body[FILENAME] == filename
        @test haskey(body, STATUS)
        @test body[STATUS] isa String
        @test haskey(body, MSG)
        @test haskey(body, TIME_ENQUEUED)
        @test body[TIME_ENQUEUED] isa String
        @test haskey(body, TIME_STARTED)
        @test haskey(body, TIME_FINISHED)
        @test haskey(body, ESTIMATOR)
        @test body[ESTIMATOR] isa String
        @test haskey(body, EQUATION)
        @test body[EQUATION] isa String
        @test haskey(body, PARAMETERS)
        @test body[PARAMETERS] isa Dict
        @test haskey(body[PARAMETERS], TTEST)
        @test bodybody[PARAMETERS][TTEST] isa Bool
        stop()
    end
end
