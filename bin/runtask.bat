julia --color=yes --depwarn=no --threads=auto --project=@. -q -- "%~dp0..\bootstrap.jl" -r %*
