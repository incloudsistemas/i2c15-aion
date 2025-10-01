<?php

namespace App\Observers\Cms;

use App\Models\Cms\PortfolioPost;
use App\Models\Cms\PostSlider;
use App\Models\Cms\PostSubcontent;
use App\Services\Polymorphics\ActivityLogService;

class PortfolioPostObserver
{
    /**
     * Handle the PortfolioPost "created" event.
     */
    public function created(PortfolioPost $portfolioPost): void
    {
        //
    }

    /**
     * Handle the PortfolioPost "updated" event.
     */
    public function updated(PortfolioPost $portfolioPost): void
    {
        //
    }

    /**
     * Handle the PortfolioPost "deleted" event.
     */
    public function deleted(PortfolioPost $portfolioPost): void
    {
        $portfolioPost->load([
            'cmsPost',
            'cmsPost.owner:id,name',
            'cmsPost.postCategories:id,name',
            'sliders:id,title',
            'subcontents:id,title',
        ]);

        $logService = app()->make(ActivityLogService::class);
        $logService->logDeletedActivity(
            oldRecord: $portfolioPost,
            description: "Portfólio <b>{$portfolioPost->cmsPost->title}</b> excluído por <b>" . auth()->user()->name . "</b>"
        );

        $portfolioPost->cmsPost->slug = $portfolioPost->cmsPost->slug . '//deleted_' . md5(uniqid());
        $portfolioPost->cmsPost->save();

        $portfolioPost->cmsPost->delete();

        $portfolioPost->sliders->each(
            fn(PostSlider $slider) =>
            $slider->delete()
        );

        $portfolioPost->subcontents->each(
            fn(PostSubcontent $subcontent) =>
            $subcontent->delete()
        );
    }

    /**
     * Handle the PortfolioPost "restored" event.
     */
    public function restored(PortfolioPost $portfolioPost): void
    {
        //
    }

    /**
     * Handle the PortfolioPost "force deleted" event.
     */
    public function forceDeleted(PortfolioPost $portfolioPost): void
    {
        //
    }
}
