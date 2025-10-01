<?php

namespace App\Filament\Resources\Cms\PageResource\Pages;

use App\Filament\Resources\Cms\PageResource;
use App\Models\Cms\Page;
use App\Services\Cms\PageService;
use App\Services\Cms\PostService;
use App\Services\Polymorphics\ActivityLogService;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditPage extends EditRecord
{
    protected static string $resource = PageResource::class;

    protected array $oldRecord;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make()
                ->before(
                    fn(PageService $service, Actions\DeleteAction $action, Page $record) =>
                    $service->preventDeleteIf(action: $action, page: $record),
                ),
        ];
    }

    protected function getRedirectUrl(): string
    {
        if ($this->data['page_id']) {
            return $this->getResource()::getUrl('edit', ['record' => $this->data['page_id']]);
        }

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
            description: "Página <b>{$this->record->name}</b> atualizada por <b>" . auth()->user()->name . "</b>"
        );
    }
}
