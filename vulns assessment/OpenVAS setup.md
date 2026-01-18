# Overview

In this lab, you will install and configure OpenVAS (also known as Greenbone Vulnerability Management or GVM) on a Kali Linux virtual machine. This exercise simulates the kind of setup often used in secure, isolated lab environments to safely run vulnerability scans against internal targets. You'll prepare your system, install OpenVAS, and configure its components.

## Objectives

After completing this lab, you will be able to:

- Install and configure OpenVAS on Kali Linux
- Access the Greenbone Security Assistant (GSA) web interface
- Add scan targets and launch vulnerability scans
- Interpret basic scan results

### Prerequisites

Before setting up OpenVAS in a virtual machine (VM), review the resource on Kali Linux installation, which covers system requirements for running Kali Linux in a VM, best practices for installation, and tips for troubleshooting common issues to help ensure a smooth setup process.

---

## Exercise 1: Install and Configure OpenVAS

### Task A: Update the Kali System

Start by making sure your Kali VM is up to date using the following commands:

```bash
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
````

This might take some time.

**Why this matters:**
Updating ensures compatibility and security before installing any major software components.

### Task B: Install OpenVAS

Use the following command to install OpenVAS and its dependencies:

```bash
sudo apt install gvm
```

**Why this matters:**
OpenVAS is part of the GVM suite. Installing it pulls in the scanner and related components needed for setup.

### Task C: Set Up OpenVAS for First-Time Use

Initialize OpenVAS and download required definitions (this may take several minutes):

```bash
sudo gvm-setup
```

**Error Troubleshooting:**
If you encounter an error due to a PostgreSQL collation version mismatch, preventing the creation of the `gvmd` database, use the following commands:

```bash
sudo -u postgres psql -c "ALTER DATABASE template1 REFRESH COLLATION VERSION;"
sudo gvm-setup
```

This process can take a while (up to an hour).

**NOTE:**
Make sure to save the admin password displayed at the end of setup, as you will use it to log into the GSA web interface.

**Why this matters:**
This command sets up vulnerability feeds, creates internal databases, and generates admin credentials for the web interface.

### Task D: Reset Admin Password (If Needed)

To create a new user, run:

```bash
sudo runuser -u _gvm -- gvmd --create-user=admin2 --new-password=12345
```

If you forgot to save the auto-generated password, reset it with the following command:

```bash
sudo runuser -u _gvm -- gvmd --user=admin --new-password=new_password
```

### Task E: Verify Setup

Run the following command to verify the installation status:

```bash
sudo gvm-check-setup
```

**Why this matters:**
This command checks for missing components or setup errors. Resolve any warnings that appear.

### Task F: Start the GVM Services

To start OpenVAS services, use:

```bash
sudo gvm-start
```

To stop the services when you're done:

```bash
sudo gvm-stop
```

Once started, open a browser and go to:

```
https://localhost:9392
```

**Note:** You may need to accept a self-signed certificate.

### Log in to OpenVAS

* Username: `admin`
* Password: The password you saved or created earlier

---

## Cleanup

To stop OpenVAS services when you're done, run:

```bash
sudo gvm-stop
```

---

### Notes

* **Installation may take time**: Depending on your system, the installation of dependencies and setup process can take a while (up to an hour). Please be patient during this phase.
* **Self-signed certificate**: When accessing the GSA web interface, you will be prompted with a warning due to the self-signed certificate. You can accept it for local access.
