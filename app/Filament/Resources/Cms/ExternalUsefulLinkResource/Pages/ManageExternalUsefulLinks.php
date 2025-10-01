<?php

namespace App\Filament\Resources\Cms\ExternalUsefulLinkResource\Pages;

use App\Filament\Resources\Cms\ExternalUsefulLinkResource;
use App\Models\Cms\ExternalUsefulLink;
use App\Services\Cms\ExternalUsefulLinkService;
use Filament\Actions;
use Filament\Resources\Pages\ManageRecords;

class ManageExternalUsefulLinks extends ManageRecords
{
    protected static string $resource = ExternalUsefulLinkResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make()
                ->after(
                    fn(ExternalUsefulLinkService $service, ExternalUsefulLink $record, array $data) =>
                    $service->afterCreateAction(externalUsefulLink: $record, data: $data)
                ),
        ];
    }
}
