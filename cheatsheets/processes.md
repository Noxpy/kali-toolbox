# Processes & Signals

## Listing processes

````markdown
ps aux
````

Full process list.

```bash
ps -ef
```

Alternative full listing.

```bash
ps -u user
```

Show processes for a specific user.

## Interactive monitoring

```bash
top
```

Real-time process view (default system monitor).

```bash
htop
```

Enhanced version of `top` (if installed), provides more features like easier navigation and a better UI.

## Searching

```bash
pgrep ssh
```

Find process ID by name (`ssh` in this case).

```bash
ps aux | grep nginx
```

Manual search for a process (less precise but useful for custom searches).

## Signals

```bash
kill PID
```

Send `SIGTERM` (graceful stop) to the process with the specified `PID`.

```bash
kill -9 PID
```

Send `SIGKILL` (force stop) to the process with the specified `PID`.

```bash
killall processname
```

Kill all processes by process name.

## Background / foreground

```bash
command &
```

Run `command` in the background.

```bash
jobs
```

List all background jobs.

```bash
fg %1
```

Bring background job `%1` to the foreground.

```bash
bg %1
```

Resume background job `%1` (if it’s stopped).
