# Log Rotation Automation using Shell Script and Cron

This implementation automates log rotation and archival using a custom shell script and cron scheduling.

The solution manages application logs stored at:
```bash
/var/log/application.log
```

The script automatically:
- Retains recent log entries within the active file.
- Archives older logs based on a configurable retention period.
- Compresses archived logs using `gzip` to save space.
- Cleans up old compressed archives automatically.
- Ensures uninterrupted active logging while rotation is running.
- Handles edge cases (such as permissions and empty logs) safely.

---

## Directory Structure

```text
scripts/
├── log_rotate.sh
├── test_log_rotate.sh
└── cronjob.txt
```

- **[`log_rotate.sh`](file:///Users/shubhi/Working-dir/devops-infrastructure-automation/scripts/log_rotate.sh)**: The core production shell script that handles log validation, retention logic, rotation, compression, and archival cleanup.
- **[`test_log_rotate.sh`](file:///Users/shubhi/Working-dir/devops-infrastructure-automation/scripts/test_log_rotate.sh)**: A test version of the rotation script calibrated for 2-minute retention rather than 5 days.
- **[`cronjob.txt`](file:///Users/shubhi/Working-dir/devops-infrastructure-automation/scripts/cronjob.txt)**: Cron daemon configuration to schedule the rotation script.

---

## Script Functionality

The shell script performs the following operations:

### 1. Log Validation
Checks:
- If the log file exists.
- If appropriate read/write permissions are available.

If validation fails, the script exits safely with a non-zero exit status and logs the error.

### 2. Retention Logic
The script reads the active application log file line by line. Each log entry contains a timestamp at the beginning of the line:
```text
2026-05-23 10:15:20 INFO Application running
```

During rotation, the script:
- Extracts the timestamp.
- Converts it to epoch time.
- Calculates the age of the log entry.

Log entries newer than the retention period remain in the active log file, while older logs are moved to the archive storage.

---

## Log Retention and Archival Logic

### Active Logs
Recent logs are retained inside:
```bash
/var/log/application.log
```

### Archived Logs
Older logs are moved into the archive directory:
```bash
/var/log/archive/
```
Archive files are created with dynamic timestamp names:
```bash
application-2026-05-23_10-30-01.log
```

### Compression
Archived logs are compressed automatically using `gzip`. The resulting files use the `.gz` format:
```bash
application-2026-05-23_10-30-01.log.gz
```

### Archive Cleanup
Compressed archives older than the configured retention period are automatically deleted using the `find` command:
```bash
find "$ARCHIVE_DIR" -type f -name "*.gz" -mtime +5 -delete
```
This prevents unlimited archive growth.

---

## Idempotent Behavior

The script is designed to be fully idempotent. Repeated executions:
- Do not duplicate logs in archives or active files.
- Do not corrupt files.
- Do not interrupt active logging processes.
- Safely handle empty archive conditions (i.e. no logs need archiving).

---

## Cron Configuration

The log rotation script is automated using the system cron daemon.

### Production Schedule
Set log rotation to run daily at midnight:
```cron
0 0 * * * /bin/bash /opt/scripts/log_rotate.sh >> /var/log/log_rotate.log 2>&1
```

### Testing Schedule
For testing purposes, run the rotation script every 2 minutes:
```cron
*/2 * * * * /bin/bash /root/test_log_rotate.sh >> /tmp/log_rotate.log 2>&1
```

---

## How to Test the Script Manually

### 1. Generate Sample Logs
Run this loop in your terminal to continuously write mock log lines with current timestamps to the active log file:
```bash
while true
do
    echo "$(date '+%Y-%m-%d %H:%M:%S') INFO Application running" >> /var/log/application.log
    sleep 5
done
```

### 2. Run the Rotation Script
Execute the test script manually (ensure you run this with the correct user permissions):
```bash
bash test_log_rotate.sh
```

### 3. Verify Active Logs
Check the active log file to make sure recent entries are preserved:
```bash
tail -f /var/log/application.log
```

### 4. Verify Archived Logs
Check the archive directory to see if compressed `.gz` archives are being created:
```bash
ls -lh /var/log/archive
```

### 5. Verify Archive Cleanup
Verify that archives older than the retention threshold (2 minutes for the test script) are automatically removed.

---

## Edge Cases Handled

The script handles:
- **Missing log files**: Exits gracefully with a message.
- **Permission issues**: Validates read/write permission before starting.
- **Empty archives**: Prevents writing or compressing empty files.
- **Multiple script executions**: Safely handles concurrent reads/writes using temporary staging files.
- **Safe log replacement**: Uses atomic redirection to rewrite active logs.
- **Automatic archive cleanup**: Cleans up disk space without manual intervention.

---

## Technologies Used

- **Shell Scripting** (Bash)
- **Cron** (Task Scheduling)
- **gzip** (Compression utility)
- **Linux File System Tools** (find, awk, date, mktemp)

---

## Author

- **Shubhangi Thakur** - *DevOps / Cloud Engineer*