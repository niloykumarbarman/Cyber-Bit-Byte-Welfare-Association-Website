#!/bin/bash

# Quick Status Check
# Shows current deployment and application status

echo "════════════════════════════════════════════════════════════"
echo "  WELFARE ASSOCIATION WEBSITE - DEPLOYMENT STATUS"
echo "════════════════════════════════════════════════════════════"
echo ""

DEPLOY_DIR="/home/cyberbit/welfare.cyberbitbyte.com"

# Website Status
echo "🌐 Website Status:"
if curl -f -s -o /dev/null "https://welfare.cyberbitbyte.com" 2>/dev/null; then
    echo "   ✓ Online at https://welfare.cyberbitbyte.com"
else
    echo "   ✗ Website is NOT responding"
fi
echo ""

# Services Status
echo "🔧 Services:"
pgrep -x "php-fpm" > /dev/null && echo "   ✓ PHP-FPM running" || echo "   ✗ PHP-FPM stopped"
mysqladmin ping -u root > /dev/null 2>&1 && echo "   ✓ MySQL running" || echo "   ✗ MySQL stopped"
pgrep -x "nginx" > /dev/null && echo "   ✓ Nginx running" || echo "   ✗ Nginx stopped"
echo ""

# Latest Deployment
echo "📦 Deployment Info:"
if [ -f "$DEPLOY_DIR/.git/refs/heads/main" ]; then
    COMMIT=$(cat "$DEPLOY_DIR/.git/refs/heads/main")
    echo "   Commit: ${COMMIT:0:7}"
    LAST_DEPLOY=$(stat -c %y "$DEPLOY_DIR/.git/FETCH_HEAD" 2>/dev/null | cut -d' ' -f1,2)
    [ -n "$LAST_DEPLOY" ] && echo "   Last Deploy: $LAST_DEPLOY"
fi
echo ""

# Database Status
echo "💾 Database:"
if TABLES=$(mysql -u root -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='welfare_database'" 2>/dev/null | tail -1); then
    echo "   Tables: $TABLES"
fi
echo ""

# Backups
echo "📋 Latest Backups:"
BACKUP_COUNT=$(ls -1 /home/cyberbit/backups/welfare_*.sql.gz 2>/dev/null | wc -l)
echo "   Total Backups: $BACKUP_COUNT"
if [ "$BACKUP_COUNT" -gt 0 ]; then
    LATEST=$(ls -t /home/cyberbit/backups/welfare_*.sql.gz 2>/dev/null | head -1 | xargs -I {} basename {})
    echo "   Latest: $LATEST"
fi
echo ""

# Disk Space
echo "💿 Disk Usage:"
USAGE=$(df "$DEPLOY_DIR" | tail -1 | awk '{printf "%.1f", $5}')
echo "   ${USAGE}% used"
echo ""

# Failed Jobs/Errors
echo "⚠️  Recent Issues:"
ERROR_COUNT=$(grep -i "error" "$DEPLOY_DIR/storage/logs/laravel.log" 2>/dev/null | wc -l)
echo "   Errors in logs: $ERROR_COUNT"
[ "$ERROR_COUNT" -gt 0 ] && echo "   Run: tail -f $DEPLOY_DIR/storage/logs/laravel.log"
echo ""

echo "════════════════════════════════════════════════════════════"
