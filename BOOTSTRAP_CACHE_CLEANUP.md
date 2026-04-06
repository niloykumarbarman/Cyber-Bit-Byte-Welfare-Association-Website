# Production Server Bootstrap Cache Cleanup & PHP Version Fix

## Problem on Production Server
The production server displays:
```
Fatal error: Uncaught RuntimeException: Composer detected issues in your platform: 
Your Composer dependencies require a PHP version ">= 8.3.0". 
You are running 8.2.29 in /home/cyberbit/welfare.cyberbitbyte.com/vendor/composer/platform_check.php on line 22
```

## Root Causes
1. **PHP Version Mismatch**: Server running PHP 8.2.29, dependencies require PHP 8.3+
2. **Stale Cache Files**: Old bootstrap/cache files from previous deploys

## Immediate Fix (Before Next Deployment)

### Step 1: Access Production Server via SSH
```bash
ssh -i your_key cyberbit@welfare.cyberbitbyte.com
```

### Step 2: Navigate to Project Directory
```bash
cd /home/cyberbit/welfare.cyberbitbyte.com
```

### Step 3: Clean Bootstrap Cache Folder
```bash
# Remove all PHP cache files from bootstrap/cache
rm -f bootstrap/cache/*.php

# Verify only .gitkeep and .gitignore remain
ls -la bootstrap/cache/
# Expected output:
# -rw-r--r--  1 www-data www-data    24 May  5 22:22 .gitignore
# -rw-r--r--  1 www-data www-data     6 Apr  6 13:20 .gitkeep
```

### Step 4: Clear All Laravel Caches
```bash
# Clear config, routes, and view caches
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan cache:clear
```

### Step 5: Check PHP Version
```bash
# See current PHP version
php -v

# Check if PHP 8.3 or 8.4 is available
php8.3 -v    # or
php8.4 -v
```

## Long-Term Fix (PHP Upgrade Required)

### Option A: Upgrade PHP to 8.3 or 8.4 (Recommended)
Contact your hosting provider to upgrade PHP to version 8.3 or later.

### Option B: Use PHP 8.3 Alias for Deployments
Update your composer/artisan commands to use PHP 8.3 if available:
```bash
# Temporary alias for current session
alias php='php8.3'

# Then run composer install and artisan commands
composer install --prefer-dist
php artisan optimize
```

### Option C: Modify Project Constraints (Fallback)
If you must stay on PHP 8.2.x, modify `composer.json`:
```json
{
    "require": {
        "php": "^8.2",  // Change from strict 8.3
        ...
    }
}
```

**WARNING**: Option C is not recommended as some newer packages may require PHP 8.3 features.

## Automated Fix via GitHub Actions

The deployment workflow has been updated to:
1. Detect PHP version on production
2. Use PHP 8.3/8.4 if available
3. Clean bootstrap/cache automatically
4. Validate bootstrap compatibility

**Next deployment will automatically:**
- Clean bootstrap/cache folder
- Remove all stale .php cache files
- Regenerate fresh caches with correct PHP version
- Validate the application loads correctly

## Manual Cleanup Commands Summary
```bash
# Complete cleanup sequence
cd /home/cyberbit/welfare.cyberbitbyte.com
rm -f bootstrap/cache/*.php
composer clear-cache
rm -rf vendor/
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan cache:clear

# If using PHP 8.3
php8.3 composer install --prefer-dist --no-dev --optimize-autoloader
php8.3 artisan optimize
```

## Bootstrap Cache Contents Reference
**Files that will be cleaned:**
- `config.php` - Cached configuration
- `routes-v7.php` - Cached routes  
- `services.php` - Cached services
- `packages.php` - Cached packages

**Files that will be preserved:**
- `.gitignore` - Git ignore file
- `.gitkeep` - Directory placeholder for version control

## Verification After Fix
```bash
# Verify login works
curl -X POST http://welfare.cyberbitbyte.com/admin/login \
  -d "email=admin@welfare.com&password=admin@123456"

# Check application health
curl http://welfare.cyberbitbyte.com/health

# Verify no errors in logs
tail -f storage/logs/laravel.log
```

---

**Status**: 
- ✅ Local development: Bootstrap/cache cleaned
- ✅ Deployment script: Updated to auto-clean bootstrap/cache
- ⏳ Production server: Manual cleanup required until PHP is upgraded
- 🔴 Critical: Upgrade PHP to 8.3+ for full compatibility
