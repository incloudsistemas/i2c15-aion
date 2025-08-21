<?php

namespace App\Filament\Resources\Financial\BankAccountResource\Pages;

use App\Filament\Resources\Financial\BankAccountResource;
use App\Models\Financial\BankAccount;
use App\Services\Financial\BankAccountService;
use Filament\Actions;
use Filament\Resources\Pages\ManageRecords;

class ManageBankAccounts extends ManageRecords
{
    protected static string $resource = BankAccountResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make()
             ->before(
                fn(BankAccountService $service, array $data) =>
                $service->beforeCreateAction(data: $data)
            )
            ->after(
                fn(BankAccountService $service, BankAccount $record, array $data) =>
                $service->afterCreateAction(bankAccount: $record, data: $data)
            ),
        ];
    }
}
