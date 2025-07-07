<?php

namespace App\Enums\Activities;

use App\Traits\EnumHelper;
use Filament\Support\Contracts\HasLabel;

enum NoteRoleEnum: string implements HasLabel
{
    use EnumHelper;

    case NOTE    = '1';
    case CALL    = '2';
    case MESSAGE = '3';

    public function getLabel(): string
    {
        return match ($this) {
            self::NOTE    => 'Observação',
            self::CALL    => 'Ligação',
            self::MESSAGE => 'Mensagem',
        };
    }
}
