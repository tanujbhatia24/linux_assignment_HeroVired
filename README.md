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

1. **Install Monitoring Tools:**
```bash
# Install htop
sudo apt install htop -y   # Ubuntu/Debian
sudo yum install htop -y   # CentOS/RHEL

# Install nmon (alternative)
sudo apt install nmon -y
```

2. **Run Monitoring Tools:**
```bash
htop         # Real-time monitoring
nmon         # Run and select desired metrics
```

3. **Monitor Disk Usage:**
```bash
# Display disk space usage
sudo df -h

# Show disk usage for specific directories
sudo du -sh /home/*
```

4. **Identify Resource-Intensive Processes:**
```bash
ps aux --sort=-%cpu | head -5      # Top 5 CPU consuming processes
ps aux --sort=-%mem | head -5      # Top 5 memory consuming processes
```

5. **Create Monitoring Log:**
```bash
# Save disk usage and process details to log
sudo df -h > /var/log/system_monitor.log
ps aux --sort=-%cpu | head -5 >> /var/log/system_monitor.log
ps aux --sort=-%mem | head -5 >> /var/log/system_monitor.log
```

---

## **Task 2: User Management and Access Control**

### **Objective:**
- Create user accounts for Sarah and Mike.
- Assign isolated directories.
- Enforce password policies.

### **Implementation Steps:**

1. **Create User Accounts:**
```bash
sudo adduser sarah
sudo adduser mike

# Set secure passwords
sudo passwd sarah
sudo passwd mike
```

2. **Create Isolated Directories:**
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

3. **Enforce Password Policies:**
```bash
# Install pwquality module
sudo apt install libpam-pwquality -y   # Ubuntu/Debian
sudo yum install pam_pwquality -y      # CentOS/RHEL

# Edit password policy
sudo nano /etc/security/pwquality.conf

# Set policies:
minlen = 12
minclass = 3
difok = 4
maxrepeat = 3
maxclassrepeat = 4
retry = 3

enforce_for_root
```

4. **Enforce Expiration Policy:**
```bash
# Set password expiration to 30 days
sudo chage -M 30 sarah
sudo chage -M 30 mike
```

---

## **Task 3: Backup Configuration for Web Servers**

### **Objective:**
- Automate backups for Apache and Nginx web servers.
- Schedule backups using cron jobs.
- Verify backup integrity.

### **Implementation Steps:**

1. **Create Backup Script:**
```bash
# Apache Backup (Sarah)
sudo nano /usr/local/bin/apache_backup.sh
```
```bash
#!/bin/bash
BACKUP_DIR="/backups"
DATE=$(date +"%Y-%m-%d")
BACKUP_FILE="$BACKUP_DIR/apache_backup_$DATE.tar.gz"

tar -czf $BACKUP_FILE /etc/httpd/ /var/www/html/
echo "Apache backup completed: $BACKUP_FILE"
```
```bash
# Make script executable
sudo chmod +x /usr/local/bin/apache_backup.sh
```

```bash
# Nginx Backup (Mike)
sudo nano /usr/local/bin/nginx_backup.sh
```
```bash
#!/bin/bash
BACKUP_DIR="/backups"
DATE=$(date +"%Y-%m-%d")
BACKUP_FILE="$BACKUP_DIR/nginx_backup_$DATE.tar.gz"

tar -czf $BACKUP_FILE /etc/nginx/ /usr/share/nginx/html/
echo "Nginx backup completed: $BACKUP_FILE"
```
```bash
# Make script executable
sudo chmod +x /usr/local/bin/nginx_backup.sh
```

2. **Schedule Cron Jobs:**
```bash
# Edit cron jobs
sudo crontab -e
```
Add the following lines:
```bash
# Run every Tuesday at 12:00 AM
0 0 * * 2 /usr/local/bin/apache_backup.sh
0 0 * * 2 /usr/local/bin/nginx_backup.sh
```

3. **Verify Backup Integrity:**
```bash
# List backup files
ls -lh /backups/

# Verify contents of backup
sudo tar -tzf /backups/apache_backup_$(date +"%Y-%m-%d").tar.gz
sudo tar -tzf /backups/nginx_backup_$(date +"%Y-%m-%d").tar.gz
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
<img width="337" alt="image" src="https://github.com/user-attachments/assets/0c9ae9b5-bda5-467f-b74d-2b892b842215" /> </br>
<img width="521" alt="image" src="https://github.com/user-attachments/assets/fde1b405-4e37-4be1-aaaa-b0c3d95116fc" /> </br>
<img width="368" alt="image" src="https://github.com/user-attachments/assets/db1d352f-895b-4c81-8a2b-9129e13a298e" /> </br>
<img width="457" alt="image" src="https://github.com/user-attachments/assets/9a0a1728-81f7-4556-a78e-a16376978296" /> </br>
<img width="539" alt="image" src="https://github.com/user-attachments/assets/a7826b9b-2b7f-42fb-bb47-069e03c541b2" /> </br>
<img width="311" alt="image" src="https://github.com/user-attachments/assets/1174191e-e73a-44a4-ad81-7f77cd9fa0a3" /> </br>
<img width="395" alt="image" src="https://github.com/user-attachments/assets/d899d84c-2416-427c-af3b-93356ee4c2bc" />











- Cron job schedule and backup logs.

---

## **Backup Files and Logs:**
- `apache_backup_YYYY-MM-DD.tar.gz`
- `nginx_backup_YYYY-MM-DD.tar.gz`
- Backup verification logs

---

✅ **End of Report**

