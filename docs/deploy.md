# Deployment

This is a step by step guideline while deploying a system with complete security and required functionalities.

## SSH Setup

### 1. SSH Key Setup

Create a local ssh key with the following command:

```shell
ssh-keygen
```

This will ask for path of the ssh key and password (if needed). If you need to setup your custom path for key define it, else leave it empty and press `Enter` to proceed with the default one (`id_rsa`). From now one i will denote the ssh key file with the name `id_rsa`, your file may have other names as per your previous setup.

This will create two files:

- `~/.ssh/id_rsa`: Your private ssh key
- `~/.ssh/id_rsa.pub`: Your public ssh key

Once the files are created you need to copy the **entire** content of the file `id_rsa.pub` to your providers configuration.

Now you can connect to your remote server using your terminal, using the following command:

```shell
ssh -i ~/.ssh/id_rsa root@<YOUR-SERVER-IP>
```

### 2. Add New User

Once you connect to your user you can now create a new user using the following command:

```shell
adduser <YOUR-NEW-USERNAME>
```

This will ask for user login `Password`, `Full Name` and Other Details. Password field cannot be skipped, while all other fields are optional.

Now to add the user to sudo group you can follow the below command:

```shell
usermod -aG sudo <YOUR-NEW-USERNAME>
```

Enter the user using the following:

```shell
su - <YOUR-NEW-USERNAME>
```

### 3. Security Setup for SSH
