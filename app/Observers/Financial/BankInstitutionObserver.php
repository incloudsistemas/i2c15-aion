<?php

namespace App\Observers\Financial;

use App\Models\Financial\BankInstitution;

class BankInstitutionObserver
{
    /**
     * Handle the BankInstitution "created" event.
     */
    public function created(BankInstitution $bankInstitution): void
    {
        //
    }

    /**
     * Handle the BankInstitution "updated" event.
     */
    public function updated(BankInstitution $bankInstitution): void
    {
        //
    }

    /**
     * Handle the BankInstitution "deleted" event.
     */
    public function deleted(BankInstitution $bankInstitution): void
    {
        $deleted = '//deleted_' . md5(uniqid());

        $bankInstitution->code = $bankInstitution->code . $deleted;
        $bankInstitution->ispb = !empty($bankInstitution->ispb) ? $bankInstitution->ispb . $deleted : null;

        $bankInstitution->save();
    }

    /**
     * Handle the BankInstitution "restored" event.
     */
    public function restored(BankInstitution $bankInstitution): void
    {
        //
    }

    /**
     * Handle the BankInstitution "force deleted" event.
     */
    public function forceDeleted(BankInstitution $bankInstitution): void
    {
        //
    }
}
