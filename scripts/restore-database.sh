#!/bin/bash

# Restore Database from Backup
# Usage: ./scripts/restore-database.sh backup_filename [database_name]

BACKUP_FILE="$1"
DB_NAME="${2:-welfare_database}"
DB_USER="${3:-root}"

if [ -z "$BACKUP_FILE" ]; then
    echo "Usage: $0 <backup_filename> [database_name] [db_user]"
    echo ""
    echo "Available backups:"
    ls -lh /home/cyberbit/backups/ 2>/dev/null || echo "No backups found"
    exit 1
fi

# Check if backup exists
if [ ! -f "$BACKUP_FILE" ]; then
    echo "Error: Backup file not found: $BACKUP_FILE"
    exit 1
fi

# Confirm restoration
echo "⚠️  WARNING: This will restore the database from: $BACKUP_FILE"
echo "Database: $DB_NAME"
read -p "Type 'yes' to confirm: " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "Restoration cancelled"
    exit 1
fi

echo "Starting database restoration..."

# Determine if file is gzipped
if [[ "$BACKUP_FILE" == *.gz ]]; then
    gunzip < "$BACKUP_FILE" | mysql -u "$DB_USER" -p "$DB_NAME" 2>/dev/null
else
    mysql -u "$DB_USER" -p "$DB_NAME" < "$BACKUP_FILE" 2>/dev/null
fi

if [ $? -eq 0 ]; then
    echo "✓ Database restored successfully from: $BACKUP_FILE"
    echo ""
    echo "Next steps:"
    echo "1. Clear application cache: php artisan cache:clear"
    echo "2. Clear config cache: php artisan config:clear"
    echo "3. Verify data: Check your application"
else
    echo "✗ Database restoration failed!"
    exit 1
fi
