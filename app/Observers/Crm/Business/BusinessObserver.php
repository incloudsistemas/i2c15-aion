<?php

namespace App\Observers\Crm\Business;

use App\Models\Crm\Business\Business;
use App\Services\Polymorphics\ActivityLogService;

class BusinessObserver
{
    /**
     * Handle the Business "created" event.
     */
    public function created(Business $business): void
    {
        //
    }

    /**
     * Handle the Business "updated" event.
     */
    public function updated(Business $business): void
    {
        //
    }

    /**
     * Handle the Business "deleted" event.
     */
    public function deleted(Business $business): void
    {
        $business->load([
            'owner:id,name',
            'currentUserRelation:id,name',
            'contact:id,name',
            'funnel:id,name',
            'stage:id,name',
            'substage:id,name',
            // 'currentBusinessFunnelStageRelation',
            'source:id,name'
        ]);

        $logService = app()->make(ActivityLogService::class);
        $logService->logDeletedActivity(
            oldRecord: $business,
            description: "Negócio <b>{$business->name}</b> excluído por <b>" . auth()->user()->name . "</b>"
        );
    }

    /**
     * Handle the Business "restored" event.
     */
    public function restored(Business $business): void
    {
        //
    }

    /**
     * Handle the Business "force deleted" event.
     */
    public function forceDeleted(Business $business): void
    {
        //
    }
}
