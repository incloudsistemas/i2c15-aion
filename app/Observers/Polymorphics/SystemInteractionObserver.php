<?php

namespace App\Observers\Polymorphics;

use App\Models\Polymorphics\SystemInteraction;

class SystemInteractionObserver
{
    /**
     * Handle the SystemInteraction "created" event.
     */
    public function created(SystemInteraction $systemInteraction): void
    {
        //
    }

    /**
     * Handle the SystemInteraction "updated" event.
     */
    public function updated(SystemInteraction $systemInteraction): void
    {
        //
    }

    /**
     * Handle the SystemInteraction "deleted" event.
     */
    public function deleted(SystemInteraction $systemInteraction): void
    {
        //
    }

    /**
     * Handle the SystemInteraction "restored" event.
     */
    public function restored(SystemInteraction $systemInteraction): void
    {
        //
    }

    /**
     * Handle the SystemInteraction "force deleted" event.
     */
    public function forceDeleted(SystemInteraction $systemInteraction): void
    {
        //
    }
}
