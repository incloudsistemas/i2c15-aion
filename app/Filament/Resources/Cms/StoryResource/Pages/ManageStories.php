<?php

namespace App\Filament\Resources\Cms\StoryResource\Pages;

use App\Filament\Resources\Cms\StoryResource;
use App\Models\Cms\Story;
use App\Services\Cms\StoryService;
use Filament\Actions;
use Filament\Resources\Pages\ManageRecords;

class ManageStories extends ManageRecords
{
    protected static string $resource = StoryResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make()
                ->after(
                    fn(StoryService $service, Story $record, array $data) =>
                    $service->afterCreateAction(story: $record, data: $data)
                ),
        ];
    }
}
