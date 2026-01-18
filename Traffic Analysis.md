# Guide to Packet Headers

---

## Introduction

Data travels across a network in **packets**, small units that contain both the actual data (**payload**) and a **header** with essential control information. Packet headers ensure proper routing, delivery, and processing at the destination.

This guide focuses on IPv4, IPv6, and UDP headers, highlighting key fields critical for network communication and packet analysis.

---

## IPv4 Packet Header

| Field | Size | Description |
|-------|------|-------------|
| Version | 4 bits | Indicates IPv4 (always 4). |
| Header Length (IHL) | 4 bits | Shows the length of the IP header (in 32-bit words). |
| Type of Service (ToS) | 8 bits | Informs routers about packet priority (QoS). |
| Total Length | 16 bits | Total size of the packet (header + data) in bytes. |
| Identification | 16 bits | Helps reassemble fragments of a split packet. |
| IP Flags | 3 bits | Fragmentation control: Reserved, Don't Fragment (DF), More Fragments (MF). |
| Fragment Offset | 13 bits | Position of this fragment in the original packet (8-byte units). |
| Time to Live (TTL) | 8 bits | Prevents infinite loops by decrementing at each router. |
| Protocol | 8 bits | Indicates the transport protocol (e.g., TCP=6, UDP=17). |
| Header Checksum | 16 bits | Error-checking for the header. |
| Source Address | 32 bits | IP address of the sender. |
| Destination Address | 32 bits | IP address of the receiver. |
| IP Options | Variable | Optional instructions; increases IHL if present. |

---

## IPv6 Packet Header

| Field | Size | Description |
|-------|------|-------------|
| Version | 4 bits | Always 6 for IPv6. |
| Traffic Class | 8 bits | Similar to ToS in IPv4; used for QoS. |
| Flow Label | 20 bits | Marks packet sequences requiring special handling. |
| Payload Length | 16 bits | Size of the data carried, excluding the 40-byte IPv6 header. |
| Next Header | 8 bits | Indicates the type of header following IPv6 (TCP, UDP, or extension). |
| Hop Limit | 8 bits | Same as TTL; decremented by each router. |
| Source Address | 128 bits | IPv6 address of the sender. |
| Destination Address | 128 bits | IPv6 address of the receiver. |

---

## UDP Header

| Field | Size | Description |
|-------|------|-------------|
| Source Port | 16 bits | Application or process on the sending device. |
| Destination Port | 16 bits | Target application or process on the receiver. |
| Length | 16 bits | Total length of UDP datagram (header + data). Minimum 8 bytes. |
| Checksum | 16 bits | Error-checking for UDP header and data. Optional in IPv4, mandatory in IPv6. |

> **Note:** Unlike TCP, UDP is connectionless and does not guarantee delivery, making it ideal for speed-prioritized applications like DNS or video streaming.

---

## Summary

- Every network packet has a **header** that ensures proper routing and delivery.  
- IPv4 headers include fields like **version, header length, TTL, and protocol type**, plus fragmentation support.  
- IPv6 simplifies header processing with a fixed-length header, replacing some IPv4 fields with **traffic class** and **flow label**.  
- UDP headers specify **source/destination ports** and include a **checksum** for error detection.  
- Understanding these headers is essential for network analysis, troubleshooting, and security investigations.
