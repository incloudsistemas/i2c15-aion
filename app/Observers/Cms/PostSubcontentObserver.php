<?php

namespace App\Observers\Cms;

use App\Models\Cms\PostSubcontent;

class PostSubcontentObserver
{
    /**
     * Handle the PostSubcontent "created" event.
     */
    public function created(PostSubcontent $postSubcontent): void
    {
        //
    }

    /**
     * Handle the PostSubcontent "updated" event.
     */
    public function updated(PostSubcontent $postSubcontent): void
    {
        //
    }

    /**
     * Handle the PostSubcontent "deleted" event.
     */
    public function deleted(PostSubcontent $postSubcontent): void
    {
        //
    }

    /**
     * Handle the PostSubcontent "restored" event.
     */
    public function restored(PostSubcontent $postSubcontent): void
    {
        //
    }

    /**
     * Handle the PostSubcontent "force deleted" event.
     */
    public function forceDeleted(PostSubcontent $postSubcontent): void
    {
        //
    }
}
