<?php

namespace App\Filament\Resources\Crm\Business\BusinessResource\Pages;

use App\Filament\Resources\Crm\Business\BusinessResource;
use App\Models\Crm\Contacts\Contact;
use App\Models\Crm\Contacts\Role;
use App\Models\System\User;
use App\Services\Polymorphics\ActivityLogService;
use Filament\Actions;
use Filament\Resources\Pages\CreateRecord;

class CreateBusiness extends CreateRecord
{
    protected static string $resource = BusinessResource::class;

    protected function getRedirectUrl(): string
    {
        return $this->getResource()::getUrl('index');
    }

    protected function mutateFormDataBeforeCreate(array $data): array
    {
        $contact = Contact::findOrFail($data['contact_id']);
        $data['name'] = $data['name'] ?? $contact->name;

        $data['user_id'] = auth()->user()->id;

        return $data;
    }

    protected function afterCreate(): void
    {
        $this->attachBusinessCurrentUser();
        $this->createBusinessFunnelStage();
        $this->updateContactRolesToCustomer();

        $this->logActivity();
    }

    protected function attachBusinessCurrentUser(): void
    {
        $this->record->users()
            ->attach($this->data['current_user_id'], ['business_at' => $this->data['business_at']]);
    }

    protected function createBusinessFunnelStage(): void
    {
        $this->record->businessFunnelStages()
            ->create([
                'funnel_id'          => $this->data['funnel_id'],
                'funnel_stage_id'    => $this->data['funnel_stage_id'],
                'funnel_substage_id' => $this->data['funnel_substage_id'] ?? null,
                'loss_reason'        => $this->data['business_funnel_stage']['loss_reason'] ?? null,
                'business_at'        => $this->data['business_funnel_stage']['business_at'] ?? $this->data['business_at'],
            ]);
    }

    protected function updateContactRolesToCustomer(): void
    {
        $role = Role::find(3); // 3 - Cliente
        $businessProbability = $this->record->currentSubstage?->business_probability ?? 0;
        $contact = $this->record->contact;

        // Business won
        if ($role && $businessProbability === 100 && !$contact->roles->contains($role->id)) {
            $contact->roles()
                ->attach($role->id);
        }
    }

    protected function logActivity(): void
    {
        $funnel = $this->record->currentFunnel;
        $stage = $this->record->currentStage;
        $substage = $this->record->currentSubstage;

        $displayStage = $stage->name . ($substage ? " / {$substage->name}" : '');

        $this->record->load([
            'owner:id,name',
            'currentUserRelation:id,name',
            'contact:id,name',
            'funnel:id,name',
            'stage:id,name',
            'substage:id,name',
            'currentBusinessFunnelStageRelation',
            'source:id,name'
        ]);

        $logService = app()->make(ActivityLogService::class);
        $logService->logCreatedActivity(
            currentRecord: $this->record,
            description: "Novo negócio <b>{$this->record->name}</b> cadastrado em <b>{$funnel->name} / {$displayStage}</b> por <b>" . auth()->user()->name . "</b>"
        );

        // Custom activity log
        $this->logCurrentUserAssignment();
    }

    protected function logCurrentUserAssignment(): void
    {
        if ($this->record->user_id === $this->data['current_user_id']) {
            return;
        }

        $currentUser = User::find($this->data['current_user_id']);

        $attributes = [
            'current_user_id'      => $currentUser->id,
            'display_current_user' => $currentUser->name,
        ];

        $description = "Negócio <b>{$this->record->name}</b> atribuído a <b>{$currentUser->name}</b> por <b>" . auth()->user()->name . "</b>";

        $this->logCustomCreatedActivity(attributes: $attributes, description: $description);
    }

    protected function logCustomCreatedActivity(array $attributes, string $description): void
    {
        activity(MorphMapByClass(model: $this->record::class))
            ->performedOn($this->record)
            ->causedBy(auth()->user())
            ->event('created')
            ->withProperties([
                'attributes' => $attributes,
            ])
            ->log($description);
    }
}
