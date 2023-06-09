function browser(;path::Union{String, Nothing} = nothing, port::Int64 = CLIENT_PORT)
    url = "$(SERVER_URL):$(string(port))"
    if path !== nothing
        url *= path
    end
    sleep(3)
    if Sys.iswindows()
        run(`cmd /c start $url`)
    else
        start = (Sys.isapple() ? "open" : "xdg-open")
        run(Cmd([start, url]))
    end
end
