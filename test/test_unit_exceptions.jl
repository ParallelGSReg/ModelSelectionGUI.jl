@safetestset "Test exceptions" begin
    @safetestset "bad_request_exception" begin
        using ModelSelectionGUI

        response = ModelSelectionGUI.bad_request_exception("msg")

    end
end
