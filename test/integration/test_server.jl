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

        JULIA_VERSION = String(ModelSelectionGUI.JULIA_VERSION)
        MODEL_SELECTION_VERSION = String(ModelSelectionGUI.MODEL_SELECTION_VERSION)
        NCORES = String(ModelSelectionGUI.NCORES)
        NWORKERS = String(ModelSelectionGUI.NWORKERS)
        JOBS_QUEUE_SIZE = String(ModelSelectionGUI.JOBS_QUEUE_SIZE)

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
