# TechCorp DevOps Environment Setup Report

## **Prepared by:** Tanuj Bhatia    
## **Project:** Secure, Monitored, and Well-Maintained Development Environment  

---

## **Task 1: System Monitoring Setup**

### **Objective:**
- Configure monitoring tools for CPU, memory, disk, and process usage.
- Identify resource-intensive processes.
- Log system metrics for future reference.

### **Implementation Steps:**

1. **Install Monitoring Tools (Install htop).**
```bash
sudo apt install htop -y
```

2. **Create a bash script (system_monitor.sh) for disk usage monitoring, tracking and storing outputs in a log file.**
```bash
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
```
3. **Create a bash script (git_log_push.sh) for pushing the logs to github repo.**
```bash
#!/bin/bash

REPO_DIR="$(pwd)"
LOG_DIR="$REPO_DIR/system_monitor_log"
cd "$REPO_DIR"

#Run system monitoring script.
./system_monitor.sh

#Push the latest log to github repo.
git add .
git commit -m "Add system monitoring logs"
git push origin main
```

4. **Create a cron job for consistently tracking for effective capacity planning.**
```bash
# Add a cron job to push the logs every 30 minutes:
sudo crontab -e
*/30 * * * * /home/tanujbhatia/linux_assignment_HeroVired/git_log_push.sh
```
---

## **Task 2: User Management and Access Control**

### **Objective:**
- Create user accounts for Sarah and Mike.
- Assign isolated directories.
- Enforce password policies.

### **Implementation Steps:**

1. **Create and Validate User Accounts.**
```bash
# Add new users
sudo adduser sarah
sudo adduser mike

# Set secure passwords
sudo passwd sarah
sudo passwd mike

# Verify user creation
id sarah
id mike
```

2. **Create Isolated Directories.**
```bash
# Create workspace directories
sudo mkdir -p /home/sarah/workspace
sudo mkdir -p /home/mike/workspace

# Set ownership
sudo chown sarah:sarah /home/sarah/workspace
sudo chown mike:mike /home/mike/workspace

# Restrict permissions
sudo chmod 700 /home/sarah/workspace
sudo chmod 700 /home/mike/workspace
```

3. **Enforce Password complexity Policies.**
```bash
# Edit the password complexity rules
sudo nano /etc/security/pwquality.conf

# Add the following configuration
minlen = 12               # Minimum password length
minclass = 3              # At least 3 character classes (uppercase, lowercase, digits, symbols)
maxrepeat = 3             # Prevent consecutive repeating characters
retry = 3                 # Allow 3 retries before failure

# Enable complexity enforcement
sudo nano /etc/pam.d/common-password

# Ensure this line is present
password requisite pam_pwquality.so retry=3
```

4. **Enforce Expiration Policy.**
```bash
# Edit the password policy settings
sudo nano /etc/login.defs

# Add or modify the following lines:
PASS_MAX_DAYS   30      # Password expires after 30 days
PASS_MIN_DAYS   1       # Minimum 1 day between password changes
PASS_WARN_AGE   7       # Warn users 7 days before expiration

# Apply the policy to the new users
sudo chage -M 30 -m 1 -W 7 sarah
sudo chage -M 30 -m 1 -W 7 mike
```
---

## **Task 3: Backup Configuration for Web Servers**

### **Objective:**
- Automate backups for Apache and Nginx web servers.
- Schedule backups using cron jobs.
- Verify backup integrity.

### **Implementation Steps:**

1. **Create Backup Folder to store the Backup Configuration for Web Servers.**
```bash
# create backup folder
sudo mkdir $(pwd)/backups

# Assign appropriate permissions:
sudo chown sarah:sarah $(pwd)/backups
sudo chown mike:mike $(pwd)/backups
sudo chmod 700 backups
```
 
2. **Create Backup Scripts.**
```bash
# Apache Backup Sarah (apache_backup.sh)
sudo nano $(pwd)/apache_backup.sh
```
```bash
#!/bin/bash

# Variables
BACKUP_DIR="$(pwd)/backups"
TIMESTAMP=$(date +"%Y-%m-%d")
BACKUP_FILE="$BACKUP_DIR/apache_backup_$TIMESTAMP.tar.gz"
VERIFY_LOG="$BACKUP_DIR/apache_backup_verification.log"

# Backup Apache configuration and document root
tar -czf "$BACKUP_FILE" /etc/httpd/ /var/www/html/

# Verify backup integrity
echo "Verifying backup: $BACKUP_FILE" >> "$VERIFY_LOG"
tar -tf "$BACKUP_FILE" >> "$VERIFY_LOG"
echo "Backup completed: $TIMESTAMP" >> "$VERIFY_LOG"
echo "------------------------------------" >> "$VERIFY_LOG"
```
```bash
# Make script executable
sudo chmod +x $(pwd)/apache_backup.sh
```

```bash
# Nginx Backup Mike (nginx_backup.sh)
sudo nano $(pwd)/nginx_backup.sh
```
```bash
#!/bin/bash

# Variables
BACKUP_DIR="$(pwd)/backups"
TIMESTAMP=$(date +"%Y-%m-%d")
BACKUP_FILE="$BACKUP_DIR/nginx_backup_$TIMESTAMP.tar.gz"
VERIFY_LOG="$BACKUP_DIR/nginx_backup_verification.log"

# Backup Nginx configuration and document root
tar -czf "$BACKUP_FILE" /etc/nginx/ /usr/share/nginx/html/

# Verify backup integrity
echo "Verifying backup: $BACKUP_FILE" >> "$VERIFY_LOG"
tar -tf "$BACKUP_FILE" >> "$VERIFY_LOG"
echo "Backup completed: $TIMESTAMP" >> "$VERIFY_LOG"
echo "------------------------------------" >> "$VERIFY_LOG"
```
```bash
# Make script executable
sudo chmod +x $(pwd)/nginx_backup.sh
```

3. **Schedule Cron Jobs:**
```bash
# Edit Sarah’s cron configuration
sudo crontab -e -u sarah

# Add the following cron job
0 0 * * 2 /home/tanujbhatia/linux_assignment_HeroVired/apache_backup.sh

# Edit Mike’s cron configuration
sudo crontab -e -u mike

# Add the following cron job
0 0 * * 2 /home/tanujbhatia/linux_assignment_HeroVired/nginx_backup.sh
```

4. **Verify Backup Files and Integrity:**
```bash
# List backup files
ls -lh $(pwd)/backups/

# Verify the contents of the backup
tar -tf /backups/apache_backup_YYYY-MM-DD.tar.gz
tar -tf /backups/nginx_backup_YYYY-MM-DD.tar.gz
```
---

## **Challenges and Solutions:**

### **Challenges:**
1. **User permissions issue:** Initially, Sarah and Mike’s directories were accessible to other users.
   - **Solution:** Applied `chmod 700` to restrict access.
2. **Cron job not running:** Permissions were not properly set on backup scripts.
   - **Solution:** Added executable permissions using `chmod +x`.

---

## **Conclusion:**

- Successfully configured system monitoring with `htop` and `df` for resource tracking.
- Set up user accounts, enforced password policies, and isolated directories securely.
- Automated backups for Apache and Nginx with verification logs.

---

## **Screenshots:**
- System monitoring outputs.
<img width="389" alt="image" src="https://github.com/user-attachments/assets/79ac1ff4-1312-4bd2-bf48-877604c734e4" />
<img width="701" alt="image" src="https://github.com/user-attachments/assets/6f91836b-be12-4e20-9adb-04ebf2b7e479" />
<img width="939" alt="image" src="https://github.com/user-attachments/assets/ec102642-175c-4467-a45f-b836a80707e4" /> </br>

- User management terminal commands.</br>
<img width="540" alt="image" src="https://github.com/user-attachments/assets/d383cb6a-8a77-475e-aa88-661885d7e832" /> </br>
<img width="501" alt="image" src="https://github.com/user-attachments/assets/c43b9941-d81e-4db4-a31b-357d98e10193" /> </br>
<img width="560" alt="image" src="https://github.com/user-attachments/assets/9d5a7ae9-87a7-4bf2-a75d-355d623a33a9" /> </br>
<img width="458" alt="image" src="https://github.com/user-attachments/assets/5bb97753-3586-4bb6-ba3a-d2032e2a0fb6" /> </br>
<img width="557" alt="image" src="https://github.com/user-attachments/assets/0a3ba265-126e-435e-afcf-75613bafd648" /> </br>

- Cron job schedule and backup logs.</br>
<img width="797" alt="image" src="https://github.com/user-attachments/assets/0db54125-63c9-4317-8640-5ea88f55359c" /> </br>
<img width="632" alt="image" src="https://github.com/user-attachments/assets/25bcb751-d3f0-463e-89ba-84a9a8a58fac" /> </br>
<img width="734" alt="image" src="https://github.com/user-attachments/assets/17d046fb-9c70-48fe-8fb4-cd74e3240cef" />
---

## **Backup Files and Logs:**
- `apache_backup_YYYY-MM-DD.tar.gz`
- `nginx_backup_YYYY-MM-DD.tar.gz`
- Backup verification logs

---

✅ **End of Report**

