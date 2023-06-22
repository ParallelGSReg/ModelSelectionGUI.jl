# GUI module

The `GUI` module provides functions to handle GUI operations, such as displaying the interface or documentation pages through windows.

## Contents

```@contents
Pages = ["GUI.md"]
```

## Index

```@index
Pages = ["GUI.md"]
```

## How to use
```julia
settings = Settings() # Optional

application = ApplicationGUI(settings)

initialize_application(application)

# Opens a new window named :docs
open_url(application, :docs, "http://localhost:8000/docs")

# Closes the windows :docs
close_window(application, :docs)

close_application(application) # Closes the application
```

## Types
```@docs
ApplicationGUI
```

## Functions
```@docs
open_path(application::ApplicationGUI, name::Symbol, path::String = DEFAULT_PATH)
open_url(application::ApplicationGUI, name::Symbol, url::Union{String,Nothing} = nothing)
initialize_application(application::ApplicationGUI)
close_application(application::ApplicationGUI)
create_window(application::ApplicationGUI, name::Symbol, url::Union{String,Nothing} = nothing)
update_window(application::ApplicationGUI, name::Symbol, url::Union{String,Nothing} = nothing)
close_window(application::ApplicationGUI, name::Symbol)
close_all_windows(application::ApplicationGUI)
```

## Internals

### Functions
```@docs
GUI.get_window(application::ApplicationGUI, name::Symbol)
```

### Constants
```@docs
GUI.DEFAULT_PATH
```

### Strings
```@docs
GUI.SETTINGS_NOT_DEFINED_EXCEPTION
```
