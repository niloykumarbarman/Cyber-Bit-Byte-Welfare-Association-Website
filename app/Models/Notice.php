<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Notice extends Model
{
    protected $fillable = [
        'title',
        'details',
        'publish_date',
        'attachment',
    ];

    protected $casts = [
        'publish_date' => 'date',
    ];
}
