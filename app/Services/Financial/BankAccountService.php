<?php

namespace App\Services\Financial;

use App\Models\Financial\BankAccount;
use App\Services\BaseService;
use Filament\Notifications\Notification;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Collection;

class BankAccountService extends BaseService
{
    public function __construct(protected BankAccount $bankAccount)
    {
        parent::__construct();
    }

    public function getTransactionDefaultBankAccount(): ?int
    {
        return $this->bankAccount->byStatuses(statuses: [1]) // 1 - Ativo
            ->where('is_main', 1)
            ->first()
            ?->id;
    }

    public function getQueryByBankAccounts(Builder $query): Builder
    {
        return $query->byStatuses(statuses: [1]); // 1 - Ativo
    }

    public function getOptionsByBankAccounts(): array
    {
        return $this->bankAccount->byStatuses(statuses: [1]) // 1 - Ativo
            ->pluck('name', 'id')
            ->toArray();
    }

    public function tableFilterByBalanceDate(Builder $query, array $data): Builder
    {
        if (!$data['balance_from'] && !$data['balance_until']) {
            return $query;
        }

        return $query
            ->when(
                $data['balance_from'],
                function (Builder $query, $date) use ($data) {
                    if (empty($data['balance_until'])) {
                        return $query->whereDate('balance_date', '=', $date);
                    }

                    return $query->whereDate('balance_date', '>=', $date);
                }
            )
            ->when(
                $data['balance_until'],
                fn(Builder $query, $date): Builder =>
                $query->whereDate('balance_date', '<=', $date)
            );
    }

    public function beforeCreateAction(array $data): void
    {
        if (isset($data['is_main']) && $data['is_main']) {
            $this->bankAccount->where('is_main', 1)
                ->update(['is_main' => 0]);
        }
    }

    public function mutateRecordDataToEdit(BankAccount $bankAccount, array $data): array
    {
        $data['balance'] = $bankAccount->display_balance ?? '0,00';

        return $data;
    }

    public function beforeEditAction(BankAccount $bankAccount, array $data): void
    {
        if (!$bankAccount->is_main && isset($data['is_main']) && $data['is_main']) {
            $this->bankAccount->where('is_main', 1)
                ->update(['is_main' => 0]);
        }
    }

    /**
     * $action can be:
     * Filament\Tables\Actions\DeleteAction;
     * Filament\Actions\DeleteAction;
     */
    public function preventDeleteIf($action, BankAccount $bankAccount): void
    {
        $title = __('Ação proibida: Exclusão de conta bancária');

        if ($this->isMainAccountDeletable(bankAccount: $bankAccount)) {
            Notification::make()
                ->title($title)
                ->warning()
                ->body(__('Não é possível excluir a conta bancária principal porque há outras contas cadastradas. Para excluir esta conta, você deve primeiro definir outra conta como principal.'))
                ->send();

            $action->halt();
        }

        if ($this->isAssignedToTransactions(bankAccount: $bankAccount)) {
            Notification::make()
                ->title($title)
                ->warning()
                ->body(__('Esta conta bancária possui transações financeiras associadas. Para excluir, você deve primeiro desvincular todas as transações que estão associados a ela.'))
                ->send();

            $action->halt();
        }
    }

    public function deleteBulkAction(Collection $records): void
    {
        $blocked = [];
        $allowed = [];

        foreach ($records as $bankAccount) {
            if (
                $this->isMainAccountDeletable(bankAccount: $bankAccount)
                || $this->isAssignedToTransactions(bankAccount: $bankAccount)
            ) {
                $blocked[] = $bankAccount->name;
                continue;
            }

            $allowed[] = $bankAccount;
        }

        if (!empty($blocked)) {
            $displayBlocked = array_slice($blocked, 0, 5);
            $extraCount = count($blocked) - 5;

            $message = __('As seguintes contas bancárias não podem ser excluídas: ') . implode(', ', $displayBlocked);

            if ($extraCount > 0) {
                $message .= " ... (+$extraCount " . __('outros') . ")";
            }

            Notification::make()
                ->title(__('Algumas contas bancárias não puderam ser excluídas'))
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

    protected function isMainAccountDeletable(BankAccount $bankAccount): bool
    {
        return $bankAccount->is_main && $this->bankAccount->count() > 1;
    }

    protected function isAssignedToTransactions(BankAccount $bankAccount): bool
    {
        return $bankAccount->financialTransactions()
            ->exists();
    }
}
