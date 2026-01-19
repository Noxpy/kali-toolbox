# Deploy Metasploitable2 as a Docker Container inside Kali Linux VM

## Overview

This lab demonstrates how to run the **Metasploitable2** vulnerable target as a Docker container inside a Kali Linux VM. By the end of this exercise, you'll have a Metasploitable2 container running on an isolated Docker network and will be able to use it for various penetration testing and exploitation exercises.

## Estimated Time Needed: 15 minutes

## Learning Objectives

After completing this lab, you will be able to:

* Install and enable Docker inside Kali Linux.
* Create an isolated Docker network for lab use.
* Pull and run the Metasploitable2 Docker image attached to the network.
* Retrieve the container IP to use as a target for scans.
* Verify and set a restart policy to ensure the container reboots after a system restart.
* Troubleshoot common issues such as empty IPAddress and connection refused errors.

## Prerequisites

* A working Kali Linux VM with sudo privileges.
* Internet access from the Kali VM (for pulling the Docker image).
* Sufficient disk space (~1 GB+ for image and workspace).

> **Safety/Isolation Note:**
> This container is intentionally vulnerable. Ensure it is kept isolated from production or public networks. Always use the isolated Docker network created in this lab, and avoid publishing any ports to the internet unless explicitly required and understood.

---

## Steps

### 1) Update Packages and Install Docker

Run the following commands to update the system and install Docker:

```bash
sudo apt update
sudo apt install -y docker.io
sudo systemctl enable --now docker
```

> `sudo systemctl enable --now docker` will start Docker immediately and enable it to start on boot.

---

### 2) Create an Isolated Docker Network for the Lab

Create an isolated Docker network to keep the target container separate from other traffic on the host machine:

```bash
sudo docker network create metasploit-lab-net
```

---

### 3) Pull the Metasploitable2 Docker Image

Pull the **Metasploitable2** Docker image from Docker Hub:

```bash
sudo docker pull tleemcjr/metasploitable2:latest
```

This may take a minute or two depending on your network speed.

---

### 4) Run the Metasploitable2 Container (Detached, No Host Ports Published)

Run the Metasploitable2 container in detached mode on the isolated Docker network:

```bash
sudo docker run -d --name metasploitable2 --network metasploit-lab-net --restart unless-stopped tleemcjr/metasploitable2:latest
```

* `-d`: Run the container in detached mode (in the background).
* `--network metasploit-lab-net`: Attach the container to the `metasploit-lab-net` network.
* `--restart unless-stopped`: Ensure the container restarts automatically unless stopped manually.

---

### 5) Confirm the Container is Running

Check the status of the running container:

```bash
sudo docker ps --filter "name=metasploitable2"
```

Expected output (example):

```plaintext
CONTAINER ID   IMAGE                          COMMAND                 CREATED         STATUS         PORTS     NAMES
abcd1234       tleemcjr/metasploitable2:latest "/bin/sh -c '/s..."   2m ago          Up 2m          -         metasploitable2
```

---

### 6) Get the Metasploitable2 Container IP

Retrieve the IP address of the container to use it as a target for scans:

```bash
sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' metasploitable2
```

The command will return an IP address like `172.18.0.2`. Use this IP for your penetration testing tools.

> Alternatively, for more verbose network details, use:

```bash
sudo docker inspect metasploitable2 --format '{{json .NetworkSettings.Networks}}' | jq
```

(If `jq` is not installed, you can install it with `sudo apt install -y jq`.)

---

### 7) Ensure the Container Restarts After Reboot

Set the container restart policy to ensure it restarts automatically after reboots:

```bash
sudo docker update --restart unless-stopped metasploitable2
```

Verify the restart policy:

```bash
sudo docker inspect -f '{{.HostConfig.RestartPolicy.Name}}' metasploitable2
```

Expected output: `unless-stopped`

Simulate a Docker restart and confirm the container restarts:

```bash
sudo systemctl restart docker
sudo docker ps --filter "name=metasploitable2"
```

---

## Verification Checklist

* [ ] `docker ps` shows `metasploitable2` in the list and STATUS is `Up`.
* [ ] `docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' metasploitable2` returns a non-empty IP address.
* [ ] The returned IP can be pinged from the Kali VM: `ping -c 3 <container-ip>` (Note: ICMP may be disabled; absence of replies doesn't necessarily indicate service unavailability).
* [ ] Expected services (e.g., FTP, Telnet) respond when probed with `nmap -sS -sV <container-ip>` (use only from the Kali VM).

---

## Troubleshooting

### Problem: `docker inspect` Returns an Empty String for IPAddress

**Actions:**

1. Confirm that the container is attached to the correct network:

   ```bash
   sudo docker network inspect metasploit-lab-net
   ```

   Look under "Containers" for `metasploitable2` and check if an IPv4 address is listed.

2. If not, recreate the container and ensure it is attached to the network:

   ```bash
   sudo docker rm -f metasploitable2
   sudo docker run -d --name metasploitable2 --network metasploit-lab-net --restart unless-stopped tleemcjr/metasploitable2:latest
   sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' metasploitable2
   ```

3. If the network shows the container but the IP address is blank, recreate the network:

   ```bash
   sudo docker rm -f metasploitable2
   sudo docker network rm metasploit-lab-net
   sudo docker network create metasploit-lab-net
   sudo docker run -d --name metasploitable2 --network metasploit-lab-net --restart unless-stopped tleemcjr/metasploitable2:latest
   ```

### Problem: `ssh: connect to host <ip> port 22: Connection refused`

**Options:**

1. Use `docker exec` to enter the container shell and verify running services:

   ```bash
   sudo docker exec -it metasploitable2 /bin/bash
   ```

2. If you need SSH access from Kali to the container, publish the SSH port:

   ```bash
   sudo docker rm -f metasploitable2
   sudo docker run -d --name metasploitable2 --network metasploit-lab-net -p 2222:22 --restart unless-stopped tleemcjr/metasploitable2:latest
   ```

   Then connect from Kali:

   ```bash
   ssh msfadmin@localhost -p 2222
   ```

   Alternatively, start the SSH server inside the container if missing.

### Problem: Container Not Present After Docker Restart

**Checks:**

1. Verify the restart policy:

   ```bash
   sudo docker inspect -f '{{.HostConfig.RestartPolicy.Name}}' metasploitable2
   ```

2. Check Docker logs for errors:

   ```bash
   sudo journalctl -u docker -b --no-pager | tail -n 100
   ```

   If logs show errors, consider removing and re-creating the container.

---

## Cleanup

If you wish to remove the container and network after finishing the lab:

```bash
sudo docker rm -f metasploitable2
sudo docker network rm metasploit-lab-net
sudo apt remove --purge -y docker.io
```

> **Note:** Only remove Docker if you no longer need it.

---

## Instructor Notes

* **Isolation:** Do not publish ports unless specifically needed for SSH access.
* **Common Issues:** Missing Docker package, permission errors, lack of internet connectivity, or local firewall blocking Docker networking.
* **Older Kali Images:** Consider upgrading or using a pre-configured Kali snapshot with Docker pre-installed.


