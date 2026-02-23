<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ContactInfo extends Model
{
    protected $fillable = [
        'address',
        'email',
        'phone',
        'map_embed',
    ];
}
