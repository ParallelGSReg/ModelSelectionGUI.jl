@testset "Config Module" begin
    using ModelSelectionGUI.Config

    FILE1 = ".env.config1"
    FILE2 = ".env.config2"
    FILE3 = ".env.config3"
    FILE4 = ".env.config4"

    DIR = dirname(@__FILE__)

    settings = Settings()
    @test typeof(settings) == Settings
    @test settings.server_host == SERVER_HOST_DEFAULT
    @test settings.server_port == SERVER_PORT_DEFAULT
    @test settings.ssl_enabled == SSL_ENABLED_DEFAULT
    @test settings.open_client == OPEN_CLIENT_DEFAULT
    @test settings.open_documentation == OPEN_DOCUMENTATION_DEFAULT

    server_host = "localhost"
    server_port = 3000
    ssl_enabled = true
    open_client = true
    open_documentation = true
    settings = Settings(
        server_host = server_host,
        server_port = server_port,
        ssl_enabled = ssl_enabled,
        open_client = open_client,
        open_documentation = open_documentation,
    )
    @test typeof(settings) == Settings
    @test settings.server_host == server_host
    @test settings.server_port == server_port
    @test settings.ssl_enabled == ssl_enabled
    @test settings.open_client == open_client
    @test settings.open_documentation == open_documentation

    server_host = "localhost"
    server_port = 3000
    ssl_enabled = true
    open_client = true
    open_documentation = true
    settings = Settings()
    settings2 = load_settings(
        settings,
        server_host = server_host,
        server_port = server_port,
        ssl_enabled = ssl_enabled,
        open_client = open_client,
        open_documentation = open_documentation,
    )
    @test typeof(settings2) == Settings
    @test settings2 == settings
    @test settings.server_host == server_host
    @test settings.server_port == server_port
    @test settings.ssl_enabled == ssl_enabled
    @test settings.open_client == open_client
    @test settings.open_documentation == open_documentation

    server_host = "localhost"
    server_port_param = false
    server_port = nothing
    ssl_enabled = true
    open_client = true
    open_documentation = true
    settings = Settings()
    settings2 = load_settings(
        settings,
        server_host = server_host,
        server_port = server_port_param,
        ssl_enabled = ssl_enabled,
        open_client = open_client,
        open_documentation = open_documentation,
    )
    @test typeof(settings2) == Settings
    @test settings2 == settings
    @test settings.server_host == server_host
    @test settings.server_port == server_port
    @test settings.ssl_enabled == ssl_enabled
    @test settings.open_client == open_client
    @test settings.open_documentation == open_documentation

    server_host = "testenv1"
    server_port = 5050
    open_documentation = true
    settings = Settings()
    settings2 = load_settings(settings, joinpath(DIR, FILE1))
    @test typeof(settings2) == Settings
    @test settings2 == settings
    @test settings.server_host == server_host
    @test settings.server_port == server_port
    @test settings.ssl_enabled == SSL_ENABLED_DEFAULT
    @test settings.open_client == OPEN_CLIENT_DEFAULT
    @test settings.open_documentation == open_documentation

    server_host = "testenv2"
    server_port = 5051
    ssl_enabled = true
    open_client = true
    open_documentation = true
    settings = Settings()
    settings2 = load_settings(settings, joinpath(DIR, FILE2))
    @test typeof(settings2) == Settings
    @test settings2 == settings
    @test settings.server_host == server_host
    @test settings.server_port == server_port
    @test settings.ssl_enabled == ssl_enabled
    @test settings.open_client == open_client
    @test settings.open_documentation == open_documentation

    server_host = "testenv3"
    server_port = 8080
    open_client = true
    open_documentation = true
    settings = Settings()
    settings2 = load_settings(
        settings,
        joinpath(DIR, FILE3),
        server_port = server_port,
        open_client = open_client,
    )
    @test typeof(settings2) == Settings
    @test settings2 == settings
    @test settings.server_host == server_host
    @test settings.server_port == server_port
    @test settings.ssl_enabled == SSL_ENABLED_DEFAULT
    @test settings.open_client == open_client
    @test settings.open_documentation == open_documentation

    server_port = nothing
    settings = Settings()
    settings2 = load_settings(
        settings,
        joinpath(DIR, FILE4),
        server_port = server_port,
        open_client = open_client,
    )
    @test typeof(settings2) == Settings
    @test settings2 == settings
    @test settings.server_port == server_port

    settings = Settings()
    settings2 = reset_settings(settings)
    @test typeof(settings2) == Settings
    @test settings2 == settings
    @test settings.server_host == SERVER_HOST_DEFAULT
    @test settings.server_port == SERVER_PORT_DEFAULT
    @test settings.ssl_enabled == SSL_ENABLED_DEFAULT
    @test settings.open_client == OPEN_CLIENT_DEFAULT
    @test settings.open_documentation == OPEN_DOCUMENTATION_DEFAULT
end
