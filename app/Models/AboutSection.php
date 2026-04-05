<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AboutSection extends Model
{
    protected $fillable = [
        'title',
        'description',
        'image',
        'is_active',
        'sort_order',
    ];
}
