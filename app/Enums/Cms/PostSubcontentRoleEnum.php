<?php

namespace App\Enums\Cms;

use App\Traits\EnumHelper;
use Filament\Support\Contracts\HasLabel;

enum PostSubcontentRoleEnum: string implements HasLabel
{
    use EnumHelper;

    case TABS       = '1';
    case ACCORDIONS = '2';
    case FAQS       = '3';

    public function getLabel(): string
    {
        return match ($this) {
            self::TABS       => 'Abas',
            self::ACCORDIONS => 'Acordeões',
            self::FAQS       => 'Perguntas Frequentes',
        };
    }
}
