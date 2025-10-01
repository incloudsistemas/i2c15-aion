<?php

namespace App\Observers\Cms;

use App\Models\Cms\ExternalUsefulLink;
use App\Models\Cms\PostSlider;
use App\Models\Cms\PostSubcontent;
use App\Services\Polymorphics\ActivityLogService;

class ExternalUsefulLinkObserver
{
    /**
     * Handle the ExternalUsefulLink "created" event.
     */
    public function created(ExternalUsefulLink $externalUsefulLink): void
    {
        //
    }

    /**
     * Handle the ExternalUsefulLink "updated" event.
     */
    public function updated(ExternalUsefulLink $externalUsefulLink): void
    {
        //
    }

    /**
     * Handle the ExternalUsefulLink "deleted" event.
     */
    public function deleted(ExternalUsefulLink $externalUsefulLink): void
    {
        $externalUsefulLink->load([
            'cmsPost',
            'cmsPost.owner:id,name',
            'cmsPost.postCategories:id,name',
            'sliders:id,title',
            'subcontents:id,title',
        ]);

        $logService = app()->make(ActivityLogService::class);
        $logService->logDeletedActivity(
            oldRecord: $externalUsefulLink,
            description: "Link externo <b>{$externalUsefulLink->cmsPost->title}</b> excluído por <b>" . auth()->user()->name . "</b>"
        );

        $externalUsefulLink->cmsPost->slug = $externalUsefulLink->cmsPost->slug . '//deleted_' . md5(uniqid());
        $externalUsefulLink->cmsPost->save();

        $externalUsefulLink->cmsPost->delete();

        $externalUsefulLink->sliders->each(
            fn(PostSlider $slider) =>
            $slider->delete()
        );

        $externalUsefulLink->subcontents->each(
            fn(PostSubcontent $subcontent) =>
            $subcontent->delete()
        );
    }

    /**
     * Handle the ExternalUsefulLink "restored" event.
     */
    public function restored(ExternalUsefulLink $externalUsefulLink): void
    {
        //
    }

    /**
     * Handle the ExternalUsefulLink "force deleted" event.
     */
    public function forceDeleted(ExternalUsefulLink $externalUsefulLink): void
    {
        //
    }
}
