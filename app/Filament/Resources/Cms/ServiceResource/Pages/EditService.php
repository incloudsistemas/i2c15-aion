<?php

namespace App\Filament\Resources\Cms\ServiceResource\Pages;

use App\Filament\Resources\Cms\ServiceResource;
use App\Models\Cms\Service;
use App\Services\Cms\PostService;
use App\Services\Cms\ServicePostService;
use App\Services\Polymorphics\ActivityLogService;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditService extends EditRecord
{
    protected static string $resource = ServiceResource::class;

    protected array $oldRecord;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make()
                ->before(
                    fn(ServicePostService $service, Actions\DeleteAction $action, Service $record) =>
                    $service->preventDeleteIf(action: $action, service: $record),
                ),
        ];
    }

    protected function getRedirectUrl(): string
    {
        return $this->getResource()::getUrl('index');
    }

    protected function mutateFormDataBeforeFill(array $data): array
    {
        $postService = app(PostService::class);
        $data['cms_post'] = $postService->getPostData(post: $this->record->cmsPost);

        return $data;
    }

    protected function beforeSave(): void
    {
        $this->record->load([
            'cmsPost',
            'cmsPost.owner:id,name',
            'cmsPost.postCategories:id,name',
            'sliders:id,title',
            'subcontents:id,title',
        ]);

        $this->oldRecord = $this->record->replicate()
            ->toArray();
    }

    protected function afterSave(): void
    {
        $this->updateCmsPost();
        $this->syncCategories();

        $this->logActivity();
    }

    protected function updateCmsPost(): void
    {
        $this->record->cmsPost->update($this->data['cms_post']);
    }

    protected function syncCategories(): void
    {
        $this->record->cmsPost->postCategories()
            ->sync($this->data['cms_post']['categories']);
    }

    protected function logActivity(): void
    {
        $this->record->load([
            'cmsPost',
            'cmsPost.owner:id,name',
            'cmsPost.postCategories:id,name',
            'sliders:id,title',
            'subcontents:id,title',
        ]);

        $logService = app()->make(ActivityLogService::class);
        $logService->logUpdatedActivity(
            currentRecord: $this->record,
            oldRecord: $this->oldRecord,
            description: "Serviço <b>{$this->record->name}</b> atualizado por <b>" . auth()->user()->name . "</b>"
        );
    }
}
