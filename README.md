# ModelSelectionGUI

[![][documentation-main-img]][documentation-main-url] [![][build-main-img]][test-main-url] [![][test-main-img]][test-main-url] [![][codecov-img]][codecov-url]

The ModelSelectionGUI is a web server package designed to provide a user-friendly interface for utilizing the ModelSelection package. It consists of a backend and an optional frontend that offers a graphical user interface (GUI) for seamless interaction with the underlying [ModelSelection](https://github.com/ParallelGSReg/ModelSelectionGUI.jl) functionality.

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

If the web client is enabled open your web browser and enter the following URL: [http://127.0.0.1:8000](http://127.0.0.1:8000).

## Documentation

For more detailed information about this package, its functionalities, and usage instructions, please refer to our [documentation page](https://parallelgsreg.github.io/ModelSelectionGUI.jl).

## ModelSelection package
ModelSelectionGUI package functions as an interface with ModelSelection.jl. For more details about the functionalities and features provided by ModelSelection, please visit the [package repository](https://github.com/ParallelGSReg/ModelSelection.jl).

## Contributing

Contributions are welcome! If you encounter any issues or have suggestions for improvements, please open an issue or submit a pull request on the repository. Make sure to follow the guidelines outlined in the [CONTRIBUTING.md](CONTRIBUTING.md) file.

## TODO List

For an overview of pending tasks, improvements, and future plans for the ModelSelectionGUI package, please refer to the [TODO.md](TODO.md) file.

## License

This package is licensed under the [MIT License](LICENSE).


[build-main-img]: https://github.com/ParallelGSReg/ModelSelectionGUI.jl/actions/workflows/build.yaml/badge.svg?branch=main
[build-main-url]: https://github.com/ParallelGSReg/ModelSelectionGUI.jl/actions/workflows/build.yaml

[test-main-img]: https://github.com/ParallelGSReg/ModelSelectionGUI.jl/actions/workflows/test.yaml/badge.svg?branch=main
[test-main-url]: https://github.com/ParallelGSReg/ModelSelectionGUI.jl/actions/workflows/test.yaml

[codecov-img]: https://codecov.io/gh/ParallelGSReg/ModelSelectionGUI.jl/branch/main/graph/badge.svg
[codecov-url]: https://codecov.io/gh/ParallelGSReg/ModelSelectionGUI.jl

[documentation-main-img]: https://github.com/ParallelGSReg/ModelSelectionGUI.jl/actions/workflows/docs.yaml/badge.svg
[documentation-main-url]: https://parallelgsreg.github.io/ModelSelectionGUI.jl
