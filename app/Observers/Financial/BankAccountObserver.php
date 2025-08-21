<?php

namespace App\Observers\Financial;

use App\Models\Financial\BankAccount;
use App\Services\Polymorphics\ActivityLogService;

class BankAccountObserver
{
    /**
     * Handle the BankAccount "created" event.
     */
    public function created(BankAccount $bankAccount): void
    {
        //
    }

    /**
     * Handle the BankAccount "updated" event.
     */
    public function updated(BankAccount $bankAccount): void
    {
        //
    }

    /**
     * Handle the BankAccount "deleted" event.
     */
    public function deleted(BankAccount $bankAccount): void
    {
        $bankAccount->load([
            'bankInstitution:id,name',
            'agency:id,name',
        ]);

        $logService = app()->make(ActivityLogService::class);
        $logService->logDeletedActivity(
            oldRecord: $bankAccount,
            description: "Conta bancária <b>{$bankAccount->name}</b> excluído por <b>" . auth()->user()->name . "</b>"
        );

        $bankAccount->name = $bankAccount->name . '//deleted_' . md5(uniqid());
        $bankAccount->save();
    }

    /**
     * Handle the BankAccount "restored" event.
     */
    public function restored(BankAccount $bankAccount): void
    {
        //
    }

    /**
     * Handle the BankAccount "force deleted" event.
     */
    public function forceDeleted(BankAccount $bankAccount): void
    {
        //
    }
}
