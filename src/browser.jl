function browser(;open=true, port=CLIENT_PORT, cloud=false, log=false)
    if open
        url = "http://127.0.0.1:" * string(port)
        sleep(3)
        if Sys.iswindows()
            run(`cmd /c start $url`)
        else
            start = ( Sys.isapple() ? "open" : "xdg-open" )
            run(Cmd([start,url]))
        end
    end
end
