<?php

namespace App\Filament\Resources\Cms\PartnerResource\Pages;

use App\Filament\Resources\Cms\PartnerResource;
use App\Models\Cms\Partner;
use App\Services\Cms\PartnerService;
use Filament\Actions;
use Filament\Resources\Pages\ManageRecords;

class ManagePartners extends ManageRecords
{
    protected static string $resource = PartnerResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make()
                ->after(
                    fn(PartnerService $service, Partner $record, array $data) =>
                    $service->afterCreateAction(partner: $record, data: $data)
                ),
        ];
    }
}
