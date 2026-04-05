#!/bin/bash

# Health Check & Monitoring Script
# Runs simple health checks to ensure the application is working properly

DEPLOY_DIR="/home/cyberbit/welfare.cyberbitbyte.com"
LOG_FILE="/home/cyberbit/health-check.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "[${TIMESTAMP}] Running health checks..." >> "$LOG_FILE"

# Check website is accessible
echo "[${TIMESTAMP}] Checking website accessibility..." >> "$LOG_FILE"
if curl -f -s -o /dev/null "https://welfare.cyberbitbyte.com" 2>/dev/null; then
    echo "[${TIMESTAMP}] ✓ Website is accessible" >> "$LOG_FILE"
else
    echo "[${TIMESTAMP}] ✗ Website is NOT accessible" >> "$LOG_FILE"
fi

# Check PHP is running
echo "[${TIMESTAMP}] Checking PHP process..." >> "$LOG_FILE"
if pgrep -x "php-fpm" > /dev/null 2>&1; then
    echo "[${TIMESTAMP}] ✓ PHP-FPM is running" >> "$LOG_FILE"
else
    echo "[${TIMESTAMP}] ✗ PHP-FPM is NOT running" >> "$LOG_FILE"
fi

# Check MySQL is running
echo "[${TIMESTAMP}] Checking MySQL..." >> "$LOG_FILE"
if mysqladmin ping -u root > /dev/null 2>&1; then
    echo "[${TIMESTAMP}] ✓ MySQL is running" >> "$LOG_FILE"
else
    echo "[${TIMESTAMP}] ✗ MySQL is NOT running" >> "$LOG_FILE"
fi

# Check storage directory is writable
echo "[${TIMESTAMP}] Checking storage directory permissions..." >> "$LOG_FILE"
if [ -w "$DEPLOY_DIR/storage" ]; then
    echo "[${TIMESTAMP}] ✓ Storage directory is writable" >> "$LOG_FILE"
else
    echo "[${TIMESTAMP}] ✗ Storage directory is NOT writable" >> "$LOG_FILE"
fi

# Check disk space
DISK_USAGE=$(df "$DEPLOY_DIR" | tail -1 | awk '{print $5}' | sed 's/%//')
echo "[${TIMESTAMP}] Disk usage: ${DISK_USAGE}%" >> "$LOG_FILE"
if [ "$DISK_USAGE" -gt 80 ]; then
    echo "[${TIMESTAMP}] ⚠ WARNING: Disk usage is above 80%!" >> "$LOG_FILE"
fi

# Check application logs for errors
RECENT_ERRORS=$(grep -i "error\|exception" "$DEPLOY_DIR/storage/logs/laravel.log" 2>/dev/null | tail -5)
if [ -n "$RECENT_ERRORS" ]; then
    echo "[${TIMESTAMP}] ⚠ Recent errors found in logs:" >> "$LOG_FILE"
    echo "$RECENT_ERRORS" >> "$LOG_FILE"
fi

echo "[${TIMESTAMP}] Health check completed" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Show last 20 lines of log
tail -20 "$LOG_FILE"
