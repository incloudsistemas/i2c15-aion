<?php

namespace App\Filament\Resources\Crm\Business\BusinessResource\Pages;

use App\Filament\Resources\Crm\Business\BusinessResource;
use App\Models\Crm\Business\Business;
use App\Models\Crm\Business\FunnelStage as BusinessFunnelStage;
use App\Models\Crm\Contacts\Contact;
use App\Models\Crm\Contacts\Role;
use App\Models\System\User;
use App\Services\Crm\Business\BusinessService;
use App\Services\Polymorphics\ActivityLogService;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditBusiness extends EditRecord
{
    protected static string $resource = BusinessResource::class;

    protected array $oldRecord;

    protected Contact $oldContact;

    protected User $oldUser;

    protected BusinessFunnelStage $oldBusinessFunnelStage;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make()
                ->before(
                    fn(BusinessService $service, Actions\DeleteAction $action, Business $record) =>
                    $service->preventDeleteIf(action: $action, business: $record)
                ),
        ];
    }

    protected function getRedirectUrl(): string
    {
        return $this->getResource()::getUrl('index');
    }

    protected function mutateFormDataBeforeFill(array $data): array
    {
        $data['business_funnel_stage']['loss_reason'] = $this->record->currentBusinessFunnelStage->loss_reason ?? null;
        $data['business_funnel_stage']['business_at'] = $this->record->currentBusinessFunnelStage->business_at ?? null;

        $data['current_user_id'] = $this->record->currentUser->id;

        return $data;
    }

    protected function mutateFormDataBeforeSave(array $data): array
    {
        $contact = Contact::findOrFail($data['contact_id']);
        $data['name'] = $data['name'] ?? $contact->name;

        return $data;
    }

    protected function beforeSave(): void
    {
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

        $this->oldRecord = $this->record->replicate()
            ->toArray();
    }

    protected function afterSave(): void
    {
        $this->syncBusinessCurrentUser();
        $this->updateBusinessFunnelStage();
        $this->updateContactRolesToCustomer();

        $this->logActivity();
    }

    protected function syncBusinessCurrentUser(): void
    {
        if ($this->isBusinessCurrentUserDifferent()) {
            $this->record->users()
                ->attach($this->data['current_user_id'], ['business_at' => now()]);
        }
    }

    protected function updateBusinessFunnelStage(): void
    {
        if ($this->isFunnelOrStagesDifferent()) {
            $this->record->businessFunnelStages()
                ->create([
                    'funnel_id'          => $this->data['funnel_id'],
                    'funnel_stage_id'    => $this->data['funnel_stage_id'],
                    'funnel_substage_id' => $this->data['funnel_substage_id'] ?? null,
                    'loss_reason'        => $this->data['business_funnel_stage']['loss_reason'] ?? null,
                    'business_at'        => $this->data['business_funnel_stage']['business_at'] ?? now(),
                ]);
        }
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
        $logService = app()->make(ActivityLogService::class);
        $logService->logUpdatedActivity(
            currentRecord: $this->record,
            oldRecord: $this->oldRecord,
            description: "Negócio <b>{$this->record->name}</b> atualizado por <b>" . auth()->user()->name . "</b>",
            except: ['funnel_id', 'funnel_stage_id', 'funnel_substage_id', 'contact_id']
        );

        // Custom activity log
        $this->logContactChange();
        $this->logFunnelStageChange();
        $this->logCurrentUserAssignment();
    }

    protected function logContactChange(): void
    {
        if (!$this->isBusinessContactDifferent()) {
            return;
        }

        $contact = Contact::find($this->data['contact_id']);
        $attributes = [
            'contact' => [
                'id'   => $contact->id,
                'name' => $contact->name,
            ],
        ];

        $oldContact = $this->oldRecord['contact'];
        $old = [
            'contact' => [
                'id'   => $oldContact['id'],
                'name' => $oldContact['name'],
            ],
        ];

        $description = "Novo contato <b>{$contact->name}</b> vinculado ao negócio <b>{$this->record->name}</b> por <b>" . auth()->user()->name . "</b>";

        $this->logCustomUpdatedActivity(attributes: $attributes, old: $old, description: $description);
    }

    protected function logFunnelStageChange(): void
    {
        if (!$this->isFunnelOrStagesDifferent()) {
            return;
        }

        $funnel = $this->record->currentFunnel;
        $stage = $this->record->currentStage;
        $substage = $this->record->currentSubstage;

        $attributes = [
            'funnel'      => [
                'id'   => $funnel->id,
                'name' => $funnel->name
            ],
            'stage'       => [
                'id'   => $stage->id,
                'name' => $stage->name
            ],
            'substage'    => [
                'id'   => $substage?->id,
                'name' => $substage?->name
            ],
            'loss_reason' => $this->record->currentBusinessFunnelStage->loss_reason,
            'business_at' => $this->record->currentBusinessFunnelStage->business_at,
        ];

        $oldBusinessFunnelStageId = $this->oldRecord['current_business_funnel_stage_relation']['id'];
        $oldBusinessFunnelStage = BusinessFunnelStage::find($oldBusinessFunnelStageId);
        $old = [
            'funnel'      => [
                'id'   => $oldBusinessFunnelStage->funnel->id,
                'name' => $oldBusinessFunnelStage->funnel->name
            ],
            'stage'       => [
                'id'   => $oldBusinessFunnelStage->stage->id,
                'name' => $oldBusinessFunnelStage->stage->name
            ],
            'substage'    => [
                'id'   => $oldBusinessFunnelStage->substage?->id,
                'name' => $oldBusinessFunnelStage->substage?->name
            ],
            'loss_reason' => $oldBusinessFunnelStage->loss_reason,
            'business_at' => $oldBusinessFunnelStage->business_at,
        ];

        $displayStage = $stage->name . ($substage ? " / {$substage->name}" : '');
        $description = "Etapa do negócio atualizada para <b>{$funnel->name} / {$displayStage}</b> por <b>" . auth()->user()->name . "</b>";

        $this->logCustomUpdatedActivity(attributes: $attributes, old: $old, description: $description);
    }

    protected function logCurrentUserAssignment(): void
    {
        if (!$this->isBusinessCurrentUserDifferent()) {
            return;
        }

        $currentUser = User::find($this->data['current_user_id']);
        $attributes = [
            'current_user_relation' => [
                [
                    'id'   => $currentUser->id,
                    'name' => $currentUser->name,
                ]
            ],
        ];

        $oldCurrentUser = $this->oldRecord['current_user_relation'][0];
        $old = [
            'current_user_relation' => [
                [
                    'id'   => $oldCurrentUser['id'],
                    'name' => $oldCurrentUser['name'],
                ]
            ],
        ];

        $description = "Negócio <b>{$this->record->name}</b> atribuído a <b>{$currentUser->name}</b> por <b>" . auth()->user()->name . "</b>";

        $this->logCustomUpdatedActivity(attributes: $attributes, old: $old, description: $description);
    }

    protected function isBusinessContactDifferent(): bool
    {
        $oldContact = $this->oldRecord['contact'];
        return $oldContact['id'] !== $this->data['contact_id'];
    }

    protected function isBusinessCurrentUserDifferent(): bool
    {
        $oldCurrentUser = $this->oldRecord['current_user_relation'][0];
        return $oldCurrentUser['id'] !== $this->data['current_user_id'];
    }

    protected function isFunnelOrStagesDifferent(): bool
    {
        $oldBusinessFunnelStage = $this->oldRecord['current_business_funnel_stage_relation'];
        return $oldBusinessFunnelStage['funnel_id'] !== $this->data['funnel_id']
            || $oldBusinessFunnelStage['funnel_stage_id'] !== $this->data['funnel_stage_id']
            || $oldBusinessFunnelStage['funnel_substage_id'] !== $this->data['funnel_substage_id'];
    }

    protected function logCustomUpdatedActivity(array $attributes, array $old, string $description): void
    {
        activity(MorphMapByClass(model: $this->record::class))
            ->performedOn($this->record)
            ->causedBy(auth()->user())
            ->event('updated')
            ->withProperties([
                'attributes' => $attributes,
                'old'        => $old,
            ])
            ->log($description);
    }
}
