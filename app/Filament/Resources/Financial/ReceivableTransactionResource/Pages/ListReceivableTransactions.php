<?php

namespace App\Filament\Resources\Financial\ReceivableTransactionResource\Pages;

use App\Filament\Resources\Financial\ReceivableTransactionResource;
use App\Filament\Resources\Financial\TransactionResource\Pages\ListTransactions;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListReceivableTransactions extends ListTransactions
{
    protected static string $resource = ReceivableTransactionResource::class;
}
