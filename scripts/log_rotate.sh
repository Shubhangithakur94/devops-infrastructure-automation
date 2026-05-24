#!/bin/bash

# Exit script if a command fails, a variable is unset, or a piped command fails
set -euo pipefail

# Settings
LOG_FILE="/var/log/application.log"
ARCHIVE_DIR="/var/log/archive"
RETENTION_DAYS=5

# Get the current time in seconds
CURRENT_TIME=$(date +%s)

# Create the archive directory if it does not exist
mkdir -p "$ARCHIVE_DIR"

if [[ ! -f "$LOG_FILE" ]]; then
    echo "ERROR: Log file not found: $LOG_FILE"
    exit 1
fi

# Make sure we have permission to read and write to the files and directories
if [[ ! -r "$LOG_FILE" || ! -w "$LOG_FILE" || ! -w "$ARCHIVE_DIR" ]]; then
    echo "ERROR: Permission denied. Check read/write permissions for files and folders."
    exit 1
fi

# Move the current log file to a snapshot file to rotate it
SNAPSHOT_FILE="${LOG_FILE}.snapshot"
mv "$LOG_FILE" "$SNAPSHOT_FILE"

# Create a new empty log file right away so writing can continue
touch "$LOG_FILE"
chmod 644 "$LOG_FILE"

# Create a temporary file to hold active logs
TEMP_FILE=$(mktemp)

# Read the snapshot file line by line
while IFS= read -r line
do
    # Extract the timestamp (YYYY-MM-DD HH:MM:SS) from the start of the line
    LOG_TIMESTAMP=$(echo "$line" | awk '{print $1" "$2}')

    # Convert the timestamp to seconds
    LOG_EPOCH=$(date -d "$LOG_TIMESTAMP" +%s 2>/dev/null || echo 0)

    # Calculate the age of the log line in days
    AGE_DAYS=$(( (CURRENT_TIME - LOG_EPOCH) / 86400 ))

    # If the line is older than the retention days, archive it. Otherwise, keep it.
    if [[ "$AGE_DAYS" -gt "$RETENTION_DAYS" ]]; then
        LOG_DATE=$(date -d "$LOG_TIMESTAMP" '+%Y-%m-%d' 2>/dev/null || echo "unknown-date")
        CURRENT_ARCHIVE="$ARCHIVE_DIR/application-${LOG_DATE}.log"
        echo "$line" >> "$CURRENT_ARCHIVE"
    else
        echo "$line" >> "$TEMP_FILE"
    fi
done < "$SNAPSHOT_FILE"

# Put the kept lines back into the main log file
if [[ -s "$TEMP_FILE" ]]; then
    cat "$TEMP_FILE" >> "$LOG_FILE"
fi

# Clean up temporary files
rm -f "$TEMP_FILE"
rm -f "$SNAPSHOT_FILE"

# Compress the archived log files to save disk space
if ls "$ARCHIVE_DIR"/*.log >/dev/null 2>&1; then
    for f in "$ARCHIVE_DIR"/*.log; do
        if [[ -s "$f" ]]; then
            gzip -f "$f"
            echo "INFO: Compressed archive file: $f.gz"
        else
            rm -f "$f"
        fi
    done
else
    echo "INFO: No log files found to compress."
fi

# Delete old compressed log files that are past the retention period
find "$ARCHIVE_DIR" -type f -name "*.gz" -mtime +"$RETENTION_DAYS" -delete

echo "INFO: Log rotation completed successfully."