#!/bin/bash

# First-Time Setup Script
# Run this once on your server to prepare for automated deployments

set -e

echo "════════════════════════════════════════════════════════════"
echo "  WELFARE WEBSITE - FIRST TIME SERVER SETUP"
echo "════════════════════════════════════════════════════════════"
echo ""

# Check if running as correct user
if [ "$USER" != "cyberbit" ]; then
    echo "❌ This script should be run as 'cyberbit' user"
    exit 1
fi

DEPLOY_DIR="/home/cyberbit/welfare.cyberbitbyte.com"

# Step 1: Create directories
echo "📁 Creating directories..."
mkdir -p "$DEPLOY_DIR"
mkdir -p /home/cyberbit/backups
mkdir -p /home/cyberbit/logs
echo "✓ Directories created"
echo ""

# Step 2: Clone repository
echo "📥 Cloning repository..."
if [ ! -d "$DEPLOY_DIR/.git" ]; then
    echo "Enter your GitHub repository URL (https://github.com/.../.git):"
    read REPO_URL
    git clone "$REPO_URL" "$DEPLOY_DIR"
else
    echo "✓ Repository already cloned"
fi
echo ""

# Step 3: Create .env file
echo "⚙️  Setting up .env file..."
if [ ! -f "$DEPLOY_DIR/.env" ]; then
    cp "$DEPLOY_DIR/.env.example" "$DEPLOY_DIR/.env"
    echo "⚠️  Please edit .env with your production settings:"
    echo "   nano $DEPLOY_DIR/.env"
    echo ""
    read -p "Press Enter after editing .env..."
else
    echo "✓ .env file already exists"
fi
echo ""

# Step 4: Install dependencies
echo "📦 Installing dependencies..."
cd "$DEPLOY_DIR"
composer install --no-dev --optimize-autoloader
npm ci
npm run build
echo "✓ Dependencies installed and built"
echo ""

# Step 5: Create database
echo "🗄️  Setting up database..."
read -p "Database name (default: welfare_database): " DB_NAME
DB_NAME=${DB_NAME:-welfare_database}

read -p "Database user (default: welfare_user): " DB_USER
DB_USER=${DB_USER:-welfare_user}

read -sp "Database password: " DB_PASSWORD
echo ""

# Create database and user
mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'127.0.0.1' IDENTIFIED BY '$DB_PASSWORD';
FLUSH PRIVILEGES;
EOF

echo "✓ Database created"
echo ""

# Step 6: Run migrations
echo "🔄 Running migrations..."
php artisan migrate --force
echo "✓ Migrations completed"
echo ""

# Step 7: Set permissions
echo "🔐 Setting file permissions..."
chmod -R 775 "$DEPLOY_DIR/storage" "$DEPLOY_DIR/bootstrap/cache"
sudo chown -R www-data:www-data "$DEPLOY_DIR"
echo "✓ Permissions set"
echo ""

# Step 8: Create cron jobs for backups
echo "⏰ Setting up backup cronjob..."
CRON_JOB="0 2 * * * $DEPLOY_DIR/scripts/backup-database.sh >> /var/log/backup.log 2>&1"

if ! crontab -l 2>/dev/null | grep -q "backup-database.sh"; then
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "✓ Backup cronjob added (daily at 2 AM)"
else
    echo "✓ Backup cronjob already exists"
fi
echo ""

# Step 9: Create log directory
echo "📝 Setting up logs..."
touch /var/log/backup.log
sudo chmod 666 /var/log/backup.log
echo "✓ Log files ready"
echo ""

# Step 10: Verify installation
echo "✅ Verifying installation..."
php artisan key:generate --force 2>/dev/null || true

if [ -f "$DEPLOY_DIR/.env" ] && [ -d "$DEPLOY_DIR/vendor" ]; then
    echo "✓ Installation verified"
else
    echo "❌ Installation may have issues - check logs"
fi
echo ""

echo "════════════════════════════════════════════════════════════"
echo "  ✅ SERVER SETUP COMPLETE!"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "Next steps:"
echo "1. Add GitHub Secrets (SSH_HOST, SSH_USER, SSH_KEY, SSH_PASSPHRASE, DB_HOST, DB_NAME, DB_USER, DB_PASSWORD)"
echo "2. Push changes to main branch: git push origin main"
echo "3. Monitor GitHub Actions: GitHub → Actions tab"
echo "4. Verify website is live"
echo ""
echo "Commands to check status:"
echo "  bash $DEPLOY_DIR/scripts/status.sh"
echo "  tail -f $DEPLOY_DIR/storage/logs/laravel.log"
echo "  ls -lh /home/cyberbit/backups/"
echo ""
