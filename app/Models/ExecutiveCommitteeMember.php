<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ExecutiveCommitteeMember extends Model
{
    protected $fillable = [
        'name',
        'designation',
        'phone',
        'email',
        'photo',
        'sort_order',
    ];
}
