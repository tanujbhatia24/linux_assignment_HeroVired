#!/bin/bash
BACKUP_DIR="$(pwd)/backups"
DATE=$(date +"%Y-%m-%d")
BACKUP_FILE="$BACKUP_DIR/apache_backup_$DATE.tar.gz"

tar -czf $BACKUP_FILE /etc/httpd/ /var/www/html/
echo "Apache backup completed: $BACKUP_FILE"