<?php

namespace App\Filament\Resources\System\TeamResource\Pages;

use App\Filament\Resources\System\TeamResource;
use Filament\Actions;
use Filament\Resources\Pages\CreateRecord;

class CreateTeam extends CreateRecord
{
    protected static string $resource = TeamResource::class;

    protected function getRedirectUrl(): string
    {
        return $this->getResource()::getUrl('index');
    }

    protected function afterCreate(): void
    {
        $this->attachCoordinatorUsers();
        $this->attachCollaboratorUsers();
    }

    protected function attachCoordinatorUsers(): void
    {
        $data = collect($this->data['coordinators'])
            ->mapWithKeys(function ($id) {
                return [$id => ['role' => 1]]; // 1 - 'Líder/Leader ou Coordenador/Coordinator'
            })
            ->all();

        $this->record->coordinators()
            ->attach($data);
    }

    protected function attachCollaboratorUsers(): void
    {
        $data = collect($this->data['collaborators'])
            ->mapWithKeys(function ($id) {
                return [$id => ['role' => 2]]; // 2 - 'Colaborador/Collaborator'
            })
            ->all();

        $this->record->collaborators()
            ->attach($data);
    }
}
