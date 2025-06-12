<?php

namespace App\Filament\Resources\Crm\Business\BusinessResource\Pages;

use App\Filament\Resources\Crm\Business\BusinessResource;
use App\Models\Crm\Business\Business;
use App\Models\Crm\Business\FunnelStage as BusinessFunnelStage;
use App\Models\Crm\Contacts\Contact;
use App\Models\Crm\Contacts\Role;
use App\Models\Crm\Funnels\Funnel;
use App\Models\Crm\Funnels\FunnelStage;
use App\Models\Crm\Funnels\FunnelSubstage;
use App\Services\Crm\Business\BusinessService;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditBusiness extends EditRecord
{
    protected static string $resource = BusinessResource::class;

    protected ?int $currentUserId = null;

    protected ?int $currentContactId = null;

    protected BusinessFunnelStage $currentBusinessFunnelStage;

    protected Funnel $funnel;

    protected FunnelStage $funnelStage;

    protected ?FunnelSubstage $funnelSubstage = null;

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
        $this->currentUserId = $this->record->currentUser->id;

        $this->currentContactId = $this->record->contact_id;

        $this->currentBusinessFunnelStage = $this->record->currentBusinessFunnelStage;

        $this->funnel = Funnel::findOrFail($this->data['funnel_id']);

        $this->funnelStage = FunnelStage::findOrFail($this->data['funnel_stage_id']);

        if ($this->data['funnel_substage_id']) {
            $this->funnelSubstage = FunnelSubstage::findOrFail($this->data['funnel_substage_id']);
        }
    }

    protected function afterSave(): void
    {
        $this->syncBusinessOwner();
        $this->updateBusinessFunnelStage();
        $this->updateBusinessActivity();
        $this->updateContactRolesToCustomer();
    }

    protected function syncBusinessOwner(): void
    {
        if ($this->isBusinessOwnerDifferent()) {
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

    protected function updateBusinessActivity(): void
    {
        $user = auth()->user();
        $userId = $user->id;
        $userName = $user->name;

        $descriptions = [];

        if ($this->isBusinessContactDifferent()) {
            $newContactName = $this->record->contact->name;
            $descriptions[] = "Novo contato {$newContactName} atribuído ao negócio por: {$userName}";
        }

        if ($this->isFunnelOrStagesDifferent()) {
            $newStepDesc = "Etapa do negócio atualizada por: {$userName} ⇒ {$this->funnel->name} / Etapa: {$this->funnelStage->name}";

            if ($this->funnelSubstage) {
                $newStepDesc .= " / Sub-etapa: {$this->funnelSubstage->name}";
            }

            $descriptions[] = $newStepDesc;
        }

        if ($this->isBusinessOwnerDifferent()) {
            $newOwnerName = $this->record->currentUser->name;
            $descriptions[] = "Novo usuário {$newOwnerName} atribuído ao negócio por: {$userName}";
        }

        foreach ($descriptions as $description) {
            $businessActivity = $this->record->activities()
                ->create();

            $businessActivity->activity()
                ->create([
                    'user_id'     => $userId,
                    'description' => $description,
                ]);
        }
    }

    protected function updateContactRolesToCustomer(): void
    {
        $role = Role::find(3); // 3 - Cliente
        $contact = $this->record->contact;

        // Business won
        if ($role && $this->funnelStage->business_probability === 100 && !$contact->roles->contains($role->id)) {
            $contact->roles()
                ->attach($role->id);
        }
    }

    protected function isBusinessOwnerDifferent(): bool
    {
        return $this->currentUserId !== $this->data['current_user_id'];
    }

    protected function isBusinessContactDifferent(): bool
    {
        return $this->currentContactId !== $this->data['contact_id'];
    }

    protected function isFunnelOrStagesDifferent(): bool
    {
        return $this->currentBusinessFunnelStage->funnel_id !== $this->data['funnel_id']
            || $this->currentBusinessFunnelStage->funnel_stage_id !== $this->data['funnel_stage_id']
            || $this->currentBusinessFunnelStage->funnel_substage_id !== $this->data['funnel_substage_id'];
    }
}
