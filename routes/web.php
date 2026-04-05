<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Artisan;

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

// This route clears all cache and runs migrations to fix the 500 error
Route::get('/final-fix', function () {
    try {
        // Clear all configurations and cache
        Artisan::call('config:clear');
        Artisan::call('cache:clear');
        Artisan::call('view:clear');
        Artisan::call('route:clear');

        // Force the database migration
        Artisan::call('migrate --force');

        return "<h1>Success!</h1><p>Cache cleared and Database migrated. <a href='/'>Click here to see your site.</a></p>";
        
    } catch (\Exception $e) {
        // This will display the actual error message on screen
        return "<h1>Error Found:</h1><p>" . $e->getMessage() . "</p>";
    }
});