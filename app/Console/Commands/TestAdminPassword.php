<?php

namespace App\Console\Commands;

use App\Models\User;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Hash;

class TestAdminPassword extends Command
{
    protected $signature = 'test:admin-password';
    protected $description = 'Test if admin password is correct';

    public function handle(): int
    {
        $admin = User::where('email', 'admin@welfare.com')->first();
        
        if (!$admin) {
            $this->error('Admin user not found!');
            return 1;
        }

        $password = 'admin@123456';
        
        $this->info('Testing password verification...');
        $this->info('Email: ' . $admin->email);
        $this->info('Stored hash: ' . substr($admin->password, 0, 50) . '...');
        
        if (Hash::check($password, $admin->password)) {
            $this->info('✓ Password verification: SUCCESS');
            $this->info('✓ Login with admin@welfare.com / admin@123456 will work');
            return 0;
        } else {
            $this->error('✗ Password verification: FAILED');
            $this->warn('Attempting to rehash password...');
            $admin->password = Hash::make($password);
            $admin->save();
            $this->info('✓ Password rehashed successfully');
            return 0;
        }
    }
}
