"""
    bad_request_exception(message)

Creates an HTTP response with a 400 (Bad Request) status code.

# Parameters
- `message::String`: The message to be sent in the HTTP response.

# Returns
- `HTTP.Response`: An HTTP response with a status code of 400 and the provided message.

# Example
```julia
bad_request_exception("Invalid request parameters.")
```
"""
function bad_request_exception(message)
    html(message, status = 400)
end
