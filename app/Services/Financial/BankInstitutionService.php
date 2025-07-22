<?php

namespace App\Services\Financial;

use App\Models\Financial\BankInstitution;
use App\Services\BaseService;
use Filament\Notifications\Notification;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Collection;

class BankInstitutionService extends BaseService
{
    public function __construct(protected BankInstitution $bankInstitution)
    {
        parent::__construct();
    }

    public function getQueryByBankInstitutions(Builder $query): Builder
    {
        return $query->byStatuses(statuses: [1]) // 1 - Ativo
            ->orderBy('name', 'asc');
    }

    public function getOptionsByBankInstitutions(): array
    {
        return $this->bankInstitution->byStatuses(statuses: [1]) // 1 - Ativo
            ->pluck('name', 'id')
            ->toArray();
    }

    /**
     * $action can be:
     * Filament\Tables\Actions\DeleteAction;
     * Filament\Actions\DeleteAction;
     */
    public function preventDeleteIf($action, BankInstitution $bankInstitution): void
    {
        $title = __('Ação proibida: Exclusão da instituição bancária');

        if ($this->isAssignedToBankAccount(bankInstitution: $bankInstitution)) {
            Notification::make()
                ->title($title)
                ->warning()
                ->body(__('Esta instituição possui contas bancárias associadas. Para excluir, você deve primeiro desvincular todas as contas que estão associados a ela.'))
                ->send();

            $action->halt();
        }
    }

    public function deleteBulkAction(Collection $records): void
    {
        $blocked = [];
        $allowed = [];

        foreach ($records as $bankInstitution) {
            if ($this->isAssignedToBankAccount(bankInstitution: $bankInstitution)) {
                $blocked[] = $bankInstitution->name;
                continue;
            }

            $allowed[] = $bankInstitution;
        }

        if (!empty($blocked)) {
            $displayBlocked = array_slice($blocked, 0, 5);
            $extraCount = count($blocked) - 5;

            $message = __('As seguintes instituições bancárias não podem ser excluídas: ') . implode(', ', $displayBlocked);

            if ($extraCount > 0) {
                $message .= " ... (+$extraCount " . __('outros') . ")";
            }

            Notification::make()
                ->title(__('Algumas instituições bancárias não puderam ser excluídas'))
                ->warning()
                ->body($message)
                ->send();
        }

        collect($allowed)->each->delete();

        if (!empty($allowed)) {
            Notification::make()
                ->title(__('Excluído'))
                ->success()
                ->send();
        }
    }

    protected function isAssignedToBankAccount(BankInstitution $bankInstitution): bool
    {
        return $bankInstitution->bankAccounts()
            ->exists();
    }
}
