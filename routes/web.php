<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Artisan;


// Main Home Page
Route::get('/', function () {
    return view('welcome');
});

// Final Fix Route to Clear Cache and Migrate Database
Route::get('/final-fix', function () {
    try {
        // 1. Clear All Application Cache
        Artisan::call('config:clear');
        Artisan::call('cache:clear');
        Artisan::call('view:clear');
        Artisan::call('route:clear');

        // 2. Run Database Migrations
        Artisan::call('migrate --force');

        return "<h1>Success!</h1> <p>Cache cleared and database migrated successfully. <a href='/'>Click here</a> to visit the site.</p>";
        
    } catch (\Exception $e) {
        // Return Error Message if something goes wrong
        return "<h1>Error!</h1> <p>Message: " . $e->getMessage() . "</p>";
    }
});