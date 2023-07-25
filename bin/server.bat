julia --color=yes --depwarn=no --threads=auto --project=@. -q -i -- "%~dp0..\bootstrap.jl" -s=true %*
