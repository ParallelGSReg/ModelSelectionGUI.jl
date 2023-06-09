# ModelSelectionGUI

The ModelSelectionGUI is a web server package designed to provide a user-friendly interface for utilizing the ModelSelection package. It consists of a backend and an optional frontend that offers a graphical user interface (GUI) for seamless interaction with the underlying ModelSelection functionality.

## Features

- Web server backend: The package includes a web server backend that handles requests and responses between the user and the **ModelSelection** package.
- Graphical User Interface (GUI): The optional frontend provides a GUI that allows users to interact with the **ModelSelection** package using a visual interface, making it easier to explore and utilize the various functionalities.
- Easy Integration: The **ModelSelectionGUI** is designed to seamlessly integrate with the **ModelSelection** package, providing a user-friendly interface to access and utilize its capabilities without requiring in-depth knowledge of the underlying Julia code.

## Installation

You can install the package by running the following command in the Julia REPL:

```julia
using Pkg
Pkg.add("ModelSelectionGUI")
```

## Usage

To start the web server and access the GUI, follow these steps:

```julia
using ModelSelectionGUI
start()
```

If the web client is enabled open your web browser and enter the following URL: (http://localhost:8000
)[http://localhost:8000] (please change the port for the one that is in your configuration)

## Environment variables

The Package Name package supports the following environment variables for configuration:

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

Please note that modifying environment variables may require restarting the web server for the changes to take effect.

## API Documentation

The endpoints are the core communication to interact with the backend services. You can read the guide for a complete understanding of how to interact with our backend services in [this documentation](docs/endpoints.md).

It is also possible to have a continuous status on the execution of a job using web sockets. You can read the guide for a complete understanding of how to interact with our web sockets in [this documentation](docs/websockets.md).

The package provides a comprehensive API documentation powered by Swagger. You can access the API documentation by visiting the `/docs` URL of your deployed application. This documentation offers a detailed overview of all available endpoints, request/response examples, and parameter details.

### Accessing the Swagger Documentation

To access the Swagger documentation for the **ModelSelectionGUI** package, follow these steps:

1. Start the server and ensure it is running.
2. Open a web browser.
3. In the address bar, enter the URL of your deployed application followed by `/docs`. For example: `http://127.0.0.1/docs`.
4. The Swagger documentation page will load, displaying all the available endpoints, their descriptions, and other relevant information.

### Using Swagger for Testing and Exploration

The Swagger documentation not only serves as a reference for the endpoints but also provides an interactive environment for testing and exploring the API. With Swagger UI, you can easily send requests to different endpoints, view their responses, and experiment with various parameters.

Feel free to leverage the Swagger documentation to understand the functionality of the **ModelSelectionGUI** package, explore different endpoints, and test API requests right from your browser.

## Contributing

Contributions are welcome! If you encounter any issues or have suggestions for improvements, please open an issue or submit a pull request on the repository. Make sure to follow the guidelines outlined in the [CONTRIBUTING.md](CONTRIBUTING.md) file.

## TODO List

For an overview of pending tasks, improvements, and future plans for the Package Name package, please refer to the [TODO.md](TODO.md) file.

## License

This package is licensed under the [MIT License](LICENSE). Include information about the license under which your package is released.
