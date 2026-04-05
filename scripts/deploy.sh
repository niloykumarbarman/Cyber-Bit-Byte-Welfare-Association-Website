#!/usr/bin/env bash
set -euo pipefail

DEPLOY_DIR="/home/cyberbit/welfare.cyberbitbyte.com"

if [ ! -d "$DEPLOY_DIR" ]; then
  echo "❌ Deployment directory not found: $DEPLOY_DIR"
  exit 1
fi

cd "$DEPLOY_DIR"

echo "=== Starting production deployment ==="

echo "* Resetting repository to origin/main"
git fetch --depth=1 origin main
git reset --hard origin/main
git clean -fdx

echo "* Installing PHP dependencies"
composer install --no-dev --optimize-autoloader --prefer-dist --no-interaction
composer dump-autoload -o

echo "* Running database migrations"
php artisan migrate --force

echo "* Clearing and rebuilding caches"
php artisan optimize:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan event:cache || true

echo "* Building frontend assets"
if [ -f package.json ]; then
  npm ci --silent
  npm run build --silent
else
  echo "  - No package.json found, skipping frontend build"
fi

echo "* Restarting queue workers"
php artisan queue:restart || true

echo "* Setting file permissions"
find storage -type f -exec chmod 664 {} +
find storage -type d -exec chmod 775 {} +
find bootstrap/cache -type f -exec chmod 664 {} +
find bootstrap/cache -type d -exec chmod 775 {} +
chmod -R 775 storage bootstrap/cache

echo "=== Production deployment completed successfully ==="
