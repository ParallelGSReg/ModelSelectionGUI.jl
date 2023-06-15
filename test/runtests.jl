using Test
using ModelSelectionGUI

const DOTENV_FILENAME = ".testenv"

tests = [
    "variables/test_variables.jl",
    "server/test_server.jl",
    "files/test_files.jl",
]

for test in tests
    include(test)
end
