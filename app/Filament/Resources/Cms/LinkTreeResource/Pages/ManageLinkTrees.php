<?php

namespace App\Filament\Resources\Cms\LinkTreeResource\Pages;

use App\Filament\Resources\Cms\LinkTreeResource;
use App\Models\Cms\LinkTree;
use App\Services\Cms\LinkTreeService;
use Filament\Actions;
use Filament\Resources\Pages\ManageRecords;

class ManageLinkTrees extends ManageRecords
{
    protected static string $resource = LinkTreeResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make()
                ->after(
                    fn(LinkTreeService $service, LinkTree $record, array $data) =>
                    $service->afterCreateAction(linkTree: $record, data: $data)
                ),
        ];
    }
}
