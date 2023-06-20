@testset "Test browser" begin
    @testset "browser without path" begin
        @test ModelSelectionGUI.browser(path = "/")
    end
    @testset "browser with path" begin
        @test ModelSelectionGUI.browser(path = "/")
    end
end
