@testset "Environment variables" begin
    @testset "Default values" begin
        load_envvars("no_file")
        @test ModelSelectionGUI.SERVER_PORT == ModelSelectionGUI.SERVER_PORT_DEFAULT
        @test ModelSelectionGUI.CLIENT_PORT == ModelSelectionGUI.SERVER_PORT_DEFAULT + 1
        @test ModelSelectionGUI.OPEN_BROWSER == ModelSelectionGUI.OPEN_BROWSER_DEFAULT
        @test ModelSelectionGUI.OPEN_CLIENT == ModelSelectionGUI.OPEN_CLIENT_DEFAULT
        @test ModelSelectionGUI.SERVER_URL == ModelSelectionGUI.SERVER_URL_DEFAULT
    end
    @testset "Dotenv values" begin
        DOTENV_FILENAME = "unit/.variables_testenv"
        server_port = 5000
        client_port = 5050
        open_browser = true
        open_client = true
        server_url = "http://localhost"
        load_envvars(DOTENV_FILENAME)
        @test ModelSelectionGUI.SERVER_PORT == server_port
        @test ModelSelectionGUI.CLIENT_PORT == client_port
        @test ModelSelectionGUI.OPEN_BROWSER == open_browser
        @test ModelSelectionGUI.OPEN_CLIENT == open_client
        @test ModelSelectionGUI.SERVER_URL == server_url
    end
    @testset "Reset values" begin
        DOTENV_FILENAME = "unit/.variables_testenv"
        server_port = 5000
        client_port = 5050
        open_browser = true
        open_client = true
        server_url = "http://localhost"
        reset_envvars()
        load_envvars(DOTENV_FILENAME)
        @test ModelSelectionGUI.SERVER_PORT == server_port
        @test ModelSelectionGUI.CLIENT_PORT == client_port
        @test ModelSelectionGUI.OPEN_BROWSER == open_browser
        @test ModelSelectionGUI.OPEN_CLIENT == open_client
        @test ModelSelectionGUI.SERVER_URL == server_url
        reset_envvars()
        @test ModelSelectionGUI.SERVER_PORT == ModelSelectionGUI.SERVER_PORT_DEFAULT
        @test ModelSelectionGUI.CLIENT_PORT == ModelSelectionGUI.SERVER_PORT_DEFAULT + 1
        @test ModelSelectionGUI.OPEN_BROWSER == ModelSelectionGUI.OPEN_BROWSER_DEFAULT
        @test ModelSelectionGUI.OPEN_CLIENT == ModelSelectionGUI.OPEN_CLIENT_DEFAULT
        @test ModelSelectionGUI.SERVER_URL == ModelSelectionGUI.SERVER_URL_DEFAULT
    end
end
