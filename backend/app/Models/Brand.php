<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Brand extends Model
{
    use HasFactory;

    protected $fillable = ['name'];

    public function cameras(): HasMany
    {
        return $this->hasMany(Camera::class);
    }

    public function lenses(): HasMany
    {
        return $this->hasMany(Lens::class);
    }
}