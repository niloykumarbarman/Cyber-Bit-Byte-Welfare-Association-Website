<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        $connection = Schema::getConnection()->getDriverName();

        if ($connection === 'sqlite') {
            DB::statement('PRAGMA foreign_keys = OFF');

            DB::statement('CREATE TABLE notices_new (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                details TEXT NULL,
                attachment TEXT NULL,
                publish_date TEXT NULL,
                is_active INTEGER DEFAULT 1,
                created_at TEXT NULL,
                updated_at TEXT NULL
            )');

            DB::statement('INSERT INTO notices_new (id, title, details, attachment, publish_date, is_active, created_at, updated_at)
                SELECT id, title, description, file, publish_date, is_active, created_at, updated_at
                FROM notices');

            DB::statement('DROP TABLE notices');
            DB::statement('ALTER TABLE notices_new RENAME TO notices');
            DB::statement('PRAGMA foreign_keys = ON');
        } else {
            Schema::table('notices', function (Blueprint $table) {
                $table->renameColumn('description', 'details');
                $table->renameColumn('file', 'attachment');
            });
        }
    }

    public function down(): void
    {
        $connection = Schema::getConnection()->getDriverName();

        if ($connection === 'sqlite') {
            DB::statement('PRAGMA foreign_keys = OFF');

            DB::statement('CREATE TABLE notices_old (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                description TEXT NULL,
                file TEXT NULL,
                publish_date TEXT NULL,
                is_active INTEGER DEFAULT 1,
                created_at TEXT NULL,
                updated_at TEXT NULL
            )');

            DB::statement('INSERT INTO notices_old (id, title, description, file, publish_date, is_active, created_at, updated_at)
                SELECT id, title, COALESCE(details, ""), attachment, publish_date, is_active, created_at, updated_at
                FROM notices');

            DB::statement('DROP TABLE notices');
            DB::statement('ALTER TABLE notices_old RENAME TO notices');
            DB::statement('PRAGMA foreign_keys = ON');
        } else {
            Schema::table('notices', function (Blueprint $table) {
                $table->renameColumn('details', 'description');
                $table->renameColumn('attachment', 'file');
            });
        }
    }
};
