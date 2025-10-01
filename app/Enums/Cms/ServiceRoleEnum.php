<?php

namespace App\Enums\Cms;

use App\Traits\EnumHelper;
use Filament\Support\Contracts\HasLabel;

enum ServiceRoleEnum: string implements HasLabel
{
    use EnumHelper;

    case DEFAULT = '1';

    public function getLabel(): string
    {
        return match ($this) {
            self::DEFAULT => 'Padrão',
        };
    }

    // public function getSlug(): string
    // {
    //     return match ($this) {
    //         self::DEFAULT => 'padrao',
    //     };
    // }
}
