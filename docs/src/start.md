# Getting started

This basic example demonstrates how to use the package in its simplest way. However, for a more in-depth understanding of the various options and features, please navigate to the [Usage section](usage.md) where all available functionalities and usage scenarios are thoroughly explained.

## Installation

ModelSelectionGUI can be installed using the Julia package manager. From the Julia REPL, type ] to enter the Pkg REPL mode and run

```
pkg> add ModelSelectionGUI
```

## Usage

To start the web server and access the GUI, follow these steps:

```julia
using ModelSelectionGUI
start()
```

!!! note
    If the web client is enabled open your web browser and enter the following URL: [http://127.0.0.1:8000](http://127.0.0.1:8000). Please change the host and port for the one that is [in your configuration](configuration.md).
