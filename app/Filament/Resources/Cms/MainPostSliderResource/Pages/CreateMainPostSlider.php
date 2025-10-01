<?php

namespace App\Filament\Resources\Cms\MainPostSliderResource\Pages;

use App\Filament\Resources\Cms\MainPostSliderResource;
use App\Models\Cms\Page;
use Filament\Actions;
use Filament\Resources\Pages\CreateRecord;
use Illuminate\Database\Eloquent\Builder;

class CreateMainPostSlider extends CreateRecord
{
    protected static string $resource = MainPostSliderResource::class;

    protected function getRedirectUrl(): string
    {
        return $this->getResource()::getUrl('index');
    }

    protected function mutateFormDataBeforeCreate(array $data): array
    {
        $idxPg = Page::whereHas('cmsPost', function (Builder $query): Builder {
            return $query->where('slug', 'index');
        })
            ->firstOrFail();

        $data['slideable_type'] = MorphMapByClass(model: Page::class);
        $data['slideable_id'] = $idxPg->id; // Index

        return $data;
    }
}
