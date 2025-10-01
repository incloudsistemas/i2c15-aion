<?php

namespace App\Filament\Resources\Cms\MainPostSliderResource\Pages;

use App\Filament\Resources\Cms\MainPostSliderResource;
use App\Models\Cms\PostSlider;
use App\Services\Cms\PostSliderService;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditMainPostSlider extends EditRecord
{
    protected static string $resource = MainPostSliderResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make()
                ->before(
                    fn(PostSliderService $service, Actions\DeleteAction $action, PostSlider $record) =>
                    $service->preventDeleteIf(action: $action, postSlider: $record),
                ),
        ];
    }

    protected function getRedirectUrl(): string
    {
        return $this->getResource()::getUrl('index');
    }
}
