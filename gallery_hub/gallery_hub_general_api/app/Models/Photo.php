<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Str;

class Photo extends Model
{
    protected $fillable = [
        'title',
        'description',
        'file_path',
        'original_name',
        'mime_type',
        'file_size',
        'width',
        'height',
    ];
    
    protected static function booted(): void
    {
        static::creating(function (Photo $photo) {
            $photo->uuid ??= (string) Str::uuid();
        });
    }
    
    //
    public function album(): BelongsTo
    {
        return $this->belongsTo(Album::class);
    }
}
