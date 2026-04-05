<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('gallery_items', function (Blueprint $table) {
            if (!Schema::hasColumn('gallery_items', 'type')) {
                $table->string('type')->nullable()->after('title');
            }
            if (!Schema::hasColumn('gallery_items', 'file')) {
                $table->string('file')->nullable()->after('type');
            }
            if (!Schema::hasColumn('gallery_items', 'video_url')) {
                $table->string('video_url')->nullable()->after('file');
            }
        });
    }

    public function down(): void
    {
        Schema::table('gallery_items', function (Blueprint $table) {
            if (Schema::hasColumn('gallery_items', 'video_url')) {
                $table->dropColumn('video_url');
            }
            if (Schema::hasColumn('gallery_items', 'file')) {
                $table->dropColumn('file');
            }
            if (Schema::hasColumn('gallery_items', 'type')) {
                $table->dropColumn('type');
            }
        });
    }
};
