<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Album extends Model
{
    //
     protected $fillable = [
        'user_id',
        'title',
        'description',
        'location',
        'cover_image',
    ];

    // this method will, let model handle creating specific field for themself
    // for example: id, created_at, updated_at
    // it run when Album->create(...) is called
    protected static function booted(): void
    {
        static::creating(function (Album $album) {
            $album->uuid ??= (string) Str::uuid();
        });
    }
}
