<?php

namespace App\Enums\Cms;

use App\Traits\EnumHelper;
use Filament\Support\Contracts\HasLabel;

enum StoryRoleEnum: string implements HasLabel
{
    use EnumHelper;

    case IMAGE = '1';
    case VIDEO = '2';

    public function getLabel(): string
    {
        return match ($this) {
            self::IMAGE => 'Imagem',
            self::VIDEO => 'Vídeo',
        };
    }
}
