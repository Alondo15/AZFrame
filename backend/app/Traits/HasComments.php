<?php

namespace App\Traits;

use App\Models\Comment;

trait HasComments
{
    public function comments()
    {
        return $this->morphMany(Comment::class, 'commentable');
    }

    public function comment($data, $userId)
    {
        return $this->comments()->create([
            'user_id' => $userId,
            'content' => $data['content']
        ]);
    }
}