<?php

namespace App\Filament\Resources\System\AgencyResource\Pages;

use App\Filament\Resources\System\AgencyResource;
use App\Models\System\Agency;
use App\Services\System\AgencyService;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditAgency extends EditRecord
{
    protected static string $resource = AgencyResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make()
                ->before(
                    fn(AgencyService $service, Actions\DeleteAction $action, Agency $record) =>
                    $service->preventDeleteIf(action: $action, agency: $record)
                ),
        ];
    }

    protected function getRedirectUrl(): string
    {
        return $this->getResource()::getUrl('index');
    }

    protected function mutateFormDataBeforeFill(array $data): array
    {
        $data['users'] = $this->record->users()
            ->pluck('id')
            ->toArray();

        return $data;
    }

    protected function afterSave(): void
    {
        $this->syncLeaderUsers();
    }

    protected function syncLeaderUsers(): void
    {
        $this->record->users()
            ->sync($this->data['users']);
    }
}
