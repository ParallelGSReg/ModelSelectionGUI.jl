@safetestset "Test variables" begin
    @safetestset "Load values" begin
        using ModelSelectionGUI

        server_host = "localhost"
        server_port = 5000
        ssl_enabled = true
        open_documentation = true
        open_client = true
        set_envvars(
            server_host = server_host,
            server_port = server_port,
            ssl_enabled = ssl_enabled,
            open_documentation = open_documentation,
            open_client = open_client,
        )
        @test ModelSelectionGUI.SERVER_HOST == server_host
        @test ModelSelectionGUI.SERVER_PORT == server_port
        @test ModelSelectionGUI.SSL_ENABLED == ssl_enabled
        @test ModelSelectionGUI.OPEN_CLIENT == open_client
        @test ModelSelectionGUI.OPEN_DOCUMENTATION == open_documentation
    end

    @safetestset "Default values" begin
        using ModelSelectionGUI

        load_envvars("no_file")
        @test ModelSelectionGUI.SERVER_HOST == ModelSelectionGUI.SERVER_HOST_DEFAULT
        @test ModelSelectionGUI.SERVER_PORT == ModelSelectionGUI.SERVER_PORT_DEFAULT
        @test ModelSelectionGUI.SSL_ENABLED == ModelSelectionGUI.SSL_ENABLED_DEFAULT
        @test ModelSelectionGUI.OPEN_DOCUMENTATION == ModelSelectionGUI.OPEN_DOCUMENTATION_DEFAULT
        @test ModelSelectionGUI.OPEN_CLIENT == ModelSelectionGUI.OPEN_CLIENT_DEFAULT
    end
    @safetestset "Dotenv values" begin
        using ModelSelectionGUI

        envfile = joinpath(dirname(@__FILE__), ".env.variables")
        server_host = "localhost"
        server_port = 5000
        ssl_enabled = true
        open_documentation = true
        open_client = true
        load_envvars(envfile)

        @test ModelSelectionGUI.SERVER_HOST == server_host
        @test ModelSelectionGUI.SERVER_PORT == server_port
        @test ModelSelectionGUI.SSL_ENABLED == ssl_enabled
        @test ModelSelectionGUI.OPEN_DOCUMENTATION == open_documentation
        @test ModelSelectionGUI.OPEN_CLIENT == open_client
    end
    @safetestset "Reset values" begin
        using ModelSelectionGUI

        envfile = joinpath(dirname(@__FILE__), ".env.variables")

        server_host = "localhost"
        server_port = 5000
        ssl_enabled = true
        open_documentation = true
        open_client = true
        load_envvars(envfile)
        
        @test ModelSelectionGUI.SERVER_PORT == server_port
        @test ModelSelectionGUI.SSL_ENABLED == ssl_enabled
        @test ModelSelectionGUI.OPEN_DOCUMENTATION == open_documentation
        @test ModelSelectionGUI.OPEN_CLIENT == open_client
        @test ModelSelectionGUI.SERVER_HOST == server_host
        
        reset_envvars()
        @test ModelSelectionGUI.SERVER_PORT == ModelSelectionGUI.SERVER_PORT_DEFAULT
        @test ModelSelectionGUI.SSL_ENABLED == ModelSelectionGUI.SSL_ENABLED_DEFAULT
        @test ModelSelectionGUI.OPEN_DOCUMENTATION == ModelSelectionGUI.OPEN_DOCUMENTATION_DEFAULT
        @test ModelSelectionGUI.OPEN_CLIENT == ModelSelectionGUI.OPEN_CLIENT_DEFAULT
        @test ModelSelectionGUI.SERVER_HOST == ModelSelectionGUI.SERVER_HOST_DEFAULT
    end
end
