<?php

namespace App\Filament\Resources\Cms\RelationManagers;

use App\Models\Cms\Page;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class AccordionsRelationManager extends SubcontentsRelationManager
{
    // protected static string $relationship = 'subcontents';

    public static ?int $role = 2; // Accordions

    protected static ?string $title = 'Acordeões';

    protected static ?string $modelLabel = 'Acordeão';

    protected static function getGeneralInfosFormSection(): Forms\Components\Section
    {
        return Forms\Components\Section::make(__('Infos. Gerais'))
            ->description(__('Visão geral e informações fundamentais sobre a postagem.'))
            ->schema([
                static::getTitleFormField(),
                static::getSubtitleFormField(),
                static::getExcerptFormField(),
                static::getBodyFormField(),
                static::getCtaFormField(),
                static::getUrlFormField(),
                static::getIconFormField(),
                static::getEmbedVideoFormField(),
                static::getVideoFormField(),
                static::getImageFormField(),
            ])
            ->columns(2)
            ->collapsible();
    }

    protected static function getMediaFormSection(): Forms\Components\Section
    {
        return Forms\Components\Section::make(__('Galeria de Imagens e Vídeos'))
            ->description(__('Adicione e gerencie as mídias da postagem.'))
            ->schema([
                static::getImagesFormField(),
                static::getVideosFormField(),
                static::getEmbedVideosFormField(),
            ])
            ->columns(2)
            ->collapsible();
    }

    protected static function getAdditionalInfosFormSection(): Forms\Components\Section
    {
        return Forms\Components\Section::make(__('Infos. Complementares'))
            ->description(__('Forneça informações adicionais relevantes sobre a postagem.'))
            ->schema([
                static::getTagsFormField(),
                static::getDatesField(),
                static::getOrderFormField(),
                static::getStatusFormField(),
            ])
            ->columns(2)
            ->collapsible();
    }

    public static function canViewForRecord(Model $ownerRecord, string $pageClass): bool
    {
        if (MorphMapByClass(model: $ownerRecord::class) === MorphMapByClass(model: Page::class)) {
            return !in_array('accordions', $ownerRecord->settings) ? false : true;
        }

        return true;
    }
}
