#!/bin/bash
cd /mnt/c/Users/UseR/Cyber-Bit-Byte-Welfare-Association-Website

# Test 1: Direct database check
echo "=== TEST 1: Database User Check ==="
sqlite3 database.sqlite "SELECT id, name, email, substr(password, 1, 30) as hash_preview FROM users WHERE email = 'admin@welfare.com';" 2>/dev/null || echo "SQLite not available, using PHP instead"

# Test 2: PHP artisan test
echo ""
echo "=== TEST 2: Full Authentication Test ==="
php artisan test:full-login 2>&1 | tail -20

# Test 3: Check if login page loads
echo ""
echo "=== TEST 3: Login Page Accessibility ==="
curl -s -w "\nStatus: %{http_code}\n" -o /dev/null http://localhost:8000/admin/login

# Test 4: Check server is running
echo ""
echo "=== TEST 4: Application Health ==="
curl -s http://localhost:8000/health 2>/dev/null | grep -q '"status":"ok"' && echo "✓ Server is healthy and responding" || echo "⚠ Server health check - check if running"
