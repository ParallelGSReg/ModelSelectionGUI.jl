
@safetestset "Test home and docs" begin
    using HTTP, JSON
    using ModelSelectionGUI
        
    start(no_task=true)

    url = "http://$(ModelSelectionGUI.SERVER_HOST):$(ModelSelectionGUI.SERVER_PORT)"
    response = HTTP.get(url; connect_timeout = 60)
    @test response.status == 200

    url = "http://$(ModelSelectionGUI.SERVER_HOST):$(ModelSelectionGUI.SERVER_PORT)/docs"
    response = HTTP.get(url; connect_timeout = 60)
    @test response.status == 200

    stop()
end
