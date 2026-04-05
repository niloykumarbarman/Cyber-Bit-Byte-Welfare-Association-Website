#!/bin/bash

# Database Backup Script
# This script backs up the database and maintains a retention policy

# Configuration
BACKUP_DIR="/home/cyberbit/backups"
DB_NAME="${1:-welfare_database}"
DB_USER="${2:-root}"
DB_HOST="${3:-localhost}"
RETENTION_DAYS=30
BACKUP_TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/welfare_${BACKUP_TIMESTAMP}.sql"

# Create backup directory if it doesn't exist
mkdir -p "${BACKUP_DIR}"

# Check if backup directory is writable
if [ ! -w "${BACKUP_DIR}" ]; then
    echo "Error: Backup directory is not writable" >> /var/log/backup.log
    exit 1
fi

# Perform database backup
echo "[$(date +'%Y-%m-%d %H:%M:%S')] Starting backup..." >> /var/log/backup.log

if mysqldump -u "${DB_USER}" -h "${DB_HOST}" "${DB_NAME}" > "${BACKUP_FILE}" 2>/dev/null; then
    gzip "${BACKUP_FILE}"
    BACKUP_SIZE=$(du -h "${BACKUP_FILE}.gz" | cut -f1)
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Backup completed: ${BACKUP_FILE}.gz (${BACKUP_SIZE})" >> /var/log/backup.log
else
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Backup failed!" >> /var/log/backup.log
    rm "${BACKUP_FILE}" 2>/dev/null
    exit 1
fi

# Remove old backups (retention policy)
echo "[$(date +'%Y-%m-%d %H:%M:%S')] Removing backups older than ${RETENTION_DAYS} days..." >> /var/log/backup.log
find "${BACKUP_DIR}" -name "welfare_*.sql.gz" -mtime "+${RETENTION_DAYS}" -delete

echo "[$(date +'%Y-%m-%d %H:%M:%S')] Backup maintenance completed" >> /var/log/backup.log

# Optional: Upload to S3 or remote storage
# aws s3 cp "${BACKUP_FILE}.gz" s3://your-bucket/backups/

exit 0
