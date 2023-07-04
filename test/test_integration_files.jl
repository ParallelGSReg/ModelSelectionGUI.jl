
@safetestset "Test files" begin
    @safetestset "Upload file" begin
        using HTTP, JSON
        using ModelSelectionGUI

        start(no_task = true)

        url = "http://$(ModelSelectionGUI.SERVER_HOST):$(ModelSelectionGUI.SERVER_PORT)/upload-file"
        DATA_FILENAME = joinpath(dirname(@__FILE__), "data.csv")

        file = open(DATA_FILENAME, "r")
        body = HTTP.Form(Dict(:data => HTTP.Multipart(DATA_FILENAME, file, "text/csv")))
        response = HTTP.post(url, [], body; connect_timeout = 60)
        msg = String(response.body)
        body = JSON.parse(msg)

        FILENAME = String(ModelSelectionGUI.FILENAME)
        FILEHASH = String(ModelSelectionGUI.FILEHASH)
        DATANAMES = String(ModelSelectionGUI.DATANAMES)
        NOBS = String(ModelSelectionGUI.NOBS)

        @test response.status == 200
        @test haskey(body, FILENAME)
        @test body[FILENAME] isa String
        @test haskey(body, FILEHASH)
        @test body[FILEHASH] isa String
        @test haskey(body, DATANAMES)
        @test body[DATANAMES] isa Vector
        @test haskey(body, NOBS)
        @test body[NOBS] isa Int64

        body = HTTP.Form(Dict(:file => HTTP.Multipart(DATA_FILENAME, file, "text/plain")))
        @test_throws HTTP.Exceptions.StatusError HTTP.post(
            url,
            [],
            body;
            connect_timeout = 60,
        )

        body = HTTP.Form(Dict(:data => HTTP.Multipart(DATA_FILENAME, file, "text/plain")))
        @test_throws HTTP.Exceptions.StatusError HTTP.post(
            url,
            [],
            body;
            connect_timeout = 60,
        )

        stop()
    end
end
