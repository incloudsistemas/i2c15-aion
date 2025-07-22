<?php

namespace App\Filament\Resources\Financial\PayableTransactionResource\Pages;

use App\Filament\Resources\Financial\PayableTransactionResource;
use App\Filament\Resources\Financial\TransactionResource\Pages\ListTransactions;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListPayableTransactions extends ListTransactions
{
    protected static string $resource = PayableTransactionResource::class;
}
