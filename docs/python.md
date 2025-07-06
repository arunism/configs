# Python Utilities

## Share document over local network

- To share files over same local network but with other devices, you first need to find the server's ip with (`ifconfig`). This will display your server's ip in the order `192.168.**.**`. Now you can establish the connection over shared network using the same ip address and before that start the server using following command:

```shell
python3 -m http.server 8080 --bind 0.0.0.0
```
