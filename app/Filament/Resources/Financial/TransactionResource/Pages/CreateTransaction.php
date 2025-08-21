<?php

namespace App\Filament\Resources\Financial\TransactionResource\Pages;

use App\Filament\Resources\Financial\TransactionResource;
use App\Models\Financial\Transaction;
use App\Services\Polymorphics\ActivityLogService;
use Carbon\Carbon;
use Filament\Actions;
use Filament\Resources\Pages\CreateRecord;

abstract class CreateTransaction extends CreateRecord
{
    // protected static string $resource = TransactionResource::class;

    protected function getRedirectUrl(): string
    {
        return $this->getResource()::getUrl('index');
    }

    protected function mutateFormDataBeforeCreate(array $data): array
    {
        $this->data['user_id'] = auth()->user()->id;
        $this->data['final_price'] = $data['price'];

        // 1 - À vista
        if ((int) $data['repeat_payment'] === 1) {
            $this->data['repeat_occurrence'] = 1;
            $this->data['repeat_frequency'] = null;
        }

        return $data;
    }

    protected function handleRecordCreation(array $data): Transaction
    {
        match ((int) $data['repeat_payment']) {
            // 2 - Parcelado
            2 =>
            $record = $this->createInstallmentTransaction(),
            // 3 - Recorrente
            3 =>
            $record = $this->createRecurringTransaction(),
            // 1 - À vista
            default =>
            $record = $this->createInCashTransaction(),
        };

        return $record;
    }

    protected function createInCashTransaction(): Transaction
    {
        $transaction = Transaction::create($this->data);

        $this->attachCategories(record: $transaction);

        $this->logActivity(record: $transaction);

        return $transaction;
    }

    protected function createInstallmentTransaction(): Transaction
    {
        foreach ($this->data['installments'] as $key => $installment) {
            $installmentData = array_merge($installment, [
                'user_id'           => $this->data['user_id'],
                'contact_id'        => $this->data['contact_id'],
                'role'              => $this->data['role'],
                'repeat_frequency'  => $this->data['repeat_frequency'],
                'repeat_occurrence' => $this->data['repeat_occurrence'],
                'repeat_index'      => $key + 1,
                'final_price'       => $installment['price'],
            ]);

            if ($key === 0) {
                $firstTransaction = Transaction::create($installmentData);
                $firstTransaction->disableLogging()
                    ->update(['transaction_id' => $firstTransaction->id]);

                $this->attachCategories(record: $firstTransaction);

                $this->logActivity(record: $firstTransaction);

                continue;
            }

            $installmentData['transaction_id'] = $firstTransaction->id;
            $transaction = Transaction::create($installmentData);
            $this->attachCategories(record: $transaction);

            $this->logActivity(record: $transaction);
        }

        return $firstTransaction;
    }

    protected function createRecurringTransaction(): Transaction
    {
        $currentDueDate = Carbon::parse($this->data['due_at']);

        for ($key = 0; $key < $this->data['repeat_occurrence']; $key++) {
            $this->data['repeat_index'] = $key + 1;

            if ($key === 0) {
                $firstTransaction = Transaction::create($this->data);
                $firstTransaction->disableLogging()
                    ->update(['transaction_id' => $firstTransaction->id]);

                $this->attachCategories(record: $firstTransaction);

                $this->logActivity(record: $firstTransaction);

                continue;
            }

            $this->data['due_at'] = $this->calculateNextDates(
                frequency: (int) $this->data['repeat_frequency'],
                date: clone $currentDueDate,
                occurrence: $key
            );

            $this->data['transaction_id'] = $firstTransaction->id;
            $transaction = Transaction::create($this->data);
            $this->attachCategories(record: $transaction);

            $this->logActivity(record: $transaction);
        }

        return $firstTransaction;
    }

    protected function attachCategories(Transaction $record): void
    {
        $record->categories()
            ->attach($this->data['categories']);
    }

    protected function logActivity(Transaction $record): void
    {
        $record->load([
            'owner:id,name',
            'bankAccount:id,name',
            'contact:id,name',
            'business:id,name',
            'categories:id,name'
        ]);

        $logService = app()->make(ActivityLogService::class);
        $logService->logCreatedActivity(
            currentRecord: $record,
            description: "Nova transação <b>{$record->name}</b> cadastrada por <b>" . auth()->user()->name . "</b>"
        );
    }

    protected function calculateNextDates(int $frequency, Carbon $date, int $occurrence): string
    {
        $calculatedDate = clone $date;

        switch ($frequency) {
            case 1: // Diário
                $calculatedDate->addDays($occurrence);
                break;
            case 2: // Semanal
                $calculatedDate->addWeeks($occurrence);
                break;
            case 3: // Mensal
                $calculatedDate->addMonthsNoOverflow($occurrence);
                break;
            case 4: // Bimestral
                $calculatedDate->addMonthsNoOverflow(2 * $occurrence);
                break;
            case 5: // Trimestral
                $calculatedDate->addMonthsNoOverflow(3 * $occurrence);
                break;
            case 6: // Semestral
                $calculatedDate->addMonthsNoOverflow(6 * $occurrence);
                break;
            case 7: // Anual
                $calculatedDate->addYears($occurrence);
                break;
            case 8: // Dias úteis
                for ($i = 0; $i < $occurrence; $i++) {
                    $calculatedDate->addDay();
                    while ($calculatedDate->isWeekend()) {
                        $calculatedDate->addDay();
                    }
                }
                break;
        }

        return $calculatedDate->toDateString();
    }
}
