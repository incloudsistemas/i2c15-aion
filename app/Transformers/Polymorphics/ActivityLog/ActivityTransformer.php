<?php

namespace App\Transformers\Polymorphics\ActivityLog;

use App\Enums\Activities\NoteRoleEnum;
use App\Enums\Activities\TaskPriorityEnum;
use App\Enums\Activities\TaskRoleEnum;
use Carbon\Carbon;
use Spatie\Activitylog\Models\Activity as ActivityLog;

class ActivityTransformer
{
    public function transform(ActivityLog $activityLog): array
    {
        $attrData = (array) $activityLog->getExtraProperty('attributes');
        $oldData  = (array) $activityLog->getExtraProperty('old');

        $type = $activityLog->log_name;


        $labels = match ($type) {
            'activity_notes'  => [
                'role'        => __('Tipo'),
                'subject'     => __('Assunto'),
                'body'        => __('Conteúdo'),
                'register_at' => __('Dt. registro'),
                'owner'       => __('Responsável'),
            ],
            'activity_emails' => [
                'subject'         => __('Assunto'),
                'sender_mail'     => __('Remetente'),
                'recipient_mails' => __('Destinatários'),
                'body'            => __('Conteúdo'),
                // 'status'          => __('Status'),
                'send_at'         => __('Dt. envio'),
                'owner'           => __('Responsável'),
            ],
            'activity_tasks' => [
                'role'              => __('Tipo'),
                'subject'           => __('Assunto'),
                'start_date'        => __('Dt. início'),
                'start_time'        => __('Hr. início'),
                'end_date'          => __('Dt. fim'),
                'end_time'          => __('Hr. fim'),
                'contacts'          => __('Contato(s)'),
                'users'             => __('Usuário(s)'),
                'body'              => __('Conteúdo'),
                'repeat_occurrence' => __('Ocorrências'),
                'repeat_frequency'  => __('Frequência'),
                'repeat_index'      => __('Índice'),
                'location'          => __('Local'),
                'priority'          => __('Prioridade'),
                'owner'             => __('Responsável'),
            ],
            default         => [
                //
            ],
        };

        $fmt = [
            'owner' => fn(mixed $value): ?string =>
            is_null($value) ? null : $value['name'],

            'role' => function (mixed $value) use ($type): ?string {
                if ($value === null) return null;

                return match ($type) {
                    'activity_notes' => NoteRoleEnum::tryFrom((string) $value)->getLabel(),
                    'activity_tasks' => TaskRoleEnum::tryFrom((string) $value)->getLabel(),
                    default          => $value,
                };
            },

            'register_at' => fn(mixed $value): ?string =>
            is_null($value) ? null : Carbon::parse($value)->format('d/m/Y H:i'),

            'recipient_mails' => fn(mixed $value): ?string =>
            is_null($value) ? null : implode(', ', $value),

            // 'status' => fn(mixed $value): ?string =>
            // is_null($value) ? null : EmailStatusEnum::tryFrom($value)->getLabel(),

            'send_at' => fn(mixed $value): ?string =>
            is_null($value) ? null : Carbon::parse($value)->format('d/m/Y H:i'),

            'start_date' => fn(mixed $value): ?string =>
            is_null($value) ? null : Carbon::parse($value)->format('d/m/Y'),

            'start_time' => fn(mixed $value): ?string =>
            is_null($value) ? null : Carbon::parse($value)->format('H:i'),

            'end_date' => fn(mixed $value): ?string =>
            is_null($value) ? null : Carbon::parse($value)->format('d/m/Y'),

            'end_time' => fn(mixed $value): ?string =>
            is_null($value) ? null : Carbon::parse($value)->format('H:i'),

            'contacts' => fn(mixed $value): ?string =>
            is_null($value) ? null : collect($value)->pluck('name')->filter()->implode(', '),

            'users' => fn(mixed $value): ?string =>
            is_null($value) ? null : collect($value)->pluck('name')->filter()->implode(', '),

            'priority' => fn(mixed $value): ?string =>
            is_null($value) ? null : TaskPriorityEnum::tryFrom($value)->getLabel(),
        ];

        $changes = [];
        foreach ($labels as $key => $label) {
            $attr = $attrData[$key] ?? data_get($attrData, "activityable.$key");
            $old  = $oldData[$key] ?? data_get($oldData, "activityable.$key");

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

        return ['changes' => $changes];
    }
}
