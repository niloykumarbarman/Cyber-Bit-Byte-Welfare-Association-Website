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

            DB::statement('CREATE TABLE gallery_items_new (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT,
                image TEXT,
                category TEXT,
                type TEXT,
                file TEXT,
                video_url TEXT,
                sort_order INTEGER DEFAULT 0,
                is_active INTEGER DEFAULT 1,
                created_at TEXT NULL,
                updated_at TEXT NULL
            )');

            DB::statement('INSERT INTO gallery_items_new (id, title, image, category, type, file, video_url, sort_order, is_active, created_at, updated_at)
                SELECT id, title, image, category, type, file, video_url, sort_order, is_active, created_at, updated_at
                FROM gallery_items');

            DB::statement('DROP TABLE gallery_items');
            DB::statement('ALTER TABLE gallery_items_new RENAME TO gallery_items');
            DB::statement('PRAGMA foreign_keys = ON');
        } else {
            Schema::table('gallery_items', function (Blueprint $table) {
                $table->string('image')->nullable()->change();
            });
        }
    }

    public function down(): void
    {
        $connection = Schema::getConnection()->getDriverName();

        if ($connection === 'sqlite') {
            DB::statement('PRAGMA foreign_keys = OFF');

            DB::statement('CREATE TABLE gallery_items_old (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT,
                image TEXT NOT NULL,
                category TEXT,
                type TEXT,
                file TEXT,
                video_url TEXT,
                sort_order INTEGER DEFAULT 0,
                is_active INTEGER DEFAULT 1,
                created_at TEXT NULL,
                updated_at TEXT NULL
            )');

            DB::statement('INSERT INTO gallery_items_old (id, title, image, category, type, file, video_url, sort_order, is_active, created_at, updated_at)
                SELECT id, title, COALESCE(image, ""), category, type, file, video_url, sort_order, is_active, created_at, updated_at
                FROM gallery_items');

            DB::statement('DROP TABLE gallery_items');
            DB::statement('ALTER TABLE gallery_items_old RENAME TO gallery_items');
            DB::statement('PRAGMA foreign_keys = ON');
        } else {
            Schema::table('gallery_items', function (Blueprint $table) {
                $table->string('image')->nullable(false)->change();
            });
        }
    }
};
