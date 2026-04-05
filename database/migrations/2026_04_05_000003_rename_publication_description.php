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

            DB::statement('CREATE TABLE publications_new (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                details TEXT NULL,
                file TEXT NULL,
                publish_date TEXT NULL,
                is_active INTEGER DEFAULT 1,
                created_at TEXT NULL,
                updated_at TEXT NULL
            )');

            DB::statement('INSERT INTO publications_new (id, title, details, file, publish_date, is_active, created_at, updated_at)
                SELECT id, title, description, file, publish_date, is_active, created_at, updated_at
                FROM publications');

            DB::statement('DROP TABLE publications');
            DB::statement('ALTER TABLE publications_new RENAME TO publications');
            DB::statement('PRAGMA foreign_keys = ON');
        } else {
            Schema::table('publications', function (Blueprint $table) {
                $table->renameColumn('description', 'details');
            });
        }
    }

    public function down(): void
    {
        $connection = Schema::getConnection()->getDriverName();

        if ($connection === 'sqlite') {
            DB::statement('PRAGMA foreign_keys = OFF');

            DB::statement('CREATE TABLE publications_old (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                description TEXT NULL,
                file TEXT NULL,
                publish_date TEXT NULL,
                is_active INTEGER DEFAULT 1,
                created_at TEXT NULL,
                updated_at TEXT NULL
            )');

            DB::statement("INSERT INTO publications_old (id, title, description, file, publish_date, is_active, created_at, updated_at)
                SELECT id, title, COALESCE(details, ''), file, publish_date, is_active, created_at, updated_at
                FROM publications");

            DB::statement('DROP TABLE publications');
            DB::statement('ALTER TABLE publications_old RENAME TO publications');
            DB::statement('PRAGMA foreign_keys = ON');
        } else {
            Schema::table('publications', function (Blueprint $table) {
                $table->renameColumn('details', 'description');
            });
        }
    }
};
