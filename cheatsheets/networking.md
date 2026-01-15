# Networking

## Interfaces

````markdown
ip a
````

Show network interfaces and their IP addresses.

```bash
ip link show
```

Show link-level information (e.g., MAC address, state).

## Routing

```bash
ip route
```

Display the routing table.

## Listening ports

```bash
ss -tulnp
```

Show TCP/UDP listening ports with associated PIDs.

```bash
netstat -tulnp
```

Legacy equivalent of `ss` for showing listening ports.

## Connections

```bash
ss -tan
```

Display active TCP connections.

## DNS

```bash
dig example.com
```

DNS lookup for `example.com`.

```bash
nslookup example.com
```

Legacy DNS lookup for `example.com`.

## Traffic capture

```bash
tcpdump -i eth0
```

Capture traffic on the `eth0` interface.

```bash
tcpdump -i eth0 port 80
```

Capture traffic on the `eth0` interface filtered by port `80`.

```bash
tcpdump -nn
```

Disable name resolution in packet capture (shows numeric addresses).

## Connectivity

```bash
ping host
```

ICMP reachability test to the specified `host`.

```bash
curl http://host
```

Send an HTTP request to `host` and display the response.

```bash
wget url
```

Download a file from the given `url`.
