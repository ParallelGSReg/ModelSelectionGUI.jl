const DATA_FILENAME = "data.csv"
const DOTENV = "integration/.testenv"

@testset "Files" begin
    @testset "Upload file" begin
        using HTTP, JSON
        URL = "/upload-file"
        url = "$(ModelSelectionGUI.SERVER_URL):$(ModelSelectionGUI.SERVER_PORT)$(URL)"
        reset_envvars()
        start(dotenv = DOTENV)
        file = open(DATA_FILENAME, "r")
        body = HTTP.Form(Dict(:data => HTTP.Multipart(DATA_FILENAME, file, "text/csv")))
        response = HTTP.post(url, [], body)
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

        stop()
    end
end
