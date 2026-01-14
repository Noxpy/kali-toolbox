#!/bin/bash

: <<'DOC'
.SYNOPSIS
    Automatically removes old Linux kernels after a system reboot.

.DESCRIPTION
    This script identifies all installed Linux kernel images except the current running kernel
    and the meta-package "linux-image-amd64". It then removes old kernels to free up disk space
    and runs "apt autoremove" to clean up dependencies.

    Designed for automation in Kali Linux post-reboot scenarios. Logs all activity to /var/log/kali_upgrade/post_reboot.

.AUTHOR
    Anthony Marturano

.MODIFIED
    2026-01-14

.USAGE
    Run as root or via sudo. Can be scheduled with cron @reboot or run manually:
        sudo /usr/local/bin/kali_post_reboot_cleanup.sh

.NOTES
    - Non-interactive by default
    - Safe: does not remove the running kernel or the meta-package
    - Structured logging for auditing

DOC


# ==============================
# Kali Post-Reboot Kernel Cleanup
# ==============================

# Log directories
LOG_DIR="/var/log/kali_upgrade/post_reboot"
mkdir -p "$LOG_DIR"

# Log file path
LOGFILE="$LOG_DIR/kali_cleanup_$(date +%F_%H-%M).log"

# Send output to terminal and log file
exec > >(tee -a "$LOGFILE") 2>&1

echo "==============================="
echo "Kali Post-Reboot Kernel Cleanup Started: $(date)"
echo "==============================="

# Get current running kernel
CURRENT_KERNEL=$(uname -r)
echo "Current running kernel: $CURRENT_KERNEL"

# Identify installed kernels
INSTALLED_KERNELS=$(dpkg --list | grep linux-image | awk '{print $2}')
OLD_KERNELS=()
for kernel in $INSTALLED_KERNELS; do
    if [[ "$kernel" != *"$CURRENT_KERNEL"* && "$kernel" != "linux-image-amd64" ]]; then
        OLD_KERNELS+=("$kernel")
    fi
done

# Remove old kernels automatically
if [ ${#OLD_KERNELS[@]} -eq 0 ]; then
    echo "No old kernels found. Nothing to remove."
else
    echo "Removing old kernels:"
    printf '  %s\n' "${OLD_KERNELS[@]}"
    for old_kernel in "${OLD_KERNELS[@]}"; do
        echo "Removing $old_kernel..."
        apt remove --purge -y "$old_kernel"
    done
    apt autoremove -y
    echo "Old kernels removed successfully."
fi

echo -e "\nPost-reboot cleanup completed: $(date)"
echo "Log saved to: $LOGFILE"
