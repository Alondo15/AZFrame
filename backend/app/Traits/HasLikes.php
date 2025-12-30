<?php

namespace App\Traits;

use App\Models\Like;

trait HasLikes
{
    public function likes()
    {
        return $this->morphMany(Like::class, 'likeable');
    }

    public function like($userId)
    {
        return $this->likes()->firstOrCreate(['user_id' => $userId]);
    }

    public function unlike($userId)
    {
        return $this->likes()->where('user_id', $userId)->delete();
    }

    public function isLikedBy($userId)
    {
        return $this->likes()->where('user_id', $userId)->exists();
    }

    public function likesCount()
    {
        return $this->likes()->count();
    }
}