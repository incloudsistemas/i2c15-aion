<?php

namespace App\Observers\Cms;

use App\Models\Cms\PostSlider;
use App\Models\Cms\PostSubcontent;
use App\Models\Cms\Story;
use App\Services\Polymorphics\ActivityLogService;

class StoryObserver
{
    /**
     * Handle the Story "created" event.
     */
    public function created(Story $story): void
    {
        //
    }

    /**
     * Handle the Story "updated" event.
     */
    public function updated(Story $story): void
    {
        //
    }

    /**
     * Handle the Story "deleted" event.
     */
    public function deleted(Story $story): void
    {
        $story->load([
            'cmsPost',
            'cmsPost.owner:id,name',
            'cmsPost.postCategories:id,name',
            'sliders:id,title',
            'subcontents:id,title',
        ]);

        $logService = app()->make(ActivityLogService::class);
        $logService->logDeletedActivity(
            oldRecord: $story,
            description: "História <b>{$story->cmsPost->title}</b> excluída por <b>" . auth()->user()->name . "</b>"
        );

        $story->cmsPost->slug = $story->cmsPost->slug . '//deleted_' . md5(uniqid());
        $story->cmsPost->save();

        $story->cmsPost->delete();

        $story->sliders->each(
            fn(PostSlider $slider) =>
            $slider->delete()
        );

        $story->subcontents->each(
            fn(PostSubcontent $subcontent) =>
            $subcontent->delete()
        );
    }

    /**
     * Handle the Story "restored" event.
     */
    public function restored(Story $story): void
    {
        //
    }

    /**
     * Handle the Story "force deleted" event.
     */
    public function forceDeleted(Story $story): void
    {
        //
    }
}
