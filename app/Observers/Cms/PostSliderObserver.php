<?php

namespace App\Observers\Cms;

use App\Models\Cms\PostSlider;

class PostSliderObserver
{
    /**
     * Handle the PostSlider "created" event.
     */
    public function created(PostSlider $postSlider): void
    {
        //
    }

    /**
     * Handle the PostSlider "updated" event.
     */
    public function updated(PostSlider $postSlider): void
    {
        //
    }

    /**
     * Handle the PostSlider "deleted" event.
     */
    public function deleted(PostSlider $postSlider): void
    {
        //
    }

    /**
     * Handle the PostSlider "restored" event.
     */
    public function restored(PostSlider $postSlider): void
    {
        //
    }

    /**
     * Handle the PostSlider "force deleted" event.
     */
    public function forceDeleted(PostSlider $postSlider): void
    {
        //
    }
}
