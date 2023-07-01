@safetestset "Test windows" begin
    @safetestset "get_url_from_path" begin
        using ModelSelectionGUI

        url = "http://$(ModelSelectionGUI.SERVER_HOST):$(string(ModelSelectionGUI.SERVER_PORT))"
        @test ModelSelectionGUI.get_url_from_path() == url

        url = "http://$(ModelSelectionGUI.SERVER_HOST):$(string(ModelSelectionGUI.SERVER_PORT))/test"
        @test ModelSelectionGUI.get_url_from_path("/test") == url
        
        url = "http://$(ModelSelectionGUI.SERVER_HOST)/test"
        set_envvars(server_port=80)
        @test ModelSelectionGUI.get_url_from_path("/test") == url
        
        url = "https://$(ModelSelectionGUI.SERVER_HOST)/test"
        set_envvars(server_port=443)
        set_envvars(ssl_enabled=true)
        @test ModelSelectionGUI.get_url_from_path("/test") == url

        url = "https://$(ModelSelectionGUI.SERVER_HOST):8000/test"
        set_envvars(server_port=8000)
        set_envvars(ssl_enabled=true)
        @test ModelSelectionGUI.get_url_from_path("/test") == url
    end

    @safetestset "Windows" begin
        using Electron
        using ModelSelectionGUI

        Electron.prep_test_env()

        ModelSelectionGUI.create_application()
        @test ModelSelectionGUI.ELECTRON_APPLICATION isa Application

        url = "http://julialang.org"
        ModelSelectionGUI.open_window(url)
        @test ModelSelectionGUI.ELECTRON_APPLICATION isa Electron.Application
        @test length(ModelSelectionGUI.ELECTRON_APPLICATION.windows) == 1
        @test ModelSelectionGUI.ELECTRON_APPLICATION.windows[1] isa Electron.Window

        set_envvars(server_host="julialang.org", server_port=443, ssl_enabled=true)
        ModelSelectionGUI.open_window()
        @test length(ModelSelectionGUI.ELECTRON_APPLICATION.windows) == 2
        @test ModelSelectionGUI.ELECTRON_APPLICATION.windows[2] isa Electron.Window

        ModelSelectionGUI.open_window(path="/learning")
        @test length(ModelSelectionGUI.ELECTRON_APPLICATION.windows) == 3
        @test ModelSelectionGUI.ELECTRON_APPLICATION.windows[2] isa Electron.Window

        ModelSelectionGUI.close_windows()
        @test length(ModelSelectionGUI.ELECTRON_APPLICATION.windows) == 0
    end
end
