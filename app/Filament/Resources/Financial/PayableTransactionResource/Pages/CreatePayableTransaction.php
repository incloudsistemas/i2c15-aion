<?php

namespace App\Filament\Resources\Financial\PayableTransactionResource\Pages;

use App\Filament\Resources\Financial\PayableTransactionResource;
use App\Filament\Resources\Financial\TransactionResource\Pages\CreateTransaction;
use Filament\Actions;
use Filament\Resources\Pages\CreateRecord;

class CreatePayableTransaction extends CreateTransaction
{
    protected static string $resource = PayableTransactionResource::class;
}
