<?php

use Illuminate\Support\Facades\Route;

Route::view('/', 'home')->name('home');
Route::view('/about', 'about')->name('about');
Route::view('/committee', 'committee')->name('committee');
Route::view('/members', 'members')->name('members');
Route::view('/gallery', 'gallery')->name('gallery');
Route::view('/notice', 'notice')->name('notice');
Route::view('/publications', 'publications')->name('publications');
Route::view('/contact', 'contact')->name('contact');

Route::get('/login', function () {
    return redirect('/admin/login');
})->name('login');
