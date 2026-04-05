<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class AdminUserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Create admin user if it doesn't exist
        $admin = User::where('email', 'admin@welfare.com')->first();

        if (!$admin) {
            User::create([
                'name' => 'Admin User',
                'email' => 'admin@welfare.com',
                'password' => Hash::make('admin@123456'), // Change this after first login
                'email_verified_at' => now(),
            ]);

            $this->command->info('Admin user created successfully!');
            $this->command->warn('Email: admin@welfare.com');
            $this->command->warn('Password: admin@123456');
            $this->command->warn('⚠️  Please change the password after first login!');
        } else {
            $this->command->info('Admin user already exists!');
        }
    }
}
