<?php

namespace App\Filament\Resources\Cms\BlogPostResource\Pages;

use App\Filament\Resources\Cms\BlogPostResource;
use App\Services\Polymorphics\ActivityLogService;
use Filament\Actions;
use Filament\Resources\Pages\CreateRecord;

class CreateBlogPost extends CreateRecord
{
    protected static string $resource = BlogPostResource::class;

    protected function getRedirectUrl(): string
    {
        return $this->getResource()::getUrl('index');
    }

    protected function afterCreate(): void
    {
        $this->createCmsPost();
        $this->attachCategories();

        $this->logActivity();
    }

    protected function createCmsPost(): void
    {
        $this->record->cmsPost()
            ->create($this->data['cms_post']);
    }

    protected function attachCategories(): void
    {
        $this->record->cmsPost->postCategories()
            ->attach($this->data['cms_post']['categories']);
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
        $logService->logCreatedActivity(
            currentRecord: $this->record,
            description: "Nova postagem do blog <b>{$this->record->name}</b> cadastrada por <b>" . auth()->user()->name . "</b>"
        );
    }
}
