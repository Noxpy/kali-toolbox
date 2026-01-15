# Permissions & Ownership
## Permission model

````markdown
- `u` = user (owner)  
- `g` = group  
- `o` = others  

- `r` = read (4)  
- `w` = write (2)  
- `x` = execute (1)
````
## View permissions
```bash
ls -l
````

View detailed file and directory permissions.

```bash
stat filename
```

View detailed file metadata, including permissions.

## Symbolic `chmod`

```bash
chmod u+x script.sh
```

Add execute permission to the owner (user) of `script.sh`.

```bash
chmod go-r secret.txt
```

Remove read permission from group and others for `secret.txt`.

```bash
chmod a-x file
```

Remove execute permission from all users (owner, group, others) for `file`.

## Numeric (octal) `chmod`

```bash
chmod 644 file.txt   # rw-r--r--
```

Set read and write permission for the owner, and read-only for group and others.

```bash
chmod 755 script.sh  # rwxr-xr-x
```

Set read, write, and execute permissions for the owner, and read and execute for group and others.

```bash
chmod 700 private/
```

Set read, write, and execute permissions for the owner, and no permissions for group and others.

## Ownership

```bash
chown user file
```

Change ownership of `file` to `user`.

```bash
chown user:group file
```

Change ownership of `file` to `user` and the group to `group`.

```bash
chown -R user:group directory/
```

Recursively change ownership of all files and subdirectories in `directory/` to `user` and group to `group`.

## Directories (important)

* `r` = list contents
* `w` = create/delete files
* `x` = enter directory (cd)

Without `x`, you cannot access files in the directory, even if `r` is set.

## `umask`

```bash
umask
```

Show the current default permission mask.

```bash
umask 022
```

Set the default permission mask. This results in files having permissions `644` (rw-r--r--) and directories `755` (rwxr-xr-x).

## Recursive changes

```bash
chmod -R g+w shared/
```

Recursively add write permissions to the group for all files and subdirectories in the `shared/` directory.
