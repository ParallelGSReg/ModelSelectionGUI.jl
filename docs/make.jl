using Documenter, DocumenterTools
using DataFrames
using ModelSelectionGUI, ModelSelection
using ModelSelectionGUI: ModelSelectionJob

# The DOCSARGS environment variable can be used to pass additional arguments to make.jl.
# This is useful on CI, if you need to change the behavior of the build slightly but you
# can not change the .travis.yml or make.jl scripts any more (e.g. for a tag build).
if haskey(ENV, "DOCSARGS")
    for arg in split(ENV["DOCSARGS"])
        (arg in ARGS) || push!(ARGS, arg)
    end
end

makedocs(
    format = Documenter.HTML(
        prettyurls = true,
        assets = ["assets/favicon.ico"],
    ),
    source = "src",
    build   = "build",
    clean   = true,
    modules = [ModelSelectionGUI],
    sitename = "ModelSelectionGUI.jl",
    pages = [
        "Home" => "index.md",
        "Getting Started" => "start.md",
        "Usage" => "usage.md",
        "Configuration" => "configuration.md",
        "API" => Any[
            "Rest" => Any[
                "Endpoints" => "api/rest/index.md",
                "Swagger" => "api/rest/swagger.md",
            ],
            "Websockets" => "api/websockets/index.md",
        ],
        "Library" => Any[
            "Public" => "library/public.md",
            "Internals" => Any[
                "library/internals/constants.md",
                "library/internals/exceptions.md",
                "library/internals/jobs.md",
                "library/internals/responses.md",
                "library/internals/strings.md",
                "library/internals/types.md",
                "library/internals/utils.md",
                "library/internals/variables.md",
                "library/internals/views.md",
                "library/internals/windows.md",
            ],
        ],
        "Contributing" => "contributing.md",
        "News" => "news.md",
        "Todo" => "todo.md",
        "License" => "license.md",
    ],
)

deploydocs(
    repo = "github.com/ParallelGSReg/ModelSelectionGUI.jl.git",
    versions = nothing,
)
