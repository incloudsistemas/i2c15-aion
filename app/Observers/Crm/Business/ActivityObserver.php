<?php

namespace App\Observers\Crm\Business;

use App\Models\Crm\Business\Activity as BusinessActivity;

class ActivityObserver
{
    /**
     * Handle the Activity "created" event.
     */
    public function created(BusinessActivity $businessActivity): void
    {
        //
    }

    /**
     * Handle the Activity "updated" event.
     */
    public function updated(BusinessActivity $businessActivity): void
    {
        //
    }

    /**
     * Handle the Activity "deleted" event.
     */
    public function deleted(BusinessActivity $businessActivity): void
    {
        $businessActivity->activity->delete();
    }

    /**
     * Handle the Activity "restored" event.
     */
    public function restored(BusinessActivity $businessActivity): void
    {
        //
    }

    /**
     * Handle the Activity "force deleted" event.
     */
    public function forceDeleted(BusinessActivity $businessActivity): void
    {
        //
    }
}
