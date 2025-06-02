<?php

namespace App\Observers\Crm\Funnels;

use App\Models\Crm\Funnels\FunnelStage;

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
        $funnelStage->slug = $funnelStage->slug . '//deleted_' . md5(uniqid());
        $funnelStage->save();
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
