<?php

namespace App\Traits;

use App\Models\Media;

trait HasMedia
{
    public function media()
    {
        return $this->morphMany(Media::class, 'mediable');
    }

    public function attachMedia($mediaId, $type = 'image')
    {
        return $this->media()->attach($mediaId, ['type' => $type]);
    }

    public function detachMedia($mediaId)
    {
        return $this->media()->detach($mediaId);
    }
}