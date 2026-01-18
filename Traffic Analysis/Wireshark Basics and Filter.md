# Creating and Troubleshooting Filter Configurations

Analyzing raw network traffic can be overwhelming without filtering. Filters are essential for isolating relevant traffic and streamlining analysis.  

### Filter Types

| Filter Type       | Purpose                                                   | When to Use                                         | Syntax / Application |
|------------------|-----------------------------------------------------------|---------------------------------------------------|--------------------|
| **Capture filters** | Select which packets are captured before saving.       | High-traffic networks, long captures, known traffic. | BPF-like syntax, applied before capture starts. |
| **Display filters** | Show/hide packets from a captured file or live stream. | Post-capture analysis, complex or protocol-specific filtering. | Tool-specific syntax, applied on active or saved captures. |

> **Key difference:** Capture filters prevent packets from being saved; display filters hide packets from view but cannot recover packets not captured.

---

### Creating Capture Filters

1. Locate the **capture filter input** in your tool’s capture options.  
2. Common BPF-like examples:  
   - By host: `host 192.168.1.10`  
   - By network: `net 192.168.1.0/24`  
   - By port: `port 80`  
   - By direction: `src host 192.168.1.10` or `dst port 443`  
   - By protocol: `tcp`, `udp`, `icmp`  
3. Logical operators:  
   - `and` / `&&` → both conditions must be true  
   - `or` / `||` → either condition true  
   - `not` / `!` → negates a condition  
   - Parentheses `()` for grouping: `host 192.168.1.10 and (port 80 or port 443)`  
4. Save frequently used filters for reuse.  

---

### Creating Display Filters

1. Enter your filter in the **display filter bar** and apply (press Enter).  
2. Common syntax examples:  
   - IP: `ip.addr == 192.168.1.10`  
   - Source/Destination: `ip.src == 192.168.1.10`, `ip.dst == 192.168.1.10`  
   - TCP/UDP port: `tcp.port == 80`, `udp.port == 53`  
   - Protocol: `http`, `dns`  
   - Specific fields: `http.request.method == "GET"`  
   - TCP flags: `tcp.flags.syn == 1 and tcp.flags.ack == 0`  
   - Text search: `frame contains "error"`  
3. Comparison operators: `==`, `!=`, `>`, `<`, `>=`, `<=`, `contains`, `matches` (regex).  
4. Logical operators: `and`, `or`, `not` with parentheses for grouping.  
5. Use **Filter Builder/Expression tools** to discover fields and build expressions.  
6. Save frequently used filters for convenience.  

---

### Troubleshooting Filters

- **Syntax errors:**  
  - Using the wrong syntax for capture vs display filters  
  - Missing quotes around string values  
  - Invalid operators for the filter type  
- **Logic errors:**  
  - Too few packets: remove conditions or use `or` to broaden scope  
  - Too many packets: add conditions using `and` to narrow scope  
  - Check capitalization for case-sensitive fields  
  - Verify source vs destination selection  
- **No packets captured:**  
  - Wrong network interface  
  - Promiscuous mode not enabled  
  - Permissions issues  
  - Traffic not present during capture  

---

### Tips for Effective Filtering

- Start broad, then narrow down filters iteratively.  
- Know common protocols and ports.  
- Consult tool documentation.  
- Save useful filters for repeated use.  

---

## Advanced Wireshark Display Filters

Wireshark allows detailed packet inspection using **advanced display filter techniques**.

| Technique | Use Case | Example |
|-----------|---------|---------|
| Filter by protocol field | Examine specific protocol details | `http.request.method == "POST"` |
| Numeric comparisons | Analyze sequence numbers or packet sizes | `tcp.seq == 100` |
| String comparisons | Track URLs, hostnames, or payload text | `http.host contains "example.com"` |
| Boolean flags | Analyze TCP connection states | `tcp.flags.syn == 1 and tcp.flags.ack == 0` |
| `contains` operator | Find substrings in fields | `frame.contains "error"` |
| `matches` operator | Regex pattern matching | `http.user_agent matches "Mozilla\/5\.0.*Firefox\/.*"` |
| Combining logical operators | Complex filtering | `(ip.src == 192.168.1.10 and tcp.port == 80) or dns` |
| Protocol or frame length | Filter by size or type | `ip.len > 1500` |
| Expert info | Show warnings/errors | `expert.severity == "Error"` |

---

## Summary

- **Capture filters**: Reduce data at the source; applied before capture.  
- **Display filters**: Refine what you see; applied after capture without changing raw data.  
- Syntax matters—mixing capture and display filter syntax causes errors.  
- Start broad, then refine; use logical and comparison operators carefully.  
- Advanced operators (`contains`, `matches`, and logical combinations) provide precise filtering for effective network analysis.  
