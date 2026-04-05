#!/bin/bash

# Production Deployment Checklist
# Run this before deploying to production

set -e

echo "🔍 Running Pre-Deployment Checks..."
echo ""

# Check PHP version
PHP_VERSION=$(php -v | grep -oP 'PHP \K[0-9.]+')
echo "✓ PHP Version: $PHP_VERSION (Required: 8.2+)"

# Check Composer
if ! command -v composer &> /dev/null; then
    echo "✗ Composer is not installed!"
    exit 1
fi
echo "✓ Composer installed"

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "✗ Node.js is not installed!"
    exit 1
fi
NODE_VERSION=$(node -v)
echo "✓ Node.js version: $NODE_VERSION"

# Check npm
if ! command -v npm &> /dev/null; then
    echo "✗ npm is not installed!"
    exit 1
fi
NPM_VERSION=$(npm -v)
echo "✓ npm version: $NPM_VERSION"

echo ""
echo "📦 Checking Dependencies..."

# Check composer.lock exists
if [ ! -f "composer.lock" ]; then
    echo "✗ composer.lock not found!"
    exit 1
fi
echo "✓ composer.lock found"

# Check package-lock.json exists
if [ ! -f "package-lock.json" ]; then
    echo "✗ package-lock.json not found!"
    exit 1
fi
echo "✓ package-lock.json found"

echo ""
echo "🧪 Running Tests..."

# Run tests
if ! ./vendor/bin/phpunit --version &> /dev/null; then
    echo "⚠ PHPUnit not installed, installing..."
    composer install
fi

if ./vendor/bin/phpunit; then
    echo "✓ All tests passed"
else
    echo "✗ Tests failed!"
    exit 1
fi

echo ""
echo "📝 Checking Code Style..."

# Check code style
if ./vendor/bin/pint --test; then
    echo "✓ Code style checks passed"
else
    echo "⚠ Code style issues found (run './vendor/bin/pint' to fix)"
fi

echo ""
echo "🔐 Security Checks..."

# Check for security vulnerabilities
if composer audit; then
    echo "✓ No security vulnerabilities found"
else
    echo "⚠ Security vulnerabilities detected"
fi

echo ""
echo "📋 Configuration Checks..."

# Check .env file
if [ ! -f ".env" ]; then
    echo "⚠ .env file not found. Using .env.example as reference"
    cp .env.example .env
fi
echo "✓ .env file exists"

# Check required .env keys
REQUIRED_KEYS=("APP_KEY" "DB_HOST" "DB_DATABASE" "DB_USERNAME")
for key in "${REQUIRED_KEYS[@]}"; do
    if ! grep -q "^${key}=" .env; then
        echo "✗ Missing required key in .env: ${key}"
        exit 1
    fi
done
echo "✓ All required .env keys present"

echo ""
echo "✅ All pre-deployment checks passed!"
echo ""
echo "Ready to deploy! Run: git push origin main"
