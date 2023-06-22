using Electron
Electron.prep_test_env()

@testset "GUI Module" begin
    using ModelSelectionGUI: GUI, Config
    using ModelSelectionGUI.GUI
    using Electron: Application, Window
    TEST_URL = "julialang.org"

    @testset "ApplicationGUI" begin
        application = ApplicationGUI()
        @test typeof(application) == ApplicationGUI
        @test application.app === nothing
        @test typeof(application.windows) === Dict{Symbol,Window}
        @test length(keys(application.windows)) == 0
        @test application.settings === nothing

        settings = Config.Settings()
        application = ApplicationGUI(settings)
        @test typeof(application) == ApplicationGUI
        @test application.app === nothing
        @test typeof(application.windows) === Dict{Symbol,Window}
        @test length(keys(application.windows)) == 0
        @test application.settings === settings

        application = ApplicationGUI()
        @test application.app === nothing
        @test typeof(application.windows) === Dict{Symbol,Window}
        application2 = initialize_application(application)
        @test typeof(application2) == ApplicationGUI
        @test application2 == application
        @test typeof(application.app) === Application

        application = ApplicationGUI()
        application2 = initialize_application(application)
        application.windows[:documentation] = Window(application.app)
        @test typeof(application.app) === Application
        @test length(keys(application.windows)) == 1
        application2 = close_application(application)
        @test typeof(application2) == ApplicationGUI
        @test application2 == application
        @test application.app === nothing
        @test length(keys(application.windows)) == 0

        application = ApplicationGUI()
        application2 = close_application(application)
        @test typeof(application2) == ApplicationGUI
        @test application2 == application
        application2 = close_application(application)
        @test typeof(application2) == ApplicationGUI
        @test application2 == application
        @test application.app === nothing
    end

    @testset "Windows management" begin
        application = ApplicationGUI()
        initialize_application(application)

        doc_name = :documentation
        home_name = :home
        aux_name = :aux

        application2 = create_window(application, doc_name)
        @test typeof(application2) == ApplicationGUI
        @test application2 == application
        @test length(keys(application.windows)) == 1
        @test typeof(application.windows[doc_name]) === Window

        application2 = create_window(application, home_name)
        @test typeof(application2) == ApplicationGUI
        @test application2 == application
        @test length(keys(application.windows)) == 2
        @test typeof(application.windows[home_name]) === Window

        application2 = create_window(application, doc_name)
        @test typeof(application2) == ApplicationGUI
        @test application2 == application
        @test length(keys(application.windows)) == 2
        @test typeof(application.windows[doc_name]) === Window

        application2 = update_window(application, doc_name)
        @test typeof(application2) == ApplicationGUI
        @test application2 == application
        @test length(keys(application.windows)) == 2
        @test typeof(application.windows[doc_name]) === Window

        application2 = update_window(application, aux_name)
        @test typeof(application2) == ApplicationGUI
        @test application2 == application
        @test length(keys(application.windows)) == 3
        @test typeof(application.windows[aux_name]) === Window

        application2 = close_window(application, home_name)
        @test typeof(application2) == ApplicationGUI
        @test application2 == application
        @test length(keys(application.windows)) == 2

        application2 = close_window(application, doc_name)
        @test typeof(application2) == ApplicationGUI
        @test application2 == application
        @test length(keys(application.windows)) == 1

        application2 = close_window(application, aux_name)
        @test typeof(application2) == ApplicationGUI
        @test application2 == application
        @test length(keys(application.windows)) == 0

        application2 = create_window(application, doc_name, "https://" * TEST_URL)
        @test typeof(application2) == ApplicationGUI
        @test application2 == application
        @test length(keys(application.windows)) == 1
        @test typeof(application.windows[doc_name]) === Window

        application2 = update_window(application, aux_name)
        @test typeof(application2) == ApplicationGUI
        @test application2 == application
        @test length(keys(application.windows)) == 2
        @test typeof(application.windows[aux_name]) === Window

        application2 = update_window(application, home_name, "https://" * TEST_URL)
        @test typeof(application2) == ApplicationGUI
        @test application2 == application
        @test length(keys(application.windows)) == 3
        @test typeof(application.windows[home_name]) === Window

        application2 = update_window(application, home_name, "https://" * TEST_URL)
        @test typeof(application2) == ApplicationGUI
        @test application2 == application
        @test length(keys(application.windows)) == 3
        @test typeof(application.windows[home_name]) === Window

        application2 = close_window(application, aux_name)
        @test typeof(application2) == ApplicationGUI
        @test application2 == application
        @test length(keys(application.windows)) == 2
        application2 = close_window(application, aux_name)
        @test typeof(application2) == ApplicationGUI
        @test application2 == application
        @test length(keys(application.windows)) == 2

        application2 = close_all_windows(application)
        @test typeof(application2) == ApplicationGUI
        @test application2 == application
        @test length(keys(application.windows)) == 0

        application2 = close_application(application)
        @test typeof(application2) == ApplicationGUI
        @test application2 == application
    end
    @testset "Open path and url" begin
        settings = Config.Settings()
        settings.server_host = TEST_URL
        settings.server_port = nothing
        application = ApplicationGUI(settings)
        application2 = initialize_application(application)

        aux_name = :aux
        docs_name = :docs
        application2 = open_path(application, aux_name)
        @test typeof(application2) == ApplicationGUI
        @test application2 == application
        @test length(keys(application.windows)) == 1

        settings.ssl_enabled = true
        application2 = open_path(application, aux_name)
        @test typeof(application2) == ApplicationGUI
        @test application2 == application
        @test length(keys(application.windows)) == 1

        settings.server_port = 443
        application2 = open_path(application, aux_name)
        @test typeof(application2) == ApplicationGUI
        @test application2 == application
        @test length(keys(application.windows)) == 1

        application2 = open_url(application, docs_name, "https://" * TEST_URL)
        @test typeof(application2) == ApplicationGUI
        @test application2 == application
        @test length(keys(application.windows)) == 2

        application.settings = nothing
        @test_throws ErrorException open_path(application, aux_name)
    end
end
