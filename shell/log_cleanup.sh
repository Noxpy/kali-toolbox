#!/bin/bash
: <<'END_DOC'
.SYNOPSIS
    Cleans old weekly and post-reboot upgrade logs automatically, and alerts if total log size exceeds a safe threshold.

.DESCRIPTION
    Deletes logs older than a specified number of days (default: 90) in 
    /var/log/kali_upgrade/weekly and /var/log/kali_upgrade/post_reboot.
    Warns if total log size exceeds 500 MB.
    Logs all actions to a timestamped log in /var/log/kali_upgrade.

.AUTHOR
    Anthony Marturano

.NOTES
    - Root privileges required
    - Automation-friendly
    - Non-interactive
END_DOC
# DOC

# Log directories
WEEKLY_LOG_DIR="/var/log/kali_upgrade/weekly"
REBOOT_LOG_DIR="/var/log/kali_upgrade/post_reboot"

# Number of days to keep logs
KEEP_DAYS=90

# Maximum total log size in MB before warning
MAX_LOG_SIZE_MB=500

# Cleanup log file
CLEANUP_LOG="/var/log/kali_upgrade/log_cleanup_$(date +%F_%H-%M).log"

# Ensure cleanup log directory exists
mkdir -p /var/log/kali_upgrade

# Send output to terminal and log file
exec > >(tee -a "$CLEANUP_LOG") 2>&1

echo "==============================="
echo "Kali Log Cleanup Started: $(date)"
echo "==============================="

# Function to clean old logs
cleanup_logs() {
    local DIR="$1"
    echo "Cleaning logs older than $KEEP_DAYS days in $DIR ..."
    if [ -d "$DIR" ]; then
        find "$DIR" -type f -name '*.log' -mtime +$KEEP_DAYS -print -exec rm {} \;
    else
        echo "Directory $DIR does not exist. Skipping."
    fi
}

# Clean weekly upgrade logs
cleanup_logs "$WEEKLY_LOG_DIR"

# Clean post-reboot cleanup logs
cleanup_logs "$REBOOT_LOG_DIR"

# Check total log size
TOTAL_SIZE_MB=$(du -sm "$WEEKLY_LOG_DIR" "$REBOOT_LOG_DIR" 2>/dev/null | awk '{sum += $1} END {print sum}')
echo -e "\nTotal log size: ${TOTAL_SIZE_MB} MB"

if [ "$TOTAL_SIZE_MB" -gt "$MAX_LOG_SIZE_MB" ]; then
    echo "WARNING: Total log size exceeds ${MAX_LOG_SIZE_MB} MB. Consider increasing cleanup frequency or reducing KEEP_DAYS."
else
    echo "Log size within safe limits."
fi

echo -e "\nKali Log Cleanup Completed: $(date)"
echo "Cleanup log saved to: $CLEANUP_LOG"
