#!/bin/bash

# Production Fix Script
# Run this on the production server to fix bootstrap errors

echo "=== Production Bootstrap Fix ==="
echo ""

DEPLOY_DIR="/home/cyberbit/welfare.cyberbitbyte.com"

if [ ! -d "$DEPLOY_DIR" ]; then
    echo "Error: Deployment directory not found at $DEPLOY_DIR"
    exit 1
fi

cd "$DEPLOY_DIR"

echo "Pulling latest code..."
git pull origin main

echo "Installing dependencies..."
composer install --no-dev --optimize-autoloader --quiet

echo "Clearing all caches..."
php artisan config:clear
php artisan cache:clear
php artisan view:clear
php artisan route:clear

echo "Optimizing application..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "Running database migrations..."
php artisan migrate --force

echo "Setting proper permissions..."
find storage -type f -exec chmod 644 {} \;
find storage -type d -exec chmod 755 {} \;
find bootstrap/cache -type f -exec chmod 644 {} \;
find bootstrap/cache -type d -exec chmod 755 {} \;

echo ""
echo "=== Fix Complete ==="
echo "Production server should now be working properly"
