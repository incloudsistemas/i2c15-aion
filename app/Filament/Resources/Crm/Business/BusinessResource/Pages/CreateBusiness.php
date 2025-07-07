<?php

namespace App\Filament\Resources\Crm\Business\BusinessResource\Pages;

use App\Filament\Resources\Crm\Business\BusinessResource;
use App\Models\Crm\Business\Activity as BusinessActivity;
use App\Models\Crm\Contacts\Contact;
use App\Models\Crm\Contacts\Role;
use App\Models\Crm\Funnels\Funnel;
use App\Models\Crm\Funnels\FunnelStage;
use App\Models\Crm\Funnels\FunnelSubstage;
use Filament\Actions;
use Filament\Resources\Pages\CreateRecord;

class CreateBusiness extends CreateRecord
{
    protected static string $resource = BusinessResource::class;

    protected Funnel $funnel;

    protected FunnelStage $funnelStage;

    protected ?FunnelSubstage $funnelSubstage = null;

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

    protected function beforeCreate(): void
    {
        $this->funnel = Funnel::findOrFail($this->data['funnel_id']);
        $this->funnelStage = FunnelStage::findOrFail($this->data['funnel_stage_id']);

        if ($this->data['funnel_substage_id']) {
            $this->funnelSubstage = FunnelSubstage::findOrFail($this->data['funnel_substage_id']);
        }
    }

    protected function afterCreate(): void
    {
        $this->attachBusinessOwner();
        $this->createBusinessFunnelStage();
        $this->logBusinessSystemInteractions();
        $this->updateContactRolesToCustomer();
    }

    protected function attachBusinessOwner(): void
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

    protected function logBusinessSystemInteractions(): void
    {
        $user = auth()->user();

        $descriptions = [];

        $baseDesc = "Novo negócio criado por: {$user->name} ⇒ {$this->funnel->name} / Etapa: {$this->funnelStage->name}";

        if ($this->funnelSubstage) {
            $baseDesc .= " / Sub-etapa: {$this->funnelSubstage->name}";
        }

        $descriptions[] = $baseDesc;

        if ($user->id !== $this->data['current_user_id']) {
            $newOwnerName = $this->record->currentUser->name;
            $descriptions[] = "Novo negócio atribuído à {$newOwnerName} por: {$user->name}";
        }

        foreach ($descriptions as $description) {
            $this->record->systemInteractions()
                ->create([
                    'user_id'     => $user->id,
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
}
