# Adding Users and Passwords

## Adding a user

````markdown
sudo useradd username
````

Add a new user with the specified `username`.

```bash
sudo useradd -m username
```

Create a new user and also create the user's home directory (`-m` option).

```bash
sudo useradd -m -s /bin/bash username
```

Create a new user with a home directory and set `/bin/bash` as the default shell.

## Setting a user password

```bash
sudo passwd username
```

Set or change the password for the user `username`.

```bash
sudo passwd -l username
```

Lock the password for the user `username` (disables login via password).

```bash
sudo passwd -u username
```

Unlock the password for the user `username` (enables login via password again).

## Changing user information

```bash
sudo usermod -c "Full Name" username
```

Change the comment (e.g., full name) for the user `username`.

```bash
sudo usermod -aG groupname username
```

Add the user `username` to the supplementary group `groupname`.

## Deleting a user

```bash
sudo userdel username
```

Delete the user `username` (removes the user but keeps the home directory).

```bash
sudo userdel -r username
```

Delete the user `username` and their home directory.

## Changing user ID (UID) or group ID (GID)

```bash
sudo usermod -u 1001 username
```

Change the UID of the user `username` to `1001`.

```bash
sudo groupmod -g 1001 groupname
```

Change the GID of the group `groupname` to `1001`.

