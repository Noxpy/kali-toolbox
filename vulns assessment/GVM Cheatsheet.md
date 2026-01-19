# OpenVAS (Greenbone Vulnerability Management) Setup and Configuration Cheat Sheet

This cheat sheet provides a quick reference for security professionals and system administrators to install, configure, and operate OpenVAS (Greenbone Vulnerability Management). It covers essential commands, configurations, troubleshooting steps, and best practices for conducting vulnerability scans on your network and systems.

## Table of Contents
- [System Setup and Service Management](#system-setup-and-service-management)
- [Web Interface Access (GSA)](#web-interface-access-gsa)
- [Creating Targets and Scan Tasks](#creating-targets-and-scan-tasks)
- [Adding Credentials for Authenticated Scans](#adding-credentials-for-authenticated-scans)
- [Viewing and Exporting Reports](#viewing-and-exporting-reports)
- [Common Errors and Fixes](#common-errors-and-fixes)
- [Tips for Success](#tips-for-success)

---

## System Setup and Service Management

### Install OpenVAS on Debian-based Systems

```bash
sudo apt update && sudo apt install openvas -y
````

### Initialize GVM Services

```bash
sudo gvm-setup
```

* Initializes OpenVAS services, generates certificates, and downloads the initial feeds.

### Start OpenVAS Daemons

```bash
sudo gvm-start
```

* Starts OpenVAS-related services (`gvmd`, `gsad`, `openvas-scanner`).

### Verify Setup

```bash
sudo gvm-check-setup
```

* Verifies setup status, including feed status and service health.

### Manually Sync NVTs (Vulnerability Tests)

```bash
sudo greenbone-nvt-sync
```

### Check Greenbone Manager Daemon Logs

```bash
sudo journalctl -u gvmd
```

---

## Web Interface Access (GSA)

OpenVAS's web interface is accessed via the following URL:

* **URL**: [https://127.0.0.1:9392](https://127.0.0.1:9392)

  * Default web access to the Greenbone UI.

---

## Creating Targets and Scan Tasks

### Creating a Target in GSA

1. Navigate to **Configuration → Targets**
2. Click **Create Target**
3. Fill in the following details:

   * **Name**: For example, `Internal Web Server`
   * **Hosts**: For example, `192.168.56.101`
   * **Alive Test**: ICMP/TCP/ARP
   * **Port List**: OpenVAS Default
4. Click **Save**

### Creating a Scan Task

1. Go to **Scans → Tasks**
2. Click **Create Task**
3. Configure:

   * **Target**: Choose a previously created target
   * **Scan Config**: Select `Full and fast`
4. Start the task manually or schedule it.

---

## Adding Credentials for Authenticated Scans

1. Navigate to **Configuration → Credentials**
2. Click **Create Credential**
3. Choose:

   * **Type**: SSH Password or SMB
   * **Username** and **Password**
4. Save and assign the credentials to a target in **Target Configuration**.

---

## Viewing and Exporting Reports

### View Completed Scans

* Go to **Scans → Reports** to view completed scans and filter by severity.

### Export Options

* Available export formats: **PDF**, **XML**, **HTML**, **TXT**.

### Severity Scale

* **Low (0–3.9)**: Minor vulnerabilities
* **Medium (4–6.9)**: Moderate vulnerabilities
* **High (7–8.9)**: Significant vulnerabilities
* **Critical (9–10)**: Critical vulnerabilities

---

## Common Errors and Fixes

| Error                             | Cause                                            | Fix                                        |
| --------------------------------- | ------------------------------------------------ | ------------------------------------------ |
| **No NVTs found**                 | Feed not synced                                  | Run `greenbone-nvt-sync`, restart services |
| **503 Service Unavailable (GSA)** | `gvmd` not running or DB connection failed       | Restart `gvmd`, verify PostgreSQL          |
| **Scan stuck at 0%**              | Incorrect target IP or firewall blocking traffic | Verify network, update port lists          |

---

## Tips for Success

* **Always sync feeds** before scanning new targets to ensure up-to-date vulnerability tests.
* **Use credentialed scans** for deeper vulnerability discovery and more accurate results.
* **Schedule scans** during off-peak hours to avoid network slowdowns and reduce performance impact.
* **Use tags** to group hosts by environment (e.g., DEV, PRO) for easier management and reporting.

---

## Troubleshooting and Further Assistance

For more detailed information or advanced configurations, refer to the official OpenVAS documentation or community resources.
