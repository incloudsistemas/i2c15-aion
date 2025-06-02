<?php

namespace App\Enums\Crm\Business;

use App\Traits\EnumHelper;
use Filament\Support\Contracts\HasLabel;

enum InteractionRoleEnum: string implements HasLabel
{
    use EnumHelper;

    case NOTE    = '1';
    case EMAIL   = '2';
    case CALL    = '3';
    case TASK    = '4';
    case MEETING = '5';

    public function getLabel(): string
    {
        return match ($this) {
            self::NOTE    => 'Observação',
            self::EMAIL   => 'Email',
            self::CALL    => 'Ligação',
            self::TASK    => 'Tarefa',
            self::MEETING => 'Reunião',
        };
    }
}
