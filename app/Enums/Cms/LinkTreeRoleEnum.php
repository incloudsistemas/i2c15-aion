<?php

namespace App\Enums\Cms;

use App\Traits\EnumHelper;
use Filament\Support\Contracts\HasLabel;

enum LinkTreeRoleEnum: string implements HasLabel
{
    use EnumHelper;

    case DEFAULT = '1';
    case IMAGE   = '2';

    public function getLabel(): string
    {
        return match ($this) {
            self::DEFAULT => 'Padrão',
            self::IMAGE   => 'Imagem',
        };
    }
}
