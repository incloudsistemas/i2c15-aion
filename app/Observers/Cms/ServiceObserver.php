<?php

namespace App\Observers\Cms;

use App\Models\Cms\PostSlider;
use App\Models\Cms\PostSubcontent;
use App\Models\Cms\Service;
use App\Services\Polymorphics\ActivityLogService;

class ServiceObserver
{
    /**
     * Handle the Service "created" event.
     */
    public function created(Service $service): void
    {
        //
    }

    /**
     * Handle the Service "updated" event.
     */
    public function updated(Service $service): void
    {
        //
    }

    /**
     * Handle the Service "deleted" event.
     */
    public function deleted(Service $service): void
    {
        $service->load([
            'cmsPost',
            'cmsPost.owner:id,name',
            'cmsPost.postCategories:id,name',
            'sliders:id,title',
            'subcontents:id,title',
        ]);

        $logService = app()->make(ActivityLogService::class);
        $logService->logDeletedActivity(
            oldRecord: $service,
            description: "Serviço <b>{$service->cmsPost->title}</b> excluído por <b>" . auth()->user()->name . "</b>"
        );

        $service->cmsPost->slug = $service->cmsPost->slug . '//deleted_' . md5(uniqid());
        $service->cmsPost->save();

        $service->cmsPost->delete();

        $service->sliders->each(
            fn(PostSlider $slider) =>
            $slider->delete()
        );

        $service->subcontents->each(
            fn(PostSubcontent $subcontent) =>
            $subcontent->delete()
        );
    }

    /**
     * Handle the Service "restored" event.
     */
    public function restored(Service $service): void
    {
        //
    }

    /**
     * Handle the Service "force deleted" event.
     */
    public function forceDeleted(Service $service): void
    {
        //
    }
}
