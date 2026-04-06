<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

// Health check endpoint for automated monitoring
Route::get('/health', function () {
    try {
        // Check database connection
        \Illuminate\Support\Facades\DB::connection()->getPdo();
        
        return response()->json([
            'status' => 'ok',
            'timestamp' => now()->toIso8601String(),
            'app' => config('app.name'),
        ], 200);
    } catch (\Exception $e) {
        return response()->json([
            'status' => 'error',
            'message' => $e->getMessage(),
        ], 503);
    }
});

// Comprehensive diagnostic endpoint for troubleshooting
Route::get('/final-fix', function () {
    $diagnostics = [
        'php_version' => PHP_VERSION,
        'laravel_version' => \Illuminate\Foundation\Application::VERSION,
        'app_debug' => config('app.debug'),
        'app_env' => config('app.env'),
        'database' => [
            'connection' => config('database.default'),
            'status' => 'checking...'
        ],
        'bootstrap_app' => 'checking...',
        'admin_panel' => url('/admin'),
        'login_page' => url('/admin/login'),
        'timestamp' => now()->toIso8601String(),
    ];
    
    // Check database connection
    try {
        \Illuminate\Support\Facades\DB::connection()->getPdo();
        $diagnostics['database']['status'] = 'connected';
        
        // Check if admin user exists
        $adminUser = \App\Models\User::where('email', 'admin@welfare.com')->first();
        $diagnostics['admin_user'] = [
            'exists' => $adminUser ? true : false,
            'email' => 'admin@welfare.com',
        ];
    } catch (\Exception $e) {
        $diagnostics['database']['status'] = 'error: ' . $e->getMessage();
    }
    
    // Check bootstrap app
    try {
        $app = app();
        $diagnostics['bootstrap_app'] = 'loaded successfully';
        $diagnostics['application_ready'] = true;
    } catch (\Exception $e) {
        $diagnostics['bootstrap_app'] = 'error: ' . $e->getMessage();
        $diagnostics['application_ready'] = false;
    }
    
    // Check for cache files
    $bootstrapCacheFiles = [];
    $cacheDir = base_path('bootstrap/cache');
    if (is_dir($cacheDir)) {
        foreach (glob($cacheDir . '/*.php') as $file) {
            $bootstrapCacheFiles[] = basename($file);
        }
    }
    $diagnostics['bootstrap_cache_files'] = $bootstrapCacheFiles;
    
    return response()->json($diagnostics, 200, [], JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
});

