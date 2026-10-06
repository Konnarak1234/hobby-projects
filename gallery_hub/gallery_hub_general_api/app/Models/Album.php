<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;

class Album extends Model
{
    //
     protected $fillable = [
        'uuid',
        'user_id',
        'title',
        'description',
        'location',
        'cover_image',
    ];
}
