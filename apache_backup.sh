#!/bin/bash

# Variables
BACKUP_DIR="/backups"
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
