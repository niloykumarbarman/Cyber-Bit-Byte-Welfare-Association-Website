#!/bin/bash

# Production Fix Script - Comprehensive Bootstrap Error Resolution
# Run this on the production server to fix all bootstrap-related issues

echo "=== PRODUCTION SERVER COMPREHENSIVE FIX ==="
echo ""

DEPLOY_DIR="/home/cyberbit/welfare.cyberbitbyte.com"

if [ ! -d "$DEPLOY_DIR" ]; then
    echo "Error: Deployment directory not found at $DEPLOY_DIR"
    exit 1
fi

cd "$DEPLOY_DIR"

echo "[1/10] Setting up permissions..."
chmod -R 755 .
chmod -R 777 storage bootstrap/cache

echo "[2/10] Removing vendor directory..."
rm -rf vendor composer.lock

echo "[3/10] Pulling latest code from GitHub..."
git fetch origin
git reset --hard origin/main

echo "[4/10] Reinstalling all dependencies..."
composer install --no-dev --optimize-autoloader

echo "[5/10] Creating bootstrap cache directory..."
mkdir -p bootstrap/cache
chmod -R 777 bootstrap/cache

echo "[6/10] Force clearing all caches..."
rm -rf storage/framework/cache/*
rm -rf storage/framework/views/*
rm -rf bootstrap/cache/*

php artisan config:clear || true
php artisan cache:clear || true
php artisan view:clear || true
php artisan route:clear || true

echo "[7/10] Rebuilding optimized caches..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "[8/10] Running database migrations..."
php artisan migrate --force

echo "[9/10] Setting final permissions..."
chown -R www-data:www-data . 2>/dev/null || true
find . -type f -name "*.php" -exec chmod 644 {} \;
find storage -type f -exec chmod 644 {} \;
find storage -type d -exec chmod 755 {} \;
find bootstrap/cache -type f -exec chmod 644 {} \;
find bootstrap/cache -type d -exec chmod 755 {} \;

echo "[10/10] Verifying installation..."
php --version
php -m | grep -i curl || echo "Warning: curl not installed"
composer --version

echo ""
echo "=== FIX COMPLETE ==="
echo ""
echo "✓ All caches cleared and rebuilt"
echo "✓ Dependencies reinstalled"
echo "✓ Permissions fixed"
echo "✓ Database migrated"
echo ""
echo "Testing health endpoint..."
sleep 2

if curl -sf https://welfare.cyberbitbyte.com/health > /dev/null 2>&1; then
    echo "✓ Health check PASSED - Server is working!"
else
    echo "⚠ Health check failed - Check error logs:"
    echo "  tail storage/logs/laravel.log"
fi
