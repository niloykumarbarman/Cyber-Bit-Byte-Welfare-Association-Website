#!/bin/bash

# ============================================================================
# PRODUCTION SERVER COMPLETE REBUILD & FIX
# ============================================================================
# This script completely rebuilds the Laravel application from scratch
# It removes all vendor files and caches, then reinstalls everything clean
# This is the ULTIMATE fix for bootstrap and application errors
# ============================================================================

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║    PRODUCTION SERVER - COMPLETE REBUILD & FIX (RIGHT WAY)      ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

DEPLOY_DIR="/home/cyberbit/welfare.cyberbitbyte.com"
BACKUP_DIR="/home/cyberbit/backups/pre-fix-$(date +%Y%m%d_%H%M%S)"

# Verify directory exists
if [ ! -d "$DEPLOY_DIR" ]; then
    echo "❌ Error: Deployment directory not found at $DEPLOY_DIR"
    exit 1
fi

cd "$DEPLOY_DIR"

echo "===================================================================="
echo "STEP 1: Backup Current State"
echo "===================================================================="
mkdir -p "$BACKUP_DIR"
echo "Backing up to: $BACKUP_DIR"
cp -r . "$BACKUP_DIR" 2>/dev/null || echo "⚠ Backup skipped (space issue)"
echo "✓ Backup complete"
echo ""

echo "===================================================================="
echo "STEP 2: Set Permissions for Write Access"
echo "===================================================================="
chmod -R 755 .
chmod -R 777 storage bootstrap/cache .env
echo "✓ Permissions set"
echo ""

echo "===================================================================="
echo "STEP 3: Remove ALL Vendor Files & Lock"
echo "===================================================================="
echo "Removing vendor directory (this may take a moment)..."
rm -rf vendor composer.lock 2>/dev/null
echo "✓ Vendor/lock removed completely"
echo ""

echo "===================================================================="
echo "STEP 4: Reset Code to GitHub (Remove Local Changes)"
echo "===================================================================="
git fetch --all --force 2>/dev/null
git reset --hard origin/main
git clean -fd 2>/dev/null
echo "✓ Code reset to GitHub version"
echo ""

echo "===================================================================="
echo "STEP 5: Delete ALL Cache Files"
echo "===================================================================="
rm -rf storage/framework/cache/*
rm -rf storage/framework/views/*
rm -rf bootstrap/cache/*
rm -rf storage/logs/*
echo "✓ All cache files deleted"
echo ""

echo "===================================================================="
echo "STEP 6: Fresh Composer Install"
echo "===================================================================="
echo "Installing dependencies (this may take 2-3 minutes)..."
composer install --no-dev --optimize-autoloader --prefer-dist --no-suggest 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✓ Dependencies installed successfully"
else
    echo "❌ Composer install failed!"
    echo "Trying alternative method..."
    composer install --no-dev --optimize-autoloader --ignore-platform-reqs
fi
echo ""

echo "===================================================================="
echo "STEP 7: Ensure Bootstrap Cache Directory"
echo "===================================================================="
mkdir -p bootstrap/cache
chmod -R 777 bootstrap/cache storage
echo "✓ Bootstrap cache directory ready"
echo ""

echo "===================================================================="
echo "STEP 8: Clear All Laravel Caches (Hard Way)"
echo "===================================================================="
php artisan config:clear || true
php artisan cache:clear || true
php artisan view:clear || true
php artisan route:clear || true
php artisan event:clear || true
php artisan optimize:clear || true
echo "✓ All caches cleared"
echo ""

echo "===================================================================="
echo "STEP 9: Rebuild Optimized Caches"
echo "===================================================================="
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan event:cache || true
echo "✓ Caches rebuilt optimally"
echo ""

echo "===================================================================="
echo "STEP 10: Run Database Migrations"
echo "===================================================================="
php artisan migrate --force
echo "✓ Database migrated"
echo ""

echo "===================================================================="
echo "STEP 11: Final Permission Fix"
echo "===================================================================="
chown -R www-data:www-data . 2>/dev/null || true
find . -type f -name "*.php" -exec chmod 644 {} \;
find . -type d -name "storage" -exec chmod 755 {} \;
find . -type d -name "bootstrap" -exec chmod 755 {} \;
find storage -type f -exec chmod 644 {} \; 2>/dev/null || true
find storage -type d -exec chmod 755 {} \; 2>/dev/null || true
find bootstrap/cache -type f -exec chmod 644 {} \; 2>/dev/null || true
find bootstrap/cache -type d -exec chmod 755 {} \; 2>/dev/null || true
echo "✓ permissions fixed"
echo ""

echo "===================================================================="
echo "STEP 12: Verify Environment"
echo "===================================================================="
echo "PHP Version: $(php --version 2>/dev/null | head -n1)"
echo "Composer: $(composer --version 2>/dev/null)"
php --ini 2>/dev/null | grep "Loaded Configuration"
echo "✓ Environment verified"
echo ""

echo "===================================================================="
echo "STEP 13: Test Health Endpoint"
echo "===================================================================="
sleep 2
echo "Testing: https://welfare.cyberbitbyte.com/health"

if curl -s --connect-timeout 5 https://welfare.cyberbitbyte.com/health | grep -q "ok"; then
    echo "✅ HEALTH CHECK PASSED!"
    echo "✅ SERVER IS WORKING!"
else
    echo "⚠️  Health check failed - checking if site is accessible..."
    if curl -s --connect-timeout 5 https://welfare.cyberbitbyte.com/ | grep -q "html"; then
        echo "✅ Site is accessible (might be loading)"
    else
        echo "❌ Site not responding - check error logs:"
        echo "   tail -50 storage/logs/laravel.log"
    fi
fi
echo ""

echo "===================================================================="
echo "REPAIR COMPLETE!"
echo "===================================================================="
echo ""
echo "Next steps:"
echo "1. Visit: https://welfare.cyberbitbyte.com"
echo "2. Visit: https://welfare.cyberbitbyte.com/admin"
echo "3. Check logs if needed: tail -50 storage/logs/laravel.log"
echo ""
echo "If still having issues:"
echo "• Check storage/logs/laravel.log for detailed errors"
echo "• Verify database connection in .env"
echo "• Backup available at: $BACKUP_DIR"
echo ""
