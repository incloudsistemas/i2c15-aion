<?php

namespace App\Filament\Resources\System\TeamResource\Pages;

use App\Filament\Resources\System\TeamResource;
use App\Services\Polymorphics\ActivityLogService;
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

        $this->logActivity();
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

    protected function logActivity(): void
    {
        $this->record->load([
            'agency:id,name',
            'coordinators:id,name',
            'collaborators:id,name'
        ]);

        $logService = app()->make(ActivityLogService::class);
        $logService->logCreatedActivity(
            currentRecord: $this->record,
            description: "Nova equipe <b>{$this->record->name}</b> cadastrada por <b>" . auth()->user()->name . "</b>"
        );
    }
}
