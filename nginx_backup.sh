#!/bin/bash
BACKUP_DIR="$(pwd)/backups"
DATE=$(date +"%Y-%m-%d")
BACKUP_FILE="$BACKUP_DIR/nginx_backup_$DATE.tar.gz"

tar -czf $BACKUP_FILE /etc/nginx/ /usr/share/nginx/html/
echo "Nginx backup completed: $BACKUP_FILE"