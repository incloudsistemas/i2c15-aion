<?php

namespace App\Services\Financial;

use App\Models\Financial\Transaction;
use App\Models\System\Agency;
use App\Services\BaseService;
use App\Services\Polymorphics\ActivityLogService;
use Carbon\Carbon;
use Closure;
use Filament\Notifications\Notification;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Support\Facades\Storage;

class TransactionService extends BaseService
{
    public function __construct(protected Transaction $transaction)
    {
        parent::__construct();
    }

    public function getOptionsByAvailableYears(int $role): array
    {
        return $this->transaction->query()
            ->where('role', $role)
            ->selectRaw('YEAR(due_at) as year')
            ->distinct()
            ->orderBy('year', 'asc')
            ->pluck('year', 'year')
            ->toArray();
    }

    public function getInstallmentsData(
        int $numInstallments,
        ?string $price,
        string $dueDate,
        ?string $bankAccount,
        ?string $paymentMethod,
        ?string $name,
    ): array {
        $price = $price ?? 0;
        $price = ConvertPtBrFloatStringToInt(value: $price);

        // $installmentPrice = $price / $numInstallments;
        // $installmentPrice = round(floatval($installmentPrice) / 100, precision: 2);
        // $installmentPrice = number_format($installmentPrice, 2, ',', '.');

        $quotient = intdiv($price, $numInstallments);
        $remainder = $price % $numInstallments;

        $dueDate = Carbon::parse($dueDate);

        $newItems = [];

        for ($key = 0; $key < $numInstallments; $key++) {
            $idx = $key + 1;

            if ($dueDate && $key > 0) {
                $dueDate->modify('+1 month');
            }

            $installmentPrice = $quotient + ($key < $remainder ? 1 : 0);
            $installmentPrice = ConvertIntToFloat(value: $installmentPrice);
            $installmentPrice = number_format($installmentPrice, 2, ',', '.');

            $newItems[] = [
                // 'index'           => $idx,
                'price'           => $installmentPrice,
                'due_at'          => $dueDate->format('Y-m-d'),
                'bank_account_id' => $bankAccount,
                'payment_method'  => $paymentMethod,
                'name'            => $name
                // 'name'            => !empty($name) ? $name . " {$idx}/{$numInstallments}" : null
            ];
        }

        return $newItems;
    }

    public function recalculateInstallmentsPrice(
        ?string $state,
        ?string $totalPrice,
        array $installments,
        int $index,
    ): array {
        $totalPrice = ConvertPtBrFloatStringToInt(value: $totalPrice);

        $numInstallments = count($installments);

        // Rules for last installment change
        $isLastInstallment = ($index === ($numInstallments - 1));

        $paidSoFar = ConvertPtBrFloatStringToInt(value: $state);

        // Error: installment price is bigger than the total price
        if ($paidSoFar > $totalPrice) {
            $quotient = intdiv($totalPrice, $numInstallments);
            $remainder = $totalPrice % $numInstallments;

            for ($i = 0; $i < $numInstallments; $i++) {
                $value = $quotient + ($i < $remainder ? 1 : 0);
                $value = ConvertIntToFloat(value: $value);
                $installments[$i]['price'] = number_format($value, 2, ',', '.');
            }

            return $installments;
        }

        // Success: recalculating installments
        if ($index !== 0 && !$isLastInstallment) {
            $paidSoFar = 0;
            for ($key = 0; $key <= $index; $key++) {
                $installmentPrice = $installments[$key]['price'];
                $paidSoFar += ConvertPtBrFloatStringToInt(value: $installmentPrice);
            }
        }

        $remainingToPay = $totalPrice - $paidSoFar;

        $remainingInstallments = $isLastInstallment
            ? ($numInstallments - 1)
            : ($numInstallments - ($index + 1));

        if ($remainingInstallments > 0) {
            $baseInstallmentPrice = $remainingToPay / $remainingInstallments;
            $baseInstallmentPrice = round($baseInstallmentPrice);

            $diffInstallmentPrice = $remainingToPay - ($baseInstallmentPrice * ($remainingInstallments - 1));

            $start = $isLastInstallment ? 0 : ($index + 1);
            $end = $isLastInstallment ? ($numInstallments - 1) : $numInstallments;

            for ($key = $start; $key < $end; $key++) {
                $isFinalOfThatBlock = $isLastInstallment
                    ? ($key === $numInstallments - 2)
                    : ($key === $numInstallments - 1);

                $value = $isFinalOfThatBlock ? $diffInstallmentPrice : $baseInstallmentPrice;
                $value = ConvertIntToFloat(value: $value);
                $installments[$key]['price'] = number_format($value, 2, ',', '.');
            }
        }

        return $installments;
    }

    public function getFinalPrice(
        string $price,
        ?string $interest,
        ?string $fine,
        ?string $discount
    ): string {
        $price = ConvertPtBrFloatStringToInt(value: $price);

        $interest = $interest ?? 0;
        $interest = ConvertPtBrFloatStringToInt(value: $interest);

        $fine = $fine ?? 0;
        $fine = ConvertPtBrFloatStringToInt(value: $fine);

        $discount = $discount ?? 0;
        $discount = ConvertPtBrFloatStringToInt(value: $discount);

        $taxes = $taxes ?? 0;
        $taxes = ConvertPtBrFloatStringToInt(value: $taxes);

        // (price + interest + fine) - (discount + taxes)
        $finalPrice = ($price + $interest + $fine) - $discount;
        $finalPrice = ConvertIntToFloat(value: $finalPrice);
        $finalPrice = number_format($finalPrice, 2, ',', '.');

        return $finalPrice;
    }

    public function updateInstallmentsDataBySpecificField(
        string $field,
        string $state,
        array $installments
    ): array {
        $numInstallments = count($installments);

        if ($field === 'name') {
            for ($key = 0; $key < $numInstallments; $key++) {
                $idx = $key + 1;

                $installments[$key][$field] = $state . " {$idx}/{$numInstallments}";
            }

            return $installments;
        }

        if ($field === 'price') {
            $state = ConvertPtBrFloatStringToInt(value: $state);

            $quotient = intdiv($state, $numInstallments);
            $remainder = $state % $numInstallments;

            for ($key = 0; $key < $numInstallments; $key++) {
                $value = $quotient + ($key < $remainder ? 1 : 0);
                $value = ConvertIntToFloat(value: $value);
                $installments[$key][$field] = number_format($value, 2, ',', '.');
            }

            return $installments;
        }

        if ($field === 'due_at') {
            $state = Carbon::parse($state);

            for ($key = 0; $key < $numInstallments; $key++) {
                if ($state && $key > 0) {
                    $state->modify('+1 month');
                }

                $installments[$key][$field] = $state->format('Y-m-d');
            }

            return $installments;
        }

        for ($key = 0; $key < $numInstallments; $key++) {
            $installments[$key][$field] = $state;
        }

        return $installments;
    }

    public function validateInstallments(
        ?string $price,
        array $installments,
        string $attribute,
        Closure $fail
    ): void {
        $price = $price ?? 0;
        $price = ConvertPtBrFloatStringToInt(value: $price);

        $sumInstallments = collect($installments)
            ->map(
                fn(array $data): int =>
                ConvertPtBrFloatStringToInt(value: $data['price'])
            )
            ->sum();

        if ($price !== $sumInstallments) {
            $price = ConvertIntToFloat(value: $price);
            $price = number_format($price, 2, ',', '.');

            $sumInstallments = ConvertIntToFloat(value: $sumInstallments);
            $sumInstallments = number_format($sumInstallments, 2, ',', '.');

            $fail(
                __("O preço total (R$ {$price}), difere da soma das parcelas (R$ {$sumInstallments})."),
                ['attribute' => $attribute]
            );
        }
    }

    public function tableDefaultSort(Builder $query): Builder
    {
        return $query->orderBy('is_main', 'desc')
            ->orderBy('created_at', 'desc');
    }

    public function tableFilterByDefaultDate(Builder $query, array $data): Builder
    {
        $year = $data['year'] ?? now()->year;

        if (isset($data['interval']) && $data['interval'] !== 'custom') {
            return $query->whereMonth('due_at', $data['interval'])
                ->whereYear('due_at', $year);
        }

        if (isset($data['custom_interval'])) {
            return match ($data['custom_interval']) {
                'today'          => $query->whereDate('due_at', now()->toDateString()),
                'this_week'      => $query->whereBetween('due_at', [now()->startOfWeek(), now()->endOfWeek()]),
                'this_month'     => $query->whereMonth('due_at', now()->month)->whereYear('due_at', $year),
                'this_year'      => $query->whereYear('due_at', $year),
                'last_30_days'   => $query->whereBetween('due_at', [now()->subDays(30), now()]),
                'last_12_months' => $query->whereBetween('due_at', [now()->subMonths(12), now()]),
                default          => $query,
            };
        }

        return $query;
    }

    public function tableFilterIndicateUsingByDefaultDate(array $data): ?string
    {
        if (empty($data['interval'] ?? null)) {
            return null;
        }

        $customIntervalNames = [
            'today'          => __('Hoje'),
            'this_week'      => __('Esta semana'),
            'this_month'     => __('Este mês'),
            'this_year'      => __('Este ano'),
            'last_30_days'   => __('Últimos 30 dias'),
            'last_12_months' => __('Últimos 12 meses'),
        ];

        $monthNames = [
            1  => __('Janeiro'),
            2  => __('Fevereiro'),
            3  => __('Março'),
            4  => __('Abril'),
            5  => __('Maio'),
            6  => __('Junho'),
            7  => __('Julho'),
            8  => __('Agosto'),
            9  => __('Setembro'),
            10 => __('Outubro'),
            11 => __('Novembro'),
            12 => __('Dezembro'),
        ];

        if ($data['interval'] === 'custom') {
            return __('Customizado: ') . ($customIntervalNames[$data['custom_interval']] ?? __('Não especificado'));
        }

        return __('Mês: ') . ($monthNames[$data['interval']] ?? __('Não especificado'));
    }

    public function tableFilterByFinalPrice(Builder $query, array $data): Builder
    {
        if (empty($data['min_final_price'] ?? null) && empty($data['max_final_price'] ?? null)) {
            return $query;
        }

        $data['min_final_price'] = ConvertPtBrFloatStringToInt(value: $data['min_final_price']);
        $data['max_final_price'] = ConvertPtBrFloatStringToInt(value: $data['max_final_price']);

        return $query->when(
            $data['min_final_price'],
            fn(Builder $query, $finalPrice): Builder =>
            $query->where('final_price', '>=', $finalPrice),
        )
            ->when(
                $data['max_final_price'],
                fn(Builder $query, $finalPrice): Builder =>
                $query->where('final_price', '<=', $finalPrice),
            );
    }

    public function tableFilterIndicateUsingByFinalPrice(array $data): ?string
    {
        $min = $data['min_final_price'] ?? null;
        $max = $data['max_final_price'] ?? null;

        if (blank($min) && blank($max)) {
            return null;
        }

        $parts = [];
        if ($min && $max) {
            if ($min === $max) {
                $parts[] = __('Valor igual a: :value', ['value' => $min]);
            } else {
                $parts[] = __('Valor entre: :min e :max', [
                    'min' => $min,
                    'max' => $max
                ]);
            }
        } elseif ($min) {
            $parts[] = __('Valor (mín.): :value', ['value' => $min]);
        } elseif ($max) {
            $parts[] = __('Valor (máx.): :value', ['value' => $max]);
        }

        return implode(' | ', $parts);
    }

    public function getOptionsByAgenciesWhereHasTransaction(): array
    {
        return Agency::whereHas('bankAccounts', function (Builder $query): Builder {
            return $query->whereHas('financialTransactions');
        })
            ->pluck('name', 'id')
            ->toArray();
    }

    public function tableFilterByAgencies(Builder $query, array $data): Builder
    {
        if (empty($data['values'] ?? null)) {
            return $query;
        }

        return $query->whereHas('bankAccount', function (Builder $query) use ($data): Builder {
            return $query->whereHas('agency', function (Builder $query) use ($data): Builder {
                return $query->whereIn('id', $data['values']);
            });
        });
    }

    public function tableFilterByStatuses(Builder $query, array $data): Builder
    {
        if (empty($data['values'] ?? null)) {
            return $query;
        }

        $query->where(function (Builder $query) use ($data) {
            // 0 - Em aberto
            if (in_array(0, $data['values'])) {
                $query->orWhere(function (Builder $query): Builder {
                    return $query->whereNull('paid_at')
                        ->where('due_at', '>=', now());
                });
            }

            // 1 - Pago
            if (in_array(1, $data['values'])) {
                $query->orWhereNotNull('paid_at');
            }

            // 2 - Em atraso
            if (in_array(2, $data['values'])) {
                $query->orWhere(function (Builder $query): Builder {
                    return $query->whereNull('paid_at')
                        ->where('due_at', '<', now());
                });
            }
        });

        return $query;
    }

    public function tableFilterByPaidAt(Builder $query, array $data): Builder
    {
        if (empty($data['paid_from'] ?? null) && empty($data['paid_until'] ?? null)) {
            return $query;
        }

        return $query
            ->when(
                $data['paid_from'],
                function (Builder $query, $date) use ($data) {
                    if (empty($data['paid_until'])) {
                        return $query->whereDate('paid_at', '=', $date);
                    }

                    return $query->whereDate('paid_at', '>=', $date);
                }
            )
            ->when(
                $data['paid_until'],
                fn(Builder $query, $date): Builder =>
                $query->whereDate('paid_at', '<=', $date)
            );
    }

    public function tableFilterByDueAt(Builder $query, array $data): Builder
    {
        if (empty($data['due_from'] ?? null) && empty($data['due_until'] ?? null)) {
            return $query;
        }

        return $query
            ->when(
                $data['due_from'],
                function (Builder $query, $date) use ($data) {
                    if (empty($data['due_until'])) {
                        return $query->whereDate('due_at', '=', $date);
                    }

                    return $query->whereDate('due_at', '>=', $date);
                }
            )
            ->when(
                $data['due_until'],
                fn(Builder $query, $date): Builder =>
                $query->whereDate('due_at', '<=', $date)
            );
    }

    public function mutateRecordDataToEdit(Transaction $transaction, array $data): array
    {
        $data['price'] = $transaction->display_price;
        $data['interest'] = $transaction->display_interest;
        $data['fine'] = $transaction->display_fine;
        $data['discount'] = $transaction->display_discount;
        $data['taxes'] = $transaction->display_taxes;
        $data['final_price'] = $transaction->display_final_price;

        $data['change_scope'] = 1; // 1 - Somente a transação atual

        return $data;
    }

    public function mutateFormDataToEdit(Transaction $transaction, array $data): array
    {
        $transaction->load([
            'owner:id,name',
            'bankAccount:id,name',
            'contact:id,name',
            'business:id,name',
            'categories:id,name'
        ]);

        $data['_old_record'] = $transaction->replicate()
            ->toArray();

        $currentDueAt = Carbon::parse($transaction->getRawOriginal('due_at'));
        $newDueAt = Carbon::parse($data['due_at']);

        $interval = $currentDueAt->diff($newDueAt);
        $sign = $interval->invert ? -1 : 1;

        $data['due_at_offset']['years'] = $interval->y * $sign;
        $data['due_at_offset']['months'] = $interval->m * $sign;
        $data['due_at_offset']['days'] = $interval->d * $sign;

        return $data;
    }

    public function afterEditAction(Transaction $transaction, array $data): void
    {
        $this->syncCategories(transaction: $transaction, categories: $data['categories']);
        $this->createAttachments(transaction: $transaction, attachments: $data['attachments']);

        $this->logActivity(transaction: $transaction, oldRecord: $data['_old_record']);

        $changeScope = isset($data['change_scope']) ? (int) $data['change_scope'] : null;

        if (!$changeScope) {
            return;
        }

        switch ($changeScope) {
            case 2: // 2 - A transação atual e anteriores que não possuem baixas
                $transactions = $this->getPreviousTransactionsUnpaid(transaction: $transaction);
                break;
            case 3: // 3 - A transação atual e posteriores que não possuem baixas
                $transactions = $this->getFollowingTransactionsUnpaid(transaction: $transaction);
                break;
            case 4: // 4 - A transação atual e posteriores que não possuem baixas
                $transactions = $this->getAllTransactionsUnpaid(transaction: $transaction);
                break;
            case 5: // 5 - Todas as transações
                $transactions = $this->getAllTransactions(transaction: $transaction);
                break;
            default: // 1 - Somente a transação atual
                return;
        }

        $this->editTransactions(transactions: $transactions, data: $data);
    }

    protected function editTransactions(Collection $transactions, array $data): void
    {
        unset($data['due_at']);

        foreach ($transactions as $transaction) {
            $transaction->load([
                'owner:id,name',
                'bankAccount:id,name',
                'contact:id,name',
                'business:id,name',
                'categories:id,name'
            ]);

            $data['_old_record'] = $transaction->replicate()
                ->toArray();

            if (array_filter($data['due_at_offset'])) {
                $currentDueAt = Carbon::parse($transaction->getRawOriginal('due_at'));

                $data['due_at'] = $currentDueAt->addYears($data['due_at_offset']['years'])
                    ->addMonthsNoOverflow($data['due_at_offset']['months'])
                    ->addDays($data['due_at_offset']['days']);
            }

            $transaction->update($data);

            $this->syncCategories(transaction: $transaction, categories: $data['categories']);

            $this->logActivity(transaction: $transaction, oldRecord: $data['_old_record']);
        }
    }

    protected function syncCategories(Transaction $transaction, ?array $categories): void
    {
        if (empty($categories ?? null)) {
            $categories = [];
        }

        $transaction->categories()
            ->sync($categories);
    }

    protected function createAttachments(Transaction $transaction, ?array $attachments): void
    {
        if (empty($attachments ?? null)) {
            return;
        }

        foreach ($attachments as $attachment) {
            $filePath = Storage::disk('public')
                ->path($attachment);

            $transaction->addMedia($filePath)
                ->usingName(basename($attachment))
                ->toMediaCollection('attachments');
        }
    }

    protected function isTransactionCurrentCategoriesDifferent(Transaction $transaction): bool
    {
        $oldCategories = $this->oldTransaction->categories()
            ->pluck('id')
            ->sort()
            ->values();

        $currentCategories = $transaction->categories()
            ->pluck('id')
            ->sort()
            ->values();

        return $oldCategories->toJson() !== $currentCategories->toJson();
    }

    protected function logActivity(Transaction $transaction, array $oldRecord): void
    {
        // reload for nxn relationships
        $transaction->load([
            'owner:id,name',
            'bankAccount:id,name',
            'contact:id,name',
            'business:id,name',
            'categories:id,name'
        ]);

        $logService = app()->make(ActivityLogService::class);
        $logService->logUpdatedActivity(
            currentRecord: $transaction,
            oldRecord: $oldRecord,
            description: "Transação <b>{$transaction->name}</b> atualizada por <b>" . auth()->user()->name . "</b>",
            except: ['bank_account_id', 'contact_id', 'paid_at']
        );

        // Custom activity log
        $this->logContactChange(transaction: $transaction, oldRecord: $oldRecord);
        $this->logBankAccountChange(transaction: $transaction, oldRecord: $oldRecord);
        $this->logPaidAt(transaction: $transaction, oldRecord: $oldRecord);
    }

    protected function logContactChange(Transaction $transaction, array $oldRecord): void
    {
        $oldContact = $oldRecord['contact'];

        if ($oldContact['id'] === $transaction->contact_id) {
            return;
        }

        $attributes = [
            'contact' => [
                'id'   => $transaction->contact_id,
                'name' => $transaction->contact->name,
            ],
        ];

        $old = [
            'contact' => [
                'id'   => $oldContact['id'],
                'name' => $oldContact['name'],
            ],
        ];

        $description = "Novo contato <b>{$transaction->contact->name}</b> vinculado a transação <b>{$transaction->name}</b> por <b>" . auth()->user()->name . "</b>";

        $this->logCustomUpdatedActivity(
            transaction: $transaction,
            attributes: $attributes,
            old: $old,
            description: $description
        );
    }

    protected function logBankAccountChange(Transaction $transaction, array $oldRecord): void
    {
        $oldBankAccount = $oldRecord['bank_account'];

        if ($oldBankAccount['id'] === $transaction->bank_account_id) {
            return;
        }

        $attributes = [
            'bank_account' => [
                'id'   => $transaction->bank_account_id,
                'name' => $transaction->bankAccount->name,
            ],
        ];

        $old = [
            'bank_account' => [
                'id'   => $oldBankAccount['id'],
                'name' => $oldBankAccount['name'],
            ],
        ];

        $description = "Nova conta bancária <b>{$transaction->contact->name}</b> vinculada a transação <b>{$transaction->name}</b> por <b>" . auth()->user()->name . "</b>";

        $this->logCustomUpdatedActivity(
            transaction: $transaction,
            attributes: $attributes,
            old: $old,
            description: $description
        );
    }

    protected function logPaidAt(Transaction $transaction, array $oldRecord): void
    {
        if (!$transaction->paid_at || ($oldRecord['paid_at'] === $transaction->paid_at)) {
            return;
        }

        $attributes = [
            'paid_at' => $transaction->paid_at,
        ];

        $old = [
            'paid_at' => $oldRecord['paid_at'],
        ];

        $description = "Transação paga em <b>{$transaction->paid_at}</b> por <b>" . auth()->user()->name . "</b>";

        $this->logCustomUpdatedActivity(
            transaction: $transaction,
            attributes: $attributes,
            old: $old,
            description: $description
        );
    }

    protected function logCustomUpdatedActivity(Transaction $transaction, array $attributes, array $old, string $description): void
    {
        activity(MorphMapByClass(model: $transaction::class))
            ->performedOn($transaction)
            ->causedBy(auth()->user())
            ->event('updated')
            ->withProperties([
                'attributes' => $attributes,
                'old'        => $old,
            ])
            ->log($description);
    }

    public function afterDeleteAction(Transaction $transaction, array $data): void
    {
        $changeScope = isset($data['change_scope']) ? (int) $data['change_scope'] : null;

        if (!$changeScope) {
            return;
        }

        switch ($changeScope) {
            case 2: // 2 - A transação atual e anteriores que não possuem baixas
                $transactions = $this->getPreviousTransactionsUnpaid(transaction: $transaction);
                break;
            case 3: // 3 - A transação atual e posteriores que não possuem baixas
                $transactions = $this->getFollowingTransactionsUnpaid(transaction: $transaction);
                break;
            case 4: // 4 - A transação atual e posteriores que não possuem baixas
                $transactions = $this->getAllTransactionsUnpaid(transaction: $transaction);
                break;
            case 5: // 5 - Todas as transações
                $transactions = $this->getAllTransactions(transaction: $transaction);
                break;
            default: // 1 - Somente a transação atual
                return;
        }

        $this->deleteBulkAction(records: $transactions);
    }

    protected function getPreviousTransactionsUnpaid(Transaction $transaction): Collection
    {
        return $this->transaction->where('transaction_id', $transaction->transaction_id)
            ->where('id', '<>', $transaction->id)
            ->where('due_at', '<=', $transaction->due_at)
            ->whereNull('paid_at')
            ->get();
    }

    protected function getFollowingTransactionsUnpaid(Transaction $transaction): Collection
    {
        return $this->transaction->where('transaction_id', $transaction->transaction_id)
            ->where('id', '<>', $transaction->id)
            ->where('due_at', '>=', $transaction->due_at)
            ->whereNull('paid_at')
            ->get();
    }

    protected function getAllTransactionsUnpaid(Transaction $transaction): Collection
    {
        return $this->transaction->where('transaction_id', $transaction->transaction_id)
            ->where('id', '<>', $transaction->id)
            ->whereNull('paid_at')
            ->get();
    }

    protected function getAllTransactions(Transaction $transaction): Collection
    {
        return $this->transaction->where('transaction_id', $transaction->transaction_id)
            ->where('id', '<>', $transaction->id)
            ->get();
    }

    /**
     * $action can be:
     * Filament\Tables\Actions\DeleteAction;
     * Filament\Actions\DeleteAction;
     */
    public function preventDeleteIf($action, Transaction $transaction): void
    {
        $title = __('Ação proibida: Exclusão de transação');

        // if ($this->isAssignedToTransactions(category: $category)) {
        //     Notification::make()
        //         ->title($title)
        //         ->warning()
        //         ->body(__('Esta categoria possui transações financeiras associadas. Para excluir, você deve primeiro desvincular todas as transações que estão associados a ela.'))
        //         ->send();

        //     $action->halt();
        // }
    }

    public function deleteBulkAction(Collection $records): void
    {
        $blocked = [];
        $allowed = [];

        foreach ($records as $transaction) {
            // if ($this->isAssignedToTransactions(transaction: $transaction)) {
            //     $blocked[] = $transaction->name;
            //     continue;
            // }

            $allowed[] = $transaction;
        }

        if (!empty($blocked)) {
            $displayBlocked = array_slice($blocked, 0, 5);
            $extraCount = count($blocked) - 5;

            $message = __('As seguintes transações não podem ser excluídas: ') . implode(', ', $displayBlocked);

            if ($extraCount > 0) {
                $message .= " ... (+$extraCount " . __('outros') . ")";
            }

            Notification::make()
                ->title(__('Algumas transações não puderam ser excluídas'))
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

    // protected function isAssignedToTransactions(Transaction $transaction): bool
    // {
    //     return $transaction->financialTransactions()
    //         ->exists();
    // }
}
