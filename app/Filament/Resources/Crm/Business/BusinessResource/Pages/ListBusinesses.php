<?php

namespace App\Filament\Resources\Crm\Business\BusinessResource\Pages;

use App\Filament\Resources\Crm\Business\BusinessResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListBusinesses extends ListRecords
{
    protected static string $resource = BusinessResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}
