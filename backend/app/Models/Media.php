<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Media extends Model
{
    use HasFactory;

    protected $fillable = [
        'type',
        'path',
        'thumbnail_path',
        'duration',
        'mime_type',
        'size',
    ];

    protected $casts = [
        'type' => 'string',
    ];
}