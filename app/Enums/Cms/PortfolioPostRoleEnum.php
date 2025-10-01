<?php

namespace App\Enums\Cms;

use App\Traits\EnumHelper;
use Filament\Support\Contracts\HasLabel;

enum PortfolioPostRoleEnum: string implements HasLabel
{
    use EnumHelper;

    case IMAGE   = '1';
    case GALLERY = '2';
    case VIDEO   = '3';
    case CASE    = '4';

    public function getLabel(): string
    {
        return match ($this) {
            self::IMAGE   => 'Imagem',
            self::GALLERY => 'Galeria de Fotos e Vídeos',
            self::VIDEO   => 'Vídeo',
            self::CASE    => 'Case de Sucesso',
        };
    }

    public function getSlug(): string
    {
        return match ($this) {
            self::IMAGE   => 'imagem',
            self::GALLERY => 'galeria',
            self::VIDEO   => 'video',
            self::CASE    => 'case',
        };
    }
}
