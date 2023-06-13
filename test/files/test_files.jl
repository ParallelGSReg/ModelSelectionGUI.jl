const DATA_FILENAME = "data.csv"

@testset  "Files" begin
    @testset "Upload file" begin
        using HTTP, JSON
        dotenv = "files/$(DOTENV_FILENAME)"
        URL = "/upload-file"
        url = "$(ModelSelectionGUI.SERVER_URL):$(ModelSelectionGUI.SERVER_PORT)$(URL)"

		start(dotenv=dotenv)        
        file = open(DATA_FILENAME, "r")
        body = HTTP.Form(Dict(:data => HTTP.Multipart(DATA_FILENAME, file, "text/csv")))
        response = HTTP.post(url, [], body)
        msg = String(response.body)
        body = JSON.parse(msg)

        FILENAME = "filename"
        FILEHASH = "filehash"
        DATANAMES = "datanames"
        NOBS = "nobs"

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
