<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Artisan;

Route::get('/', function () {
    return view('welcome');
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