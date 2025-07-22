<?php

namespace App\Observers\Financial;

use App\Models\Financial\BankAccount;

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
