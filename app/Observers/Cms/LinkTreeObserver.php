<?php

namespace App\Observers\Cms;

use App\Models\Cms\LinkTree;
use App\Models\Cms\PostSlider;
use App\Models\Cms\PostSubcontent;
use App\Services\Polymorphics\ActivityLogService;

class LinkTreeObserver
{
    /**
     * Handle the LinkTree "created" event.
     */
    public function created(LinkTree $linkTree): void
    {
        //
    }

    /**
     * Handle the LinkTree "updated" event.
     */
    public function updated(LinkTree $linkTree): void
    {
        //
    }

    /**
     * Handle the LinkTree "deleted" event.
     */
    public function deleted(LinkTree $linkTree): void
    {
        $linkTree->load([
            'cmsPost',
            'cmsPost.owner:id,name',
            'cmsPost.postCategories:id,name',
            'sliders:id,title',
            'subcontents:id,title',
        ]);

        $logService = app()->make(ActivityLogService::class);
        $logService->logDeletedActivity(
            oldRecord: $linkTree,
            description: "Link <b>{$linkTree->cmsPost->title}</b> excluído por <b>" . auth()->user()->name . "</b>"
        );

        $linkTree->cmsPost->slug = $linkTree->cmsPost->slug . '//deleted_' . md5(uniqid());
        $linkTree->cmsPost->save();

        $linkTree->cmsPost->delete();

        $linkTree->sliders->each(
            fn(PostSlider $slider) =>
            $slider->delete()
        );

        $linkTree->subcontents->each(
            fn(PostSubcontent $subcontent) =>
            $subcontent->delete()
        );
    }

    /**
     * Handle the LinkTree "restored" event.
     */
    public function restored(LinkTree $linkTree): void
    {
        //
    }

    /**
     * Handle the LinkTree "force deleted" event.
     */
    public function forceDeleted(LinkTree $linkTree): void
    {
        //
    }
}
