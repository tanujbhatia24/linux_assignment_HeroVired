#!/bin/bash

# Use the current directory for storing logs
LOG_DIR="$(pwd)/system_monitor"
LOG_FILE="$LOG_DIR/sys_metrics_$(date +'%Y-%m-%d_%H-%M-%S').log"

# Ensure the log directory exists
mkdir -p "$LOG_DIR"

# Collect system metrics
echo "------ System Metrics: $(date) ------" >> "$LOG_FILE"

# Use top instead of htop for CPU and memory logging
echo -e "\nCPU and Memory Usage:" >> "$LOG_FILE"
top -b -n 1 >> "$LOG_FILE"

# Disk usage
echo -e "\nDisk Usage:" >> "$LOG_FILE"
df -h >> "$LOG_FILE"

# Process usage
echo -e "\nTop 10 Memory-Intensive Processes:" >> "$LOG_FILE"
ps aux --sort=-%mem | head -10 >> "$LOG_FILE"

# Clean old logs (older than 7 days)
find "$LOG_DIR" -type f -name "*.log" -mtime +7 -exec rm {} \;

echo "Log saved to $LOG_FILE"
