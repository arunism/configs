# One Line Commands

## Remote Connection

### Using `.pem` file

- To connect to remote server using `.pem` file, you need to make sure that `.pem` file has proper permissions (`chmod 400 <path-to-your-pem-file>`) and then you can establish the connection using following command:

```shell
ssh -i "<path-to-your-pem-file>" <your-username>@<your-server-ip-address>
```

### Using your `rsa` key:

- To connect to remote server using `rsa` key you need to make sure you have it generated on your device (`ssh-keygen -t rsa -b 4096 -C "<your-email>"`) and then follow the given command:

```
ssh -i ~/.ssh/id_rsa <your-username>@<your-server-ip-address>
```

### Download file/folder from remote server

The only difference between downloading a `file` and a `folder` is the user of argument `-r`, which means (recursive). If you want to download an entire directory, you need to user the argument `-r` else its not necessary.

```shell
scp -i <path-to-your-pem-file> -r <your-username>@<your-server-ip-address>:<path-to-your-folder-in-remote-server> <path-to-destination-folder-in-local-machine>
```

### Upload file/folder to remote server

The only difference between uploading a `file` and a `folder` is the user of argument `-r`, which means (recursive). If you want to download an entire directory, you need to user the argument `-r` else its not necessary.

```shell
scp -i <path-to-your-pem-file> -r <path-to-destination-folder-in-local-machine> <your-username>@<your-server-ip-address>:<path-to-your-folder-in-remote-server>
```


## Miscellaneous

### Share your content withing local network

- To share your `directory` content, over the local network with high speed follow the given command:
    ```shell
    cd <path-to-your-directory> && python3 -m http.server <port>
    ```

### Download files from google drive

- To download a file from `google drive`, install gdown using `pip install gdown` and then follow the command below:
    ```shell
    gdown https://drive.google.com/uc?id=<FILE-ID> -O <path-to-your-file>
    ```
