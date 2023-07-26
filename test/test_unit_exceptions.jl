@safetestset "Test exceptions" begin
    @safetestset "bad_request_exception" begin
        using ModelSelectionGUI

        response = ModelSelectionGUI.bad_request_exception("msg")
        @test response.status == 400
    end
end
