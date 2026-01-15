Here’s your content formatted cleanly for a `README.md` file using proper Markdown syntax with code blocks and headings:
# Filesystem & Navigation

```
pwd
```

Print absolute path of current working directory.

## Listing

```bash
ls
```

List directory contents.

```bash
ls -lah
```

Long list, human-readable sizes, include hidden files.

```bash
ls -lt
```

Sort by modified time (newest first).

```bash
ls -lS
```

Sort by size (largest first).

## Globbing (shell wildcards)

* `*` any characters
* `?` single character
* `[]` character set

```bash
ls /bin/b*
ls /etc/*.conf
ls /bin/*r
```

## Tree view

```bash
tree
```

Display directories as a tree (may require installation).

```bash
tree -L 2
```

Limit depth to 2 levels.

## Disk usage

```bash
du -sh *
```

Size of items in current directory.

```bash
df -h
```

Filesystem usage summary.

## File types

```bash
file filename
```

Identify file type.

```bash
stat filename
```

Detailed file metadata.
