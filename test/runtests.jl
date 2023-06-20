using Test
using ModelSelectionGUI
using ModelSelectionGUI: ModelSelectionJob

tests = [
    "unit/test_utils.jl",
    "unit/test_variables.jl",
    #"integration/test_server.jl",
    #"integration/test_files.jl",
    #"integration/test_jobs.jl",
]

for test in tests
    include(test)
end
