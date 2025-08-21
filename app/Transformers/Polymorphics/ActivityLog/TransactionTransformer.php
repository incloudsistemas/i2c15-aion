<?php

namespace App\Transformers\Polymorphics\ActivityLog;

use App\Enums\Financial\TransactionPaymentMethodEnum;
use App\Enums\Financial\TransactionRepeatFrequencyEnum;
use App\Enums\Financial\TransactionRepeatPaymentEnum;
use Carbon\Carbon;
use Spatie\Activitylog\Models\Activity as ActivityLog;

class TransactionTransformer
{
    public function transform(ActivityLog $activityLog): array
    {
        $attrData = (array) $activityLog->getExtraProperty('attributes');
        $oldData  = (array) $activityLog->getExtraProperty('old');

        $labels = [
            'due_at'            => __('Dt. vencimento'),
            'name'              => __('Transação'),
            'contact'           => __('Contato'),
            'bank_account'      => __('Conta bancária'),
            'payment_method'    => __('Método de pagamento'),
            'repeat_payment'    => __('Forma de pagamento'),
            'repeat_occurrence' => __('Ocorrências'),
            'repeat_frequency'  => __('Frequência'),
            'repeat_index'      => __('Índice'),
            'interest'          => __('Juros (R$)'),
            'fine'              => __('Multa (R$)'),
            'discount'          => __('Desconto (R$)'),
            'taxes'             => __('Taxas/impostos (R$)'),
            'final_price'       => __('Valor final (R$)'),
            'categories'        => __('Categorias'),
            'paid_at'           => __('Pago'),
            'owner'             => __('Responsável'),
            'created_at'        => __('Cadastro'),
        ];

        $fmt = [
            'due_at' => fn(mixed $value): ?string =>
            is_null($value) ? null : Carbon::parse($value)->format('d/m/Y'),

            'contact' => fn(mixed $value): ?string =>
            is_null($value) ? null : $value['name'],

            'payment_method' => fn(mixed $value): ?string =>
            is_null($value) ? null : TransactionPaymentMethodEnum::tryFrom((string) $value)->getLabel(),

            'repeat_payment' => fn(mixed $value): ?string =>
            is_null($value) ? null : TransactionRepeatPaymentEnum::tryFrom((string) $value)->getLabel(),

            'repeat_frequency' => fn(mixed $value): ?string =>
            is_null($value) ? null : TransactionRepeatFrequencyEnum::tryFrom((string) $value)->getLabel(),

            'interest' => fn(mixed $value): ?string =>
            is_null($value) ? null : number_format($value, 2, ',', '.'),

            'fine' => fn(mixed $value): ?string =>
            is_null($value) ? null : number_format($value, 2, ',', '.'),

            'discount' => fn(mixed $value): ?string =>
            is_null($value) ? null : number_format($value, 2, ',', '.'),

            'taxes' => fn(mixed $value): ?string =>
            is_null($value) ? null : number_format($value, 2, ',', '.'),

            'final_price' => fn(mixed $value): ?string =>
            is_null($value) ? null : number_format($value, 2, ',', '.'),

            'categories' => fn(mixed $value): ?string =>
            is_null($value) ? null : collect($value)->pluck('name')->filter()->implode(', '),

            'paid_at' => fn(mixed $value): ?string =>
            is_null($value) ? null : Carbon::parse($value)->format('d/m/Y'),

            'owner' => fn(mixed $value): ?string =>
            is_null($value) ? null : $value['name'],

            'created_at' => fn(mixed $value): ?string =>
            is_null($value) ? null : Carbon::parse($value)->format('d/m/Y'),
        ];

        $changes = [];
        foreach ($labels as $key => $label) {
            $attr = $attrData[$key] ?? null;
            $old  = $oldData[$key] ?? null;

            $display = $fmt[$key] ?? fn(mixed $value): ?string => $value;

            $attrDisplay = $display($attr);
            $oldDisplay = $display($old);

            if ($attrDisplay === null && $oldDisplay === null) {
                continue;
            }

            if ($attrDisplay === $oldDisplay) {
                continue;
            }

            $changes[] = [
                'label' => $label,
                'attr'  => $attrDisplay,
                'old'   => $oldDisplay,
            ];
        }

        return [
            'changes' => $changes
        ];
    }
}
