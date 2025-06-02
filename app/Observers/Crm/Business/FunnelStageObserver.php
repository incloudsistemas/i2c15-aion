<?php

namespace App\Observers\Crm\Business;

use App\Models\Crm\Business\FunnelStage;

class FunnelStageObserver
{
    /**
     * Handle the FunnelStage "created" event.
     */
    public function created(FunnelStage $funnelStage): void
    {
        //
    }

    /**
     * Handle the FunnelStage "updated" event.
     */
    public function updated(FunnelStage $funnelStage): void
    {
        //
    }

    /**
     * Handle the FunnelStage "deleted" event.
     */
    public function deleted(FunnelStage $funnelStage): void
    {
        //
    }

    /**
     * Handle the FunnelStage "restored" event.
     */
    public function restored(FunnelStage $funnelStage): void
    {
        //
    }

    /**
     * Handle the FunnelStage "force deleted" event.
     */
    public function forceDeleted(FunnelStage $funnelStage): void
    {
        //
    }
}
