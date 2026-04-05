#!/bin/bash

# DIRECT PRODUCTION FIX - Copy and paste this entire block into your server terminal

cd /home/cyberbit/welfare.cyberbitbyte.com && \
echo "==== PRODUCTION FIX START ====" && \
chmod -R 777 . && \
rm -rf vendor composer.lock storage/framework/cache/* storage/framework/views/* bootstrap/cache/* && \
git fetch origin main && git reset --hard origin/main && git clean -fd && \
composer install --no-dev --optimize-autoloader && \
mkdir -p bootstrap/cache && chmod -R 777 bootstrap/cache storage && \
php artisan config:clear && php artisan cache:clear && php artisan view:clear && php artisan route:clear && \
php artisan config:cache && php artisan route:cache && php artisan view:cache && \
php artisan migrate --force && \
chown -R www-data:www-data . 2>/dev/null || true && \
find . -type f -name "*.php" -exec chmod 644 {} \; && \
find storage -type d -exec chmod 755 {} \; 2>/dev/null && \
find bootstrap/cache -type d -exec chmod 755 {} \; 2>/dev/null && \
echo "==== PRODUCTION FIX COMPLETE ====" && \
echo "" && \
echo "Testing server..." && \
sleep 2 && \
curl -s https://welfare.cyberbitbyte.com/health | grep -q "ok" && echo "✅ SERVER IS WORKING!" || echo "⚠ Check logs: tail storage/logs/laravel.log"
