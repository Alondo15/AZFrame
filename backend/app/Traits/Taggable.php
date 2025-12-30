<?php

namespace App\Traits;

use App\Models\Tag;

trait Taggable
{
    public function tags()
    {
        return $this->morphToMany(Tag::class, 'taggable');
    }

    public function tag($tagNames)
    {
        $tags = Tag::whereIn('name', (array)$tagNames)->get();
        $this->tags()->sync($tags);
    }

    public function untag($tagNames)
    {
        $tags = Tag::whereIn('name', (array)$tagNames)->get();
        $this->tags()->detach($tags);
    }
}