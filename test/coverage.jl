using Pkg
Pkg.activate(".")

using Coverage

Pkg.test("ModelSelectionGUI"; coverage = true)

coverage = process_folder()
coverage = merge_coverage_counts(
    coverage,
    filter!(
        let prefixes = (joinpath(pwd(), "src", ""))
            c -> any(p -> startswith(c.filename, p), prefixes)
        end,
        LCOV.readfolder("test"),
    ),
)
covered_lines, total_lines = get_summary(coverage)
Coverage.clean_folder("src")
println("$(covered_lines)/$(total_lines) lines covered")
println("$(covered_lines/total_lines*100)% coverage")
