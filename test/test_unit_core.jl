@safetestset "Test core" begin
    @safetestset "No parameters" begin
        using ModelSelectionGUI

        start(no_task = true)
        @test ModelSelectionGUI.ELECTRON_APPLICATION === nothing
        stop()
    end

    @safetestset "Open client" begin
        using Electron
        using ModelSelectionGUI

        Electron.prep_test_env()

        start(open_client = true, no_task = true)
        @test ModelSelectionGUI.ELECTRON_APPLICATION isa Electron.Application
        @test length(ModelSelectionGUI.ELECTRON_APPLICATION.windows) == 1
        @test ModelSelectionGUI.ELECTRON_APPLICATION.windows[1] isa Electron.Window
        stop()
    end

    @safetestset "Open documentation" begin
        using Electron
        using ModelSelectionGUI

        Electron.prep_test_env()

        start(open_documentation = true, no_task = true)
        @test ModelSelectionGUI.ELECTRON_APPLICATION isa Electron.Application
        @test length(ModelSelectionGUI.ELECTRON_APPLICATION.windows) == 1
        @test ModelSelectionGUI.ELECTRON_APPLICATION.windows[1] isa Electron.Window
        stop()
    end

    @safetestset "Open client and documentation" begin
        using Electron
        using ModelSelectionGUI

        Electron.prep_test_env()

        start(open_client = true, open_documentation = true, no_task = true)
        @test ModelSelectionGUI.ELECTRON_APPLICATION isa Electron.Application
        @test length(ModelSelectionGUI.ELECTRON_APPLICATION.windows) == 2
        @test ModelSelectionGUI.ELECTRON_APPLICATION.windows[1] isa Electron.Window
        @test ModelSelectionGUI.ELECTRON_APPLICATION.windows[2] isa Electron.Window
        stop()
    end
end
