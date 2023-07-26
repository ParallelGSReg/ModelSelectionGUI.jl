# Usage

There are multiple ways to use the package, depending on your specific requirements and environment. This section outlines the various options available.

## Index

```@contents
Pages = ["usage.md"]
```


## Using Julia REPL

This is the simplest way to run the package, however it is the one that requires the most interaction.

### Prerequisites

Before getting started, make sure you have the following prerequisites installed on your machine:

- `julia >= 1.6.1`

### Run the service
```julia
using ModelSelectionGUI
load_envvars(".env") # optional
start()
```


## Using `bin/server` command

Using the bin/server command is a convenient way to run the package as a server directly from your command line interface. However, it is necessary to download the source code of the package from the repository.

### Prerequisites
Before getting started, make sure you have the following prerequisites installed on your machine:

- `julia >= 1.6.1`
- [git](https://git-scm.com/downloads): Optional for Option 3.

### Download the source code

#### Option 1: Microsoft Windows
```shell
$ Invoke-WebRequest -Uri "https://github.com/ParallelGSReg/ModelSelectionGUI.jl/archive/refs/heads/main.zip" -OutFile "ModelSelectionGUI.jl-main.zip"
$ Compress-Archive -LiteralPath 'ModelSelectionGUI.jl-main.zip' -DestinationPath 'ModelSelectionGUI.jl-main'
$ cd ModelSelection.jl-main
```

#### Option 2: GNU/Linux
```shell
$ wget --no-check-certificate --content-disposition https://github.com/ParallelGSReg/ModelSelectionGUI.jl/archive/refs/heads/main.zip
$ unzip ModelSelectionGUI.jl-main.zip
$ cd ModelSelection.jl-main
```

#### Option 3: Using Git

```shell
$ git clone https://github.com/ParallelGSReg/ModelSelectionGUI.jl.git
$ cd ModelSelection.jl 
```

### Run the service

Once you have the source files, you can use the command to start the application.

1. Open a terminal or command prompt.

2. Navigate to the directory where the source code is located.

3. Run the following command to start the application:

#### Option 1: Microsoft Windows

```shell
$ bin/server.bat
```

#### Option 2: GNU/Linux

```shell
$ bin/server
```

#### Option 3: macOS

```shell
$ bin/server
```


## Using Docker
Docker allows you to use the package in a container, ensuring consistency and portability across different environments without the need to install Julia or any dependencies on your local machine.

!!! warning
    In this method, the `open_client` and `open_documentation` options for opening windows at startup are disabled. So you must enter those pages through the browser.

### Prerequisites

Before getting started, make sure you have the following prerequisites installed on your machine:

- [Docker](https://www.docker.com/get-started): Ensure Docker is installed and running.

### Run the service

```shell
docker run -d -p <host-port>:8000 --name <container-name> ghcr.io/parallelgsreg/modelselectiongui.jl:latest
```
!!! note
    Replace `<host-port>` with the port on your host machine where you want to access the application, `<container-name>` with a name for your container (e.g., `model-selection-gui-container`).

Once the container is running, you should be able to access your backend application by visiting `http://localhost:<host-port>` in your web browser.

## Using Docker Compose

Docker Compose is a tool for running multi-container Docker applications. With Docker Compose, you can simplify the execution of the application without the need to install Julia or any dependencies on your local machine with only one simple command.

!!! warning
    In this method, the `open_client` and `open_documentation` options for opening windows at startup are disabled. So you must enter those pages through the browser.

### Prerequisites

Before getting started, make sure you have the following prerequisites installed on your machine:

- [Docker](https://www.docker.com/get-started): Ensure Docker is installed and running.
- [Docker Compose](https://docs.docker.com/compose/install/): Install Docker Compose according to your operating system.

### Setup

- Download the `docker-compose.yaml` file from the package repository: [compose.yaml](https://raw.githubusercontent.com/ParallelGSReg/ModelSelectionGUI.jl/main/compose.yaml)

- Or create the file using the following structure:
```yaml
version: '3'

services:
    modelselectiongui:
        image: ghcr.io/parallelgsreg/modelselectiongui.jl:latest
        ports:
            - 8000:8000
```

!!! note
    Replace `<host-port>` with the port on your host machine where you want to access the application.

    ```
    version: '3'
        ...
            ports:
                - <host-port>:8000
    ```

### 2. Run the application

Once you have the Docker Compose file, you can use the `docker-compose up` command to start the application.

1. Open a terminal or command prompt.

2. Navigate to the directory where the `compose.yml` file is located.

3. Run the following command to start the application:

```shell
docker-compose up
```
