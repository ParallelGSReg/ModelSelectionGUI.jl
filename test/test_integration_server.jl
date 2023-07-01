@safetestset "Test server" begin
    @safetestset "Server start and stop" begin
        using ModelSelectionGUI

        start(no_task=true)
        stop()
    end
    @safetestset "GET /server-info" begin
        using HTTP, JSON
        using ModelSelectionGUI
        
        start(no_task=true)

        url = "http://$(ModelSelectionGUI.SERVER_HOST):$(ModelSelectionGUI.SERVER_PORT)/server-info"

        response = HTTP.get(url; connect_timeout = 60)
        msg = String(response.body)
        body = JSON.parse(msg)

        JULIA_VERSION = String(ModelSelectionGUI.JULIA_VERSION)
        MODEL_SELECTION_VERSION = String(ModelSelectionGUI.MODEL_SELECTION_VERSION)
        NCORES = String(ModelSelectionGUI.NCORES)
        NWORKERS = String(ModelSelectionGUI.NWORKERS)
        PENDING_QUEUE_SIZE = String(ModelSelectionGUI.PENDING_QUEUE_SIZE)

        @test response.status == 200
        @test haskey(body, JULIA_VERSION)
        @test body[JULIA_VERSION] isa String
        @test haskey(body, MODEL_SELECTION_VERSION)
        @test body[MODEL_SELECTION_VERSION] isa String
        @test haskey(body, NCORES)
        @test body[NCORES] isa Int64
        @test haskey(body, NWORKERS)
        @test body[NWORKERS] isa Int64
        @test haskey(body, PENDING_QUEUE_SIZE)
        @test body[PENDING_QUEUE_SIZE] isa Int64

        stop()
    end
end
