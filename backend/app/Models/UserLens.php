<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class UserLens extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'lens_id',
        'usage_notes',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function lens(): BelongsTo
    {
        return $this->belongsTo(Lens::class);
    }
}