# It is not necessary to edit this file.
# To create tests, simply add `.jl` test files in the `test/` folder.
# All `.jl` files in the `test/` folder will be automatically executed by running `$ julia --project runtests.jl`
# If you want to selectively run tests, use `$ julia --project runtests.jl test_file_1 test_file_2`
ENV["GENIE_ENV"] = "test"

TEST_DIR = dirname(@__FILE__)
PACKAGE_DIR = abspath(normpath(joinpath(TEST_DIR, "..")))
push!(LOAD_PATH, abspath(normpath(joinpath(PACKAGE_DIR, "src"))))

cd(PACKAGE_DIR)

using Pkg
Pkg.activate(".")

using Test, TestSetExtensions, SafeTestsets, Logging

Logging.global_logger(NullLogger())

tests = [
    joinpath(TEST_DIR, "test_integration_files.jl"),
    joinpath(TEST_DIR, "test_integration_server.jl"),
    joinpath(TEST_DIR, "test_integration_jobs.jl"),
    joinpath(TEST_DIR, "test_unit_exceptions.jl"),
    joinpath(TEST_DIR, "test_unit_responses.jl"),
    joinpath(TEST_DIR, "test_unit_types.jl"),
    joinpath(TEST_DIR, "test_unit_utils.jl"),
    joinpath(TEST_DIR, "test_unit_variables.jl"),
    joinpath(TEST_DIR, "test_unit_windows.jl"),
]

# for test in tests
#     include(test)
# end

@testset ExtendedTestSet "ModelSelectionGUI tests" begin
    @includetests ARGS
end
