<?php

namespace App\Enums\Activities;

use App\Traits\EnumHelper;
use Filament\Support\Contracts\HasLabel;

enum TaskRoleEnum: string implements HasLabel
{
    use EnumHelper;

    case TASK    = '1';
    case MEETING = '2';

    public function getLabel(): string
    {
        return match ($this) {
            self::TASK    => 'Tarefa',
            self::MEETING => 'Reunião',
        };
    }
}
