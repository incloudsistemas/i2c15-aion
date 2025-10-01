<?php

namespace App\Observers\Cms;

use App\Models\Cms\PostSlider;
use App\Models\Cms\PostSubcontent;
use App\Models\Cms\Testimonial;
use App\Services\Polymorphics\ActivityLogService;

class TestimonialObserver
{
    /**
     * Handle the Testimonial "created" event.
     */
    public function created(Testimonial $testimonial): void
    {
        //
    }

    /**
     * Handle the Testimonial "updated" event.
     */
    public function updated(Testimonial $testimonial): void
    {
        //
    }

    /**
     * Handle the Testimonial "deleted" event.
     */
    public function deleted(Testimonial $testimonial): void
    {
        $testimonial->load([
            'cmsPost',
            'cmsPost.owner:id,name',
            'cmsPost.postCategories:id,name',
            'sliders:id,title',
            'subcontents:id,title',
        ]);

        $logService = app()->make(ActivityLogService::class);
        $logService->logDeletedActivity(
            oldRecord: $testimonial,
            description: "Depoimento <b>{$testimonial->cmsPost->title}</b> excluído por <b>" . auth()->user()->name . "</b>"
        );

        $testimonial->cmsPost->slug = $testimonial->cmsPost->slug . '//deleted_' . md5(uniqid());
        $testimonial->cmsPost->save();

        $testimonial->cmsPost->delete();

        $testimonial->sliders->each(
            fn(PostSlider $slider) =>
            $slider->delete()
        );

        $testimonial->subcontents->each(
            fn(PostSubcontent $subcontent) =>
            $subcontent->delete()
        );
    }

    /**
     * Handle the Testimonial "restored" event.
     */
    public function restored(Testimonial $testimonial): void
    {
        //
    }

    /**
     * Handle the Testimonial "force deleted" event.
     */
    public function forceDeleted(Testimonial $testimonial): void
    {
        //
    }
}
