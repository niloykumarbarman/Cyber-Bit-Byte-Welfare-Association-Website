<?php

namespace App\Console\Commands;

use App\Models\User;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;

class TestFullLogin extends Command
{
    protected $signature = 'test:full-login';
    protected $description = 'Test full login flow with email authentication';

    public function handle(): int
    {
        $this->info('=== TESTING FULL EMAIL LOGIN FLOW ===');
        $this->newLine();

        $email = 'admin@welfare.com';
        $password = 'admin@123456';

        // Step 1: Check user exists
        $this->info('Step 1: Checking if user exists...');
        $user = User::where('email', $email)->first();
        
        if (!$user) {
            $this->error('✗ User not found!');
            return 1;
        }
        $this->info('✓ User found: ' . $user->name);
        $this->newLine();

        // Step 2: Verify password
        $this->info('Step 2: Verifying password hash...');
        if (!Hash::check($password, $user->password)) {
            $this->error('✗ Password does not match!');
            return 1;
        }
        $this->info('✓ Password verification successful');
        $this->newLine();

        // Step 3: Test Guard authentication
        $this->info('Step 3: Testing auth guard...');
        if (Auth::guard('web')->attempt(['email' => $email, 'password' => $password])) {
            $this->info('✓ Authentication guard verified');
            Auth::guard('web')->logout();
        } else {
            $this->error('✗ Guard authentication failed!');
            return 1;
        }
        $this->newLine();

        // Step 4: Summary
        $this->info('=== LOGIN TEST SUMMARY ===');
        $this->line('✓ Email address: ' . $email);
        $this->line('✓ Password: ' . str_repeat('*', strlen($password)));
        $this->line('✓ User exists in database: YES');
        $this->line('✓ Password verification: PASSED');
        $this->line('✓ Auth guard: WORKING');
        $this->newLine();
        $this->info('✅ EMAIL AUTHENTICATION IS FULLY FUNCTIONAL');
        $this->info('✅ Users can log in to admin panel with email: ' . $email);

        return 0;
    }
}
