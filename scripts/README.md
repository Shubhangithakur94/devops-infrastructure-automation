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

## How Logs Flow

Think of your logs like letters arriving at an office desk:

```text
[ Active Log File ]  ───(Older than 5 days?)───► [ Archive Folder ] ───(Archived for 5+ days?)───► [ Shredder ]
(Fresh data)                                     (Compressed .gz files)                            (Deleted forever)
(Retain)                                              (Archive)                                           (Clean up)
```

---

## Directory Structure

```text
scripts/
├── log_rotate.sh
└── cronjob.txt
```

- **[`log_rotate.sh`](file:///Users/shubhi/Working-dir/devops-infrastructure-automation/scripts/log_rotate.sh)**: The core shell script that handles log validation, retention logic, rotation, compression, and archival cleanup.
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
Recent logs (newer than 5 days) are kept in the active log file:
```bash
/var/log/application.log
```

### Archived Logs
Older logs (older than 5 days) are moved to the archive folder:
```bash
/var/log/archive/
```
Archived logs are grouped by date and saved with names like:
```bash
application-YYYY-MM-DD.log
```

### Compression
Archived log files are automatically compressed using `gzip` to save space. They are saved as:
```bash
application-YYYY-MM-DD.log.gz
```

### Archive Cleanup
Any compressed archive files in `/var/log/archive/` that are older than 5 days are deleted automatically. This is done using this command:
```bash
find "$ARCHIVE_DIR" -type f -name "*.gz" -mtime +5 -delete
```
This keeps the archive folder from growing too large.

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

```cron
# Schedule log rotation to run daily at midnight
0 0 * * * /bin/bash /opt/scripts/log_rotate.sh >> /var/log/log_rotate.log 2>&1
```

---

## How to Test the Script Manually

You can manually verify the log rotation and retention logic by following these steps:

### 1. Generate Test Log Entries
Add mock log entries with different dates (expired historical logs, fresh logs, and new live logs) to the active log file `/var/log/application.log`:

```bash
# Target 1: Expired data (6 days old - expected to be archived and compressed)
echo "$(date -d "6 days ago" +"%Y-%m-%d %H:%M:%S") WARN Expired historical data line entry" >> /var/log/application.log

# Target 2: Retained fresh data (2 days old - expected to remain in active live log)
echo "$(date -d "2 days ago" +"%Y-%m-%d %H:%M:%S") INFO Valid tracking line entry" >> /var/log/application.log

# Target 3: Instant live entry (0 days old - expected to remain in active live log)
echo "$(date +"%Y-%m-%d %H:%M:%S") DEBUG Live stream transaction record" >> /var/log/application.log
```

### 2. Run the Rotation Script
Run the log rotation script. You may need to run this with root privileges (using `sudo` or as root) to make sure you have permission to write to `/var/log/`:

```bash
sudo bash log_rotate.sh
```

### 3. Verify Active Logs
Check `/var/log/application.log` to make sure the fresh logs (Target 2 and Target 3) are still there, while the old log (Target 1) is gone:

```bash
cat /var/log/application.log
```

**Expected Output:**
```text
YYYY-MM-DD HH:MM:SS INFO Valid tracking line entry
YYYY-MM-DD HH:MM:SS DEBUG Live stream transaction record
```

### 4. Verify Archived Logs
Check the archive folder at `/var/log/archive/` to verify that the expired log (Target 1) was moved there and compressed:

```bash
ls -lh /var/log/archive
```

To view the contents of the compressed log file, use `zcat`:

```bash
zcat /var/log/archive/application-*.gz
```

**Expected Output:**
```text
YYYY-MM-DD HH:MM:SS WARN Expired historical data line entry
```

### 5. Verify Archive Cleanup
Verify that archive files older than the retention threshold of 5 days are automatically cleaned up.

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