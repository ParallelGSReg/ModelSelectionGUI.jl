# Configuration

## Environment variables

The package supports the following environment variables for configuration:

| Name | Default | Description |
|------|---------|-------------|
|`SERVER_PORT` | `8000`| The port number on which the web server will listen|
|`CLIENT_PORT`|`SERVER_PORT + 1`| The port number on which the client will listen|
|`OPEN_BROWSER`|`false`| Open the web browser after starting the server with the documentation|
|`OPEN_CLIENT`|`false`| Open the web browser after starting the server with the client|
|`SERVER_URL`|`127.0.0.1`| Defines the base URL of the server|

!!! note
    You can choose to set these environment variables based on your specific requirements. If not set, the package will use the default values mentioned above.

### Setting variables

To set environment variables, you can create a .env file in the root directory of your project. 

!!! tip
    You can copy the .env.template file as a starting point. Then, modify the values in the .env file according to your desired configuration.

To set an environment variable, you sould use the following syntax:

```plaintext
# .env file
export VARIABLE_NAME=value
```

For example, to set the `SERVER_PORT` environment variable to 9000, you can use:

```plaintext
export SERVER_PORT=9000
```

## Load custom dotenv file
The dotenv file will `.env` as default. If a custom file is needed, you can use the command in the Julia REPL:
```julia
start(dotenv=".mycustomenv")

# or

load_dotenv(".mycustomenv")
start()
```
!!! note
    Please note that modifying environment variables may require restarting the web server for the changes to take effect.
