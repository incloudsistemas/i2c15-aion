<?php

namespace App\Filament\Resources\System\AgencyResource\Pages;

use App\Filament\Resources\System\AgencyResource;
use Filament\Actions;
use Filament\Resources\Pages\CreateRecord;

class CreateAgency extends CreateRecord
{
    protected static string $resource = AgencyResource::class;

    protected function getRedirectUrl(): string
    {
        return $this->getResource()::getUrl('index');
    }

    protected function afterCreate(): void
    {
        $this->attachLeaderUsers();
    }

    protected function attachLeaderUsers(): void
    {
        $this->record->users()
            ->attach($this->data['users']);
    }
}
