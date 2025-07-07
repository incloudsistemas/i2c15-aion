<?php

namespace App\Enums\Activities;

use App\Traits\EnumHelper;
use Filament\Support\Contracts\HasLabel;

enum TaskReminderFrequencyEnum: string implements HasLabel
{
    use EnumHelper;

    // case NONE                  = '0';
    case AT_DUE_TIME           = '1';
    case THIRTY_MINUTES_BEFORE = '2';
    case ONE_HOUR_BEFORE       = '3';
    case ONE_DAY_BEFORE        = '4';
    case ONE_WEEK_BEFORE       = '5';
    case CUSTOM_DATE           = '6';

    public function getLabel(): string
    {
        return match ($this) {
            // self::NONE                  => 'Nenhum lembrete',
            self::AT_DUE_TIME           => 'Na hora de vencimento da tarefa',
            self::THIRTY_MINUTES_BEFORE => '30 minutos antes',
            self::ONE_HOUR_BEFORE       => '1 hora antes',
            self::ONE_DAY_BEFORE        => '1 dia antes',
            self::ONE_WEEK_BEFORE       => '1 semana antes',
            self::CUSTOM_DATE           => 'Data personalizada',
        };
    }
}
