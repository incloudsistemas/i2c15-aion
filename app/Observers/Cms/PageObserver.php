<?php

namespace App\Observers\Cms;

use App\Models\Cms\Page;
use App\Models\Cms\PostSlider;
use App\Models\Cms\PostSubcontent;
use App\Services\Polymorphics\ActivityLogService;

class PageObserver
{
    /**
     * Handle the Page "created" event.
     */
    public function created(Page $page): void
    {
        //
    }

    /**
     * Handle the Page "updated" event.
     */
    public function updated(Page $page): void
    {
        //
    }

    /**
     * Handle the Page "deleted" event.
     */
    public function deleted(Page $page): void
    {
        $page->load([
            'cmsPost',
            'cmsPost.owner:id,name',
            'cmsPost.postCategories:id,name',
            'sliders:id,title',
            'subcontents:id,title',
        ]);

        $logService = app()->make(ActivityLogService::class);
        $logService->logDeletedActivity(
            oldRecord: $page,
            description: "Página <b>{$page->cmsPost->title}</b> excluída por <b>" . auth()->user()->name . "</b>"
        );

        $page->cmsPost->slug = $page->cmsPost->slug . '//deleted_' . md5(uniqid());
        $page->cmsPost->save();

        $page->cmsPost->delete();

        $page->sliders->each(
            fn(PostSlider $slider) =>
            $slider->delete()
        );

        $page->subcontents->each(
            fn(PostSubcontent $subcontent) =>
            $subcontent->delete()
        );

        $page->subpages->each(
            fn(Page $subpage) =>
            $subpage->delete()
        );
    }

    /**
     * Handle the Page "restored" event.
     */
    public function restored(Page $page): void
    {
        //
    }

    /**
     * Handle the Page "force deleted" event.
     */
    public function forceDeleted(Page $page): void
    {
        //
    }
}
