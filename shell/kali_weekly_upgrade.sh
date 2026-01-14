#!/bin/bash

: <<'DOC'
.SYNOPSIS
    Kali Weekly Upgrade Script (Non-Interactive)

.DESCRIPTION
    Automatically updates and upgrades all packages on Kali Linux,
    identifies old kernels, and schedules a reboot if a new kernel was installed.
    Produces structured logs in /var/log/kali_upgrade/weekly.

.AUTHOR
    Anthony Marturano

.MODIFIED
    2026-01-14

.NOTES
    - Fully non-interactive
    - Logging enabled
    - Safe kernel removal after reboot
    - Automation-ready for cron jobs

# ==============================
# Kali Weekly Upgrade Script
# ==============================

# Log directories
LOG_DIR="/var/log/kali_upgrade/weekly"
mkdir -p "$LOG_DIR"

# Log file path
LOGFILE="$LOG_DIR/kali_upgrade_$(date +%F_%H-%M).log"

# Send output to terminal and log file
exec > >(tee -a "$LOGFILE") 2>&1

echo "==============================="
echo "Kali Weekly Upgrade Script Started: $(date)"
echo "==============================="

# Step 1: Update package list
echo -e "\nUpdating package lists..."
apt update -y

# Step 2: Upgrade all packages automatically
echo -e "\nUpgrading all packages..."
apt upgrade -y

# Step 3: Identify old kernels
CURRENT_KERNEL=$(uname -r)
echo -e "\nCurrent running kernel: $CURRENT_KERNEL"

INSTALLED_KERNELS=$(dpkg --list | grep linux-image | awk '{print $2}')
OLD_KERNELS=()
for kernel in $INSTALLED_KERNELS; do
    if [[ "$kernel" != *"$CURRENT_KERNEL"* && "$kernel" != "linux-image-amd64" ]]; then
        OLD_KERNELS+=("$kernel")
    fi
done

if [ ${#OLD_KERNELS[@]} -eq 0 ]; then
    echo "No old kernels found."
else
    echo "Old kernels installed (will remove after reboot):"
    printf '  %s\n' "${OLD_KERNELS[@]}"
fi

# Step 4: Schedule reboot if a new kernel was installed
if [[ ${#OLD_KERNELS[@]} -gt 0 ]]; then
    echo -e "\nNew kernel detected. Scheduling reboot in 1 minute..."
    /sbin/shutdown -r +1 "Rebooting automatically to apply new kernel."
fi

echo -e "\nScript completed: $(date)"
echo "Log saved to: $LOGFILE"
