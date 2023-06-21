const DATA_FILENAME = "data.csv"
const DOTENV = "integration/.testenv"
const URL = "$(ModelSelectionGUI.SERVER_URL):$(ModelSelectionGUI.SERVER_PORT)/upload-file"

const FILENAME = String(ModelSelectionGUI.FILENAME)
const FILEHASH = String(ModelSelectionGUI.FILEHASH)
const DATANAMES = String(ModelSelectionGUI.DATANAMES)
const NOBS = String(ModelSelectionGUI.NOBS)

@testset "Files" begin
    @testset "Upload file successfuly" begin
        using HTTP, JSON, CSV, DataFrames
        stop()
        reset_envvars()
        start(dotenv = DOTENV)
        
        file = open(DATA_FILENAME, "r")
        request_body = HTTP.Form(Dict(:data => HTTP.Multipart(DATA_FILENAME, file, ModelSelectionGUI.CSV_MIME)))
        response = HTTP.post(URL, [], request_body)
        body = JSON.parse(String(response.body))

        data = CSV.read(DATA_FILENAME, DataFrame)

        @test response.status == ModelSelectionGUI.HTTP_200_OK
        @test haskey(body, FILENAME)
        @test body[FILENAME] isa String
        @test body[FILENAME] == DATA_FILENAME
        @test haskey(body, FILEHASH)
        @test body[FILEHASH] isa String
        @test haskey(body, DATANAMES)
        @test body[DATANAMES] isa Vector
        for i in 1:lastindex(names(data))
            @test names(data)[i] == body[DATANAMES][i]
        end
        @test haskey(body, NOBS)
        @test body[NOBS] isa Int64
        @test body[NOBS] == nrow(data)       
        stop()
    end
    @testset "Upload file fail: invalid mime" begin
        using HTTP, JSON, CSV, DataFrames
        stop()
        reset_envvars()
        start(dotenv = DOTENV)
        
        file = open(DATA_FILENAME, "r")
        request_body = HTTP.Form(Dict(:data => HTTP.Multipart(DATA_FILENAME, file, ModelSelectionGUI.PLAIN_MIME)))
        @test HTTP.post(URL, [], request_body).status == ModelSelectionGUI.HTTP_400_BAD_REQUEST
        stop()
    end
end
