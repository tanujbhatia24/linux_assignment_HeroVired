#!/bin/bash

# Directory for storing logs
LOG_DIR="$(pwd)/system_monitor_log"
LOG_FILE="$LOG_DIR/sys_metrics_$(date +'%Y-%m-%d_%H-%M-%S').log"

# Ensure the log directory exists
mkdir -p "$LOG_DIR"

# Collecting system metrics
echo "------ System Metrics: $(date) ------" >> "$LOG_FILE"

# CPU and memory logging
echo -e "\nCPU and Memory Usage:" >> "$LOG_FILE"
top -b -n 1 >> "$LOG_FILE"

# Disk usage logging
echo -e "\nDisk Usage:" >> "$LOG_FILE"
df -h >> "$LOG_FILE"

# Resource-intensive usage logging
echo -e "\nTop 5 CPU-Intensive Processes:" >> "$LOG_FILE"
ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 6 >> "$LOG_FILE"
Techo -e "\nTop 5 Memory-Intensive Processes:" >> "$LOG_FILE"
ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -n 6 >> "$LOG_FILE"

# Clean old logs (older than 7 days)
find "$LOG_DIR" -type f -name "*.log" -mtime +7 -exec rm {} \;

echo "Log saved to $LOG_FILE"
