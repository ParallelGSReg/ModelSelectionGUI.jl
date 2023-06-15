using Documenter, DocumenterTools
using ModelSelectionGUI

makedocs(
    format = Documenter.HTML(prettyurls = false),
    source = "src",
    build   = "build",
    clean   = true,
    modules = [ModelSelectionGUI],
    sitename = "ModelselectionGUI.jl",
    # expandfirst
    pages = [
        "Home" => "index.md",
        "Getting Started" => "start.md",
        "Configuration" => "configuration.md",
        "API" => Any[
            "Rest" => Any[
                "api/rest/index.md",
                "api/rest/swagger.md"
            ],
            "Websockets" => "api/websockets/index.md",
        ],
        "Contributing" => "contributing.md",
        "News" => "news.md",
        "Todo" => "todo.md",
        "License" => "license.md",
    ],
)

deploydocs(repo = "github.com/ParallelGSReg/ModelSelectionGUI.jl.git")
