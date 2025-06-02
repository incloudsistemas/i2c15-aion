<?php

namespace App\Observers\Crm\Funnels;

use App\Models\Crm\Funnels\FunnelSubstage;

class FunnelSubstageObserver
{
    /**
     * Handle the FunnelSubstage "created" event.
     */
    public function created(FunnelSubstage $funnelSubstage): void
    {
        //
    }

    /**
     * Handle the FunnelSubstage "updated" event.
     */
    public function updated(FunnelSubstage $funnelSubstage): void
    {
        //
    }

    /**
     * Handle the FunnelSubstage "deleted" event.
     */
    public function deleted(FunnelSubstage $funnelSubstage): void
    {
        $funnelSubstage->slug = $funnelSubstage->slug . '//deleted_' . md5(uniqid());
        $funnelSubstage->save();
    }

    /**
     * Handle the FunnelSubstage "restored" event.
     */
    public function restored(FunnelSubstage $funnelSubstage): void
    {
        //
    }

    /**
     * Handle the FunnelSubstage "force deleted" event.
     */
    public function forceDeleted(FunnelSubstage $funnelSubstage): void
    {
        //
    }
}
