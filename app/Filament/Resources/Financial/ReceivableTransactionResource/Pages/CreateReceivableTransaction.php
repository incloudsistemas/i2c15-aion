<?php

namespace App\Filament\Resources\Financial\ReceivableTransactionResource\Pages;

use App\Filament\Resources\Financial\ReceivableTransactionResource;
use App\Filament\Resources\Financial\TransactionResource\Pages\CreateTransaction;
use Filament\Actions;
use Filament\Resources\Pages\CreateRecord;

class CreateReceivableTransaction extends CreateTransaction
{
    protected static string $resource = ReceivableTransactionResource::class;
}
