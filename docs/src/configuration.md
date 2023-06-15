# Configuration

## Environment variables

The package supports the following environment variables for configuration:

- `SERVER_PORT` (optional): The port number on which the web server will listen. Default value is 8000 if not specified.
- `CLIENT_PORT` (optional): The port number for the client to communicate with the server. Default value is `SERVER_PORT + 1` if not specified.
- `OPEN_BROWSER` (optional): A boolean flag indicating whether to automatically open the web browser after starting the server with the documentation. Default value is `false` if not specified.
- `OPEN_CLIENT` (optional): A boolean flag indicating whether to automatically open the web browser after starting the server with the client. Default value is `true` if not specified.
- `SERVER_URL` (optional): The URL of the backend server's API. Default value is `127.0.0.1`.

You can choose to set these environment variables based on your specific requirements. If not set, the package will use the default values mentioned above.

To set these environment variables, you can create a .env file in the root directory of your project. You can copy the .env.template file as a starting point. Then, modify the values in the .env file according to your desired configuration.

To set an environment variable, you can use the following syntax:

```plaintext
export VARIABLE_NAME=value
```

For example, to set the `SERVER_PORT` environment variable to 9000, you can use:

```plaintext
export SERVER_PORT=9000
```

## Load environment variables
The dotenv file will `.env` as default. If a custom file is needed, you can use the command in the Julia REPL:
```julia
start(dotenv=".mycustomenv")

# or

load_dotenv(".mycustomenv")
start()
```

Please note that modifying environment variables may require restarting the web server for the changes to take effect.
