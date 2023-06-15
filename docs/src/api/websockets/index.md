# Websockets

It is possible to have a continuous status on the execution of a job using web sockets.

## How to stablish a connection

- URL: `ws://localhost:8080` (please change the port for the one that is in your configuration)
- Channel: `sync`

Example connection in JS:
```javascript
const ws = new WebSocket("ws://localhost:8000");
const msg = {
    channel: "sync",
    message: "subscribe",
    payload: {},
};
ws.send(JSON.stringify(msg));
```

## Receive information

The server will be sending information about the current job in a JSON message that contains the following structure:
    - `id`: The unique identifier (UUID) of the model selection job.
    - `message`: The content or description of the message.
    - `data`: Additional data associated with the message.

Example JSON message:
```json
{
    "id": "adbc7420-1597-4b1b-a798-fafd9ee5f671",
    "message": "Running regressions",
    "data": {
        "progress": 20,
        "total": 100
    }
}
```

Example of how tho receive the messages from the server:
```javascript
ws.onmessage = (event) => {
  console.log(event.data);
}
```
