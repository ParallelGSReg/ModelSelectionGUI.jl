module ModelSelectionGUI
    using ModelSelection

    include("utils.jl")
    include("const.jl")
    include("exceptions.jl")
    include("jobs.jl")
    include("views.jl")
    include("core.jl")
    include("browser.jl")

    export start
end # module ModelSelectionGUI
