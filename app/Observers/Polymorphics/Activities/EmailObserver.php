<?php

namespace App\Observers\Polymorphics\Activities;

use App\Models\Polymorphics\Activities\Email;

class EmailObserver
{
    /**
     * Handle the Email "created" event.
     */
    public function created(Email $email): void
    {
        //
    }

    /**
     * Handle the Email "updated" event.
     */
    public function updated(Email $email): void
    {
        //
    }

    /**
     * Handle the Email "deleted" event.
     */
    public function deleted(Email $email): void
    {
        $email->activity->delete();
    }

    /**
     * Handle the Email "restored" event.
     */
    public function restored(Email $email): void
    {
        //
    }

    /**
     * Handle the Email "force deleted" event.
     */
    public function forceDeleted(Email $email): void
    {
        //
    }
}
