# Configuration

## Settings

The application uses a `Settings` object in order to set the settings of the application. By default, the `Settings` object is created with the default values.

The package has the following settings:

| Name | Default | Description |
|------|---------|-------------|
|`server_host`|`127.0.0.1`| Server host URL for the application|
|`server_port` | `8000`| The port number on which the web server will listen|
|`ssl_enabled`|`false`| Indicates whether SSL is enabled|
|`open_client`|`false`| Determines whether the client window should be opened at startup|
|`open_documentation`|`false`| Determines whether the documentation window should be opened at startup|

!!! note
    You can choose to set these environment variables based on your specific requirements. If not set, the package will use the default values mentioned above.

### Set custom settings
In order to set custom settings, you must create a settings object and fill the desired data:

```julia
settings = Settings()
load_settings(server_host="localhost")
settings.open_client = true
app = App(settings)
```

### Environment variables
The package supports environment variables for configuration.

#### Setting variables

To set environment variables, you can create a .env file in the root directory of your project. 

!!! tip
    You can copy the .env.template file as a starting point. Then, modify the values in the .env file according to your desired configuration.

To set an environment variable, you should use the following syntax:

```plaintext
# .env file
export VARIABLE_NAME=value
```

For example, to set the `SERVER_PORT` environment variable to 9000, you can use:

```plaintext
export SERVER_PORT=9000
```

#### Load dotenv file
To load a dotenv file you should use the following command:
```julia
settings = Settings()
load_settings(settings, ".mycustomenv")
```
!!! note
    Please note that modifying environment variables may require restarting the web server for the changes to take effect.
