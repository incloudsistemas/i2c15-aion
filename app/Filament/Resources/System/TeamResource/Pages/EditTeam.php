<?php

namespace App\Filament\Resources\System\TeamResource\Pages;

use App\Filament\Resources\System\TeamResource;
use App\Models\System\Team;
use App\Services\System\TeamService;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditTeam extends EditRecord
{
    protected static string $resource = TeamResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make()
                ->before(
                    fn(TeamService $service, Actions\DeleteAction $action, Team $record) =>
                    $service->preventDeleteIf(action: $action, team: $record)
                ),
        ];
    }

    protected function getRedirectUrl(): string
    {
        return $this->getResource()::getUrl('index');
    }

    protected function mutateFormDataBeforeFill(array $data): array
    {
        $data['coordinators'] = $this->record->coordinators()
            ->pluck('id')
            ->toArray();

        $data['collaborators'] = $this->record->collaborators()
            ->pluck('id')
            ->toArray();

        return $data;
    }

    protected function afterSave(): void
    {
        $this->syncCoordinatorUsers();
        $this->syncCollaboratorUsers();
    }

    protected function syncCoordinatorUsers(): void
    {
        $data = collect($this->data['coordinators'])
            ->mapWithKeys(function (int $id): array {
                return [$id => ['role' => 1]]; // 1 - 'Líder/Leader ou Coordenador/Coordinator'
            })
            ->all();

        $this->record->coordinators()
            ->sync($data);
    }

    protected function syncCollaboratorUsers(): void
    {
        $data = collect($this->data['collaborators'])
            ->mapWithKeys(function (int $id): array {
                return [$id => ['role' => 2]]; // 2 - 'Colaborador/Collaborator'
            })
            ->all();

        $this->record->collaborators()
            ->sync($data);
    }
}
