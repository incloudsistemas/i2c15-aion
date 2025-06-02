<?php

namespace App\Filament\Resources\Crm\Funnels\FunnelResource\Pages;

use App\Filament\Resources\Crm\Funnels\FunnelResource;
use Filament\Actions;
use Filament\Resources\Pages\CreateRecord;

class CreateFunnel extends CreateRecord
{
    protected static string $resource = FunnelResource::class;

    protected function getRedirectUrl(): string
    {
        return $this->getResource()::getUrl('index');
    }

    protected function afterCreate(): void
    {
        $this->createClosingStages();
    }

    protected function createClosingStages(): void
    {
        $count = $this->record->stages()
            ->max('order');

        $this->data['closing_stages']['done']['order'] = $count + 1;
        $this->data['closing_stages']['lost']['order'] = $count + 2;

        $this->record->stages()
            ->createMany([
                $this->data['closing_stages']['done'],
                $this->data['closing_stages']['lost']
            ]);
    }
}
