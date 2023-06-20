@testset "Test exceptions" begin
    @testset "bad_request_exception" begin
        response = ModelSelectionGUI.bad_request_exception("msg")
        @test response.status == 400
    end
end
