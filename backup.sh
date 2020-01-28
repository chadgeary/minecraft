#!/bin/bash
# Backup cron for /opt/minecraft/server directory
# Removes backups older than 4 days.
BACKUP_DIR='/opt/minecraft/backups'

# Remove old backup(s)
find $BACKUP_DIR -type -f -mtime +4 -name 'backup*.tar.gz' -delete

# Archive current server state
tar cvf - /opt/minecraft/server | gzip -9 > $BACKUP_DIR/server_backup_$(date +"%F_%H_%M_%S").tar.gz
