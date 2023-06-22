using Documenter, DocumenterTools
using DataFrames
using ModelSelectionGUI, ModelSelection
using ModelSelectionGUI.Config
using ModelSelectionGUI.GUI
using ModelSelectionGUI.Jobs

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
        prettyurls = false,
        assets = ["assets/favicon.ico"],
    ),
    source = "src",
    build   = "build",
    clean   = true,
    modules = [ModelSelectionGUI, Config, GUI, Jobs],
    sitename = "ModelSelectionGUI.jl",
    authors = "Adán Mauri Ungaro <adan.mauri@gmail.com",
    pages = [
        "Home" => "index.md",
        "Configuration" => "configuration.md",
        "Library" => Any[
            "Public" => "library/public.md",
            "Modules" => Any[
                "library/modules/Config.md",
                "library/modules/GUI.md",
                "library/modules/Jobs.md",
            ],
            #"Modules" => Any[
            #    "library/public.md"
            #],
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
