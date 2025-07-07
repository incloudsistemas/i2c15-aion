<?php

namespace App\Enums\Activities;

use App\Traits\EnumHelper;
use Filament\Support\Contracts\HasColor;
use Filament\Support\Contracts\HasLabel;

enum EmailStatusEnum: string implements HasLabel, HasColor
{
    use EnumHelper;

    case PENDING = '1';
    case SENT    = '2';
    case FAILED  = '0';

    public function getLabel(): string
    {
        return match ($this) {
            self::PENDING => 'Pendente',
            self::SENT    => 'Enviado',
            self::FAILED  => 'Falhou',
        };
    }

    public function getColor(): string
    {
        return match ($this) {
            self::PENDING => 'warning',
            self::SENT    => 'success',
            self::FAILED  => 'danger',
        };
    }
}
