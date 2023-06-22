tests = [
    "modules/test_config.jl",
    "modules/test_jobs.jl",
    "modules/test_gui.jl",
]

for test in tests
    include(test)
end
