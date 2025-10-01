<?php

namespace App\Observers\Cms;

use App\Models\Cms\Partner;
use App\Models\Cms\PostSlider;
use App\Models\Cms\PostSubcontent;
use App\Services\Polymorphics\ActivityLogService;

class PartnerObserver
{
    /**
     * Handle the Partner "created" event.
     */
    public function created(Partner $partner): void
    {
        //
    }

    /**
     * Handle the Partner "updated" event.
     */
    public function updated(Partner $partner): void
    {
        //
    }

    /**
     * Handle the Partner "deleted" event.
     */
    public function deleted(Partner $partner): void
    {
        $partner->load([
            'cmsPost',
            'cmsPost.owner:id,name',
            'cmsPost.postCategories:id,name',
            'sliders:id,title',
            'subcontents:id,title',
        ]);

        $logService = app()->make(ActivityLogService::class);
        $logService->logDeletedActivity(
            oldRecord: $partner,
            description: "Parceiro <b>{$partner->cmsPost->title}</b> excluído por <b>" . auth()->user()->name . "</b>"
        );

        $partner->cmsPost->slug = $partner->cmsPost->slug . '//deleted_' . md5(uniqid());
        $partner->cmsPost->save();

        $partner->cmsPost->delete();

        $partner->sliders->each(
            fn(PostSlider $slider) =>
            $slider->delete()
        );

        $partner->subcontents->each(
            fn(PostSubcontent $subcontent) =>
            $subcontent->delete()
        );
    }

    /**
     * Handle the Partner "restored" event.
     */
    public function restored(Partner $partner): void
    {
        //
    }

    /**
     * Handle the Partner "force deleted" event.
     */
    public function forceDeleted(Partner $partner): void
    {
        //
    }
}
