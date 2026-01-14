#!/bin/bash
: <<'END_DOC'
.SYNOPSIS
    Cleans up old kernels automatically after a reboot on Kali Linux.

.DESCRIPTION
    Detects old installed kernels (excluding the running kernel and linux-image-amd64 meta-package) 
    and removes them non-interactively.
    Logs all output to a timestamped log in /var/log/kali_upgrade/post_reboot.

.AUTHOR
    Anthony Marturano

.NOTES
    - Non-interactive
    - Root privileges required
    - Safe for automation
END_DOC
# DOC

# Log directories
LOG_DIR="/var/log/kali_upgrade/post_reboot"
mkdir -p "$LOG_DIR"

# Log file path
LOGFILE="$LOG_DIR/kali_cleanup_$(date +%F_%H-%M).log"

# Send all output to terminal and log file
exec > >(tee -a "$LOGFILE") 2>&1

echo "==============================="
echo "Kali Post-Reboot Kernel Cleanup Started: $(date)"
echo "==============================="

# Get current running kernel
CURRENT_KERNEL=$(uname -r)
echo "Current running kernel: $CURRENT_KERNEL"

# Identify old kernels
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
