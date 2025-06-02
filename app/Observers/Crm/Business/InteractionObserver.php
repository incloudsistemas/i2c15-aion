<?php

namespace App\Observers\Crm\Business;

use App\Models\Crm\Business\Interaction;

class InteractionObserver
{
    /**
     * Handle the Interaction "created" event.
     */
    public function created(Interaction $interaction): void
    {
        //
    }

    /**
     * Handle the Interaction "updated" event.
     */
    public function updated(Interaction $interaction): void
    {
        //
    }

    /**
     * Handle the Interaction "deleted" event.
     */
    public function deleted(Interaction $interaction): void
    {
        //
    }

    /**
     * Handle the Interaction "restored" event.
     */
    public function restored(Interaction $interaction): void
    {
        //
    }

    /**
     * Handle the Interaction "force deleted" event.
     */
    public function forceDeleted(Interaction $interaction): void
    {
        //
    }
}
