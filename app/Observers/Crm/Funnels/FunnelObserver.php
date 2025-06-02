<?php

namespace App\Observers\Crm\Funnels;

use App\Models\Crm\Funnels\Funnel;

class FunnelObserver
{
    /**
     * Handle the Funnel "created" event.
     */
    public function created(Funnel $funnel): void
    {
        //
    }

    /**
     * Handle the Funnel "updated" event.
     */
    public function updated(Funnel $funnel): void
    {
        //
    }

    /**
     * Handle the Funnel "deleted" event.
     */
    public function deleted(Funnel $funnel): void
    {
        $funnel->slug = $funnel->slug . '//deleted_' . md5(uniqid());
        $funnel->save();
    }

    /**
     * Handle the Funnel "restored" event.
     */
    public function restored(Funnel $funnel): void
    {
        //
    }

    /**
     * Handle the Funnel "force deleted" event.
     */
    public function forceDeleted(Funnel $funnel): void
    {
        //
    }
}
