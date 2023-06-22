using Test
using ModelSelectionGUI

const PACKAGE_ROOT = pkgdir(ModelSelectionGUI)
const DATA_FILENAME = joinpath(PACKAGE_ROOT, "test/data.csv")

tests = [
    "unit/test_modules.jl",
    #"unit/test_types.jl",
    #"unit/test_utils.jl",
    #"unit/test_variables.jl",
    #"unit/test_exceptions.jl",
    #"unit/test_responses.jl",
    #"integration/test_server.jl",
    #"integration/test_files.jl",
    #"integration/test_jobs.jl",
]

for test in tests
    include(test)
end
