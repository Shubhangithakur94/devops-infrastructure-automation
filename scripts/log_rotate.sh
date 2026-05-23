#!/bin/bash

set -euo pipefail

LOG_FILE="/var/log/application.log"
ARCHIVE_DIR="/var/log/archive"

# Retain logs for last 5 days
RETENTION_DAYS=5

CURRENT_TIME=$(date +%s)

mkdir -p "$ARCHIVE_DIR"

# Validate log file
if [[ ! -f "$LOG_FILE" ]]; then
    echo "ERROR: Log file not found"
    exit 1
fi

# Validate permissions
if [[ ! -r "$LOG_FILE" || ! -w "$LOG_FILE" ]]; then
    echo "ERROR: Permission issue"
    exit 1
fi

TEMP_FILE=$(mktemp)

ARCHIVE_FILE="$ARCHIVE_DIR/application-$(date '+%Y-%m-%d_%H-%M-%S').log"

touch "$ARCHIVE_FILE"

while IFS= read -r line
do

    # Extract timestamp from log line
    LOG_TIMESTAMP=$(echo "$line" | awk '{print $1" "$2}')

    # Convert timestamp to epoch
    LOG_EPOCH=$(date -d "$LOG_TIMESTAMP" +%s 2>/dev/null || echo 0)

    # Calculate log age in days
    AGE_DAYS=$(( (CURRENT_TIME - LOG_EPOCH) / 86400 ))

    # Archive logs older than 5 days
    if [[ "$AGE_DAYS" -gt "$RETENTION_DAYS" ]]; then
        echo "$line" >> "$ARCHIVE_FILE"
    else
        # Retain recent logs in active file
        echo "$line" >> "$TEMP_FILE"
    fi

done < "$LOG_FILE"

# Safely replace active log file
cat "$TEMP_FILE" > "$LOG_FILE"

rm -f "$TEMP_FILE"

# Compress archive if old logs exist
if [[ -s "$ARCHIVE_FILE" ]]; then
    gzip "$ARCHIVE_FILE"
    echo "INFO: Archived and compressed logs older than 5 days"
else
    rm -f "$ARCHIVE_FILE"
    echo "INFO: No logs older than 5 days found"
fi

# Delete compressed archives older than 5 days
find "$ARCHIVE_DIR" -type f -name "*.gz" -mtime +5 -delete
echo "INFO: Cleanup completed"