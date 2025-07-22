<?php

namespace App\Filament\Resources\Financial\BankInstitutionResource\Pages;

use App\Filament\Resources\Financial\BankInstitutionResource;
use Filament\Actions;
use Filament\Resources\Pages\ManageRecords;

class ManageBankInstitutions extends ManageRecords
{
    protected static string $resource = BankInstitutionResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}
