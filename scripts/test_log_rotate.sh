#!/bin/bash

set -euo pipefail

LOG_FILE="/var/log/application.log"
ARCHIVE_DIR="/var/log/archive"

# Keep logs newer than 2 minute
RETENTION_MINUTES=2

CURRENT_TIME=$(date +%s)

mkdir -p "$ARCHIVE_DIR"

# Validate log file
if [[ ! -f "$LOG_FILE" ]]; then
    echo "ERROR: Log file not found"
    exit 1
fi

if [[ ! -r "$LOG_FILE" || ! -w "$LOG_FILE" ]]; then
    echo "ERROR: Permission issue"
    exit 1
fi

TEMP_FILE=$(mktemp)

ARCHIVE_FILE="$ARCHIVE_DIR/application-$(date '+%Y-%m-%d_%H-%M-%S').log"

touch "$ARCHIVE_FILE"

while IFS= read -r line
do

    LOG_TIMESTAMP=$(echo "$line" | awk '{print $1" "$2}')

    LOG_EPOCH=$(date -d "$LOG_TIMESTAMP" +%s 2>/dev/null || echo 0)

    AGE_MINUTES=$(( (CURRENT_TIME - LOG_EPOCH) / 60 ))

    if [[ "$AGE_MINUTES" -gt "$RETENTION_MINUTES" ]]; then
        echo "$line" >> "$ARCHIVE_FILE"
    else
        echo "$line" >> "$TEMP_FILE"
    fi

done < "$LOG_FILE"

# Replace active log safely
cat "$TEMP_FILE" > "$LOG_FILE"

rm -f "$TEMP_FILE"

# Compress archive only if it has content
if [[ -s "$ARCHIVE_FILE" ]]; then
    gzip "$ARCHIVE_FILE"
    echo "INFO: Archived old logs"
else
    rm -f "$ARCHIVE_FILE"
    echo "INFO: No old logs to archive"
fi

# Delete compressed archives older than 2 minutes
find "$ARCHIVE_DIR" -type f -name "*.gz" -mmin +2 -delete
echo "INFO: Cleanup completed"