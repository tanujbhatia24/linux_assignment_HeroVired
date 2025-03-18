#!/bin/bash

# Define log file location
LOG_DIR="/var/log/system_monitor"
LOG_FILE="$LOG_DIR/sys_metrics_$(date +'%Y-%m-%d_%H-%M-%S').log"

# Ensure the log directory exists
mkdir -p "$LOG_DIR"

# Collect system metrics
echo "------ System Metrics: $(date) ------" >> "$LOG_FILE"
echo "CPU and Memory Usage:" >> "$LOG_FILE"
htop -n 1 -b >> "$LOG_FILE" 2>/dev/null

echo -e "\nDisk Usage:" >> "$LOG_FILE"
df -h >> "$LOG_FILE"

echo -e "\nProcess Usage:" >> "$LOG_FILE"
ps aux --sort=-%mem | head -10 >> "$LOG_FILE"

# Clean old logs (older than 7 days)
find "$LOG_DIR" -type f -name "*.log" -mtime +7 -exec rm {} \;

echo "Log saved to $LOG_FILE"
