<?php

namespace App\Transformers\Polymorphics\ActivityLog;

use App\Enums\Crm\Business\PriorityEnum;
use Carbon\Carbon;
use Spatie\Activitylog\Models\Activity as ActivityLog;

class BusinessTransformer
{
    public function transform(ActivityLog $activityLog): array
    {
        $attrData = (array) $activityLog->getExtraProperty('attributes');
        $oldData  = (array) $activityLog->getExtraProperty('old');

        $labels = [
            'name'                  => __('Negócio'),
            'contact'               => __('Contato'),
            'funnel'                => __('Funil'),
            'stage'                 => __('Etapa do negócio'),
            'substage'              => __('Sub-etapa do negócio'),
            'price'                 => __('Valor (R$)'),
            'description'           => __('Descrição'),
            'priority'              => __('Prioridade'),
            'source'                => __('Origem da captação'),
            'current_user_relation' => __('Responsável'),
            'owner'                 => __('Captador'),
            'business_at'           => __('Dt. competência'),
        ];

        $fmt = [
            'contact' => fn(mixed $value): ?string =>
            is_null($value) ? null : $value['name'],

            'funnel' => fn(mixed $value): ?string =>
            is_null($value) ? null : $value['name'],

            'stage' => fn(mixed $value): ?string =>
            is_null($value) ? null : $value['name'],

            'substage' => fn(mixed $value): ?string =>
            is_null($value) ? null : $value['name'],

            'price' => fn(mixed $value): ?string =>
            is_null($value) ? null : number_format($value, 2, ',', '.'),

            'priority' => fn(mixed $value): ?string =>
            is_null($value) ? null : PriorityEnum::tryFrom((string) $value)->getLabel(),

            'source' => fn(mixed $value): ?string =>
            is_null($value) ? null : $value['name'],

            'current_user_relation' => fn(mixed $value): ?string =>
            is_null($value) ? null : $value[0]['name'],

            'owner' => fn(mixed $value): ?string =>
            is_null($value) ? null : $value['name'],

            'business_at' => fn(mixed $value): ?string =>
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
