# Searching & Discovery

## `find` — name-based search

````markdown
find . -name "file.txt"
````

Case-sensitive search for `file.txt` starting from the current directory.

```bash
find . -iname "*scan*"
```

Case-insensitive partial match for files containing "scan" in their names.

## System-wide search

```bash
sudo find / -iname "*nessus*" 2>/dev/null
```

Search the entire system for files with "nessus" in their names, suppressing permission errors.

## By type

```bash
find . -type f
```

Find regular files (not directories or other types).

```bash
find . -type d
```

Find directories.

```bash
find . -type f -executable
```

Find executable files.

## By time

```bash
find . -mtime -7
```

Find files modified within the last 7 days.

```bash
find . -ctime -1
```

Find files with metadata changed in the last day.

## By size

```bash
find . -size +100M
```

Find files larger than 100 MB.

```bash
find . -size -1k
```

Find files smaller than 1 KB.

## Content search

```bash
grep -R "password" .
```

Recursive search for the word "password" within files starting from the current directory.

```bash
grep -Ri "nessus" /
```

Recursive, case-insensitive search for "nessus" in the entire filesystem.

```bash
grep -Il "string" *
```

List only filenames containing the string "string", skipping binary files.

## Combining actions

```bash
find . -iname "*.log" -delete
```

Delete all `.log` files matched by the search.

```bash
find . -type f -exec sha256sum {} +
```

Calculate and display the SHA-256 hash of all matched files.
