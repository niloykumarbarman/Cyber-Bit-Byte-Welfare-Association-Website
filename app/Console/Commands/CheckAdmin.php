<?php

namespace App\Console\Commands;

use App\Models\User;
use Illuminate\Console\Command;

class CheckAdmin extends Command
{
    protected $signature = 'check:admin';
    protected $description = 'Check if admin user exists';

    public function handle(): int
    {
        $admin = User::where('email', 'admin@welfare.com')->first();
        
        if ($admin) {
            $this->info('✓ Admin user found!');
            $this->info('ID: ' . $admin->id);
            $this->info('Name: ' . $admin->name);
            $this->info('Email: ' . $admin->email);
            return 0;
        } else {
            $this->error('✗ Admin user NOT found');
            $this->info('Total users in database: ' . User::count());
            return 1;
        }
    }
}
