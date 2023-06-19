const DOTENV = "integration/.testenv"

@testset "Server" begin
    @testset "Server start and stop" begin
        start(dotenv = DOTENV)
        stop()
    end

    @testset "GET /server-info" begin
        using HTTP, JSON
        url = "$(ModelSelectionGUI.SERVER_URL):$(ModelSelectionGUI.SERVER_PORT)/server-info"
        reset_envvars()
        start(dotenv = DOTENV)
        response = HTTP.get(url)
        msg = String(response.body)
        body = JSON.parse(msg)

        JULIA_VERSION = "julia_version"
        MODEL_SELECTION_VERSION = "model_selection_version"
        NCORES = "ncores"
        NWORKERS = "nworkers"
        JOBS_QUEUE_SIZE = "jobs_queue_size"

        @test response.status == 200
        @test haskey(body, JULIA_VERSION)
        @test body[JULIA_VERSION] isa String
        @test haskey(body, MODEL_SELECTION_VERSION)
        @test body[MODEL_SELECTION_VERSION] isa String
        @test haskey(body, NCORES)
        @test body[NCORES] isa Int64
        @test haskey(body, NWORKERS)
        @test body[NWORKERS] isa Int64
        @test haskey(body, JOBS_QUEUE_SIZE)
        @test body[JOBS_QUEUE_SIZE] isa Int64

        stop()
    end
end
