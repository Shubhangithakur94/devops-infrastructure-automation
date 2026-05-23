# Log Rotation Automation using Shell Script and Cron

## Overview

This implementation automates log rotation and archival using a shell script and cron scheduling.

The solution manages application logs stored at:

```bash
/var/log/application.log
```

The script automatically:

- Retains recent logs
- Archives older logs
- Compresses archived logs using gzip
- Cleans up old compressed archives
- Ensures uninterrupted active logging
- Handles edge cases safely

---

# Directory Structure

```bash
automation/
├── log_rotate.sh
└── cronjob.txt
```

---

# Script Functionality

The shell script performs the following operations:

## 1. Log Validation

Checks:

- Log file exists
- Read/write permissions are available

If validation fails, the script exits safely.

---

## 2. Retention Logic

The script reads the application log file line by line.

Each log entry contains a timestamp:

```text
2026-05-23 10:15:20 INFO Application running
```

The script:

- Extracts the timestamp
- Converts it to epoch time
- Calculates log age

Logs newer than the retention period remain in the active log file.

Older logs are moved to archive storage.

---

# Log Retention and Archival Logic

## Active Logs

Recent logs are retained inside:

```bash
/var/log/application.log
```

---

## Archived Logs

Older logs are moved into:

```bash
/var/log/archive/
```

Archive files are created with timestamps:

```bash
application-2026-05-23_10-30-01.log.gz
```

---

## Compression

Archived logs are compressed automatically using:

```bash
gzip
```

Resulting files use:

```bash
.gz
```

format.

---

## Archive Cleanup

Compressed archives older than the configured retention period are automatically deleted using:

```bash
find "$ARCHIVE_DIR" -type f -name "*.gz" -mtime +5 -delete
```

This prevents unlimited archive growth.

---

# Idempotent Behavior

The script is designed to be idempotent.

Repeated executions:

- Do not duplicate logs
- Do not corrupt files
- Do not interrupt active logging
- Safely handle empty archive conditions

---

# Cron Configuration

The script is automated using cron.

## Production Schedule

```cron
0 0 * * * /bin/bash /opt/scripts/log_rotate.sh >> /var/log/log_rotate.log 2>&1
```

This runs the log rotation daily at midnight.

---

## Testing Schedule

```cron
*/2 * * * * /bin/bash /root/test_log_rotate.sh >> /tmp/log_rotate.log 2>&1
```

This runs the script every 2 minutes for testing purposes.

---

# How to Test the Script Manually

## 1. Generate Sample Logs

Run:

```bash
while true
do
    echo "$(date '+%Y-%m-%d %H:%M:%S') INFO Application running" >> /var/log/application.log
    sleep 5
done
```

This continuously writes logs into the application log file.

---

## 2. Run the Rotation Script

Execute manually:

```bash
bash test_log_rotate.sh
```

---

## 3. Verify Active Logs

Check active log file:

```bash
tail -f /var/log/application.log
```

Recent logs should continue appearing.

---

## 4. Verify Archived Logs

Check archive directory:

```bash
ls -lh /var/log/archive
```

Compressed `.gz` archive files should appear.

---

## 5. Verify Archive Cleanup

Older compressed archives are automatically removed based on the retention policy.

---

# Edge Cases Handled

The script handles:

- Missing log files
- Permission issues
- Empty archives
- Multiple script executions
- Safe log replacement
- Automatic archive cleanup

---

# Technologies Used

- Shell Scripting (Bash)
- Cron
- gzip
- Linux file operations
- find command

---

# Author
Shubhangi Thakur  
DevOps / Cloud Engineer