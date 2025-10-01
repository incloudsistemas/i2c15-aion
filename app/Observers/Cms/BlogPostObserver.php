<?php

namespace App\Observers\Cms;

use App\Models\Cms\BlogPost;
use App\Models\Cms\PostSlider;
use App\Models\Cms\PostSubcontent;
use App\Services\Polymorphics\ActivityLogService;

class BlogPostObserver
{
    /**
     * Handle the BlogPost "created" event.
     */
    public function created(BlogPost $blogPost): void
    {
        //
    }

    /**
     * Handle the BlogPost "updated" event.
     */
    public function updated(BlogPost $blogPost): void
    {
        //
    }

    /**
     * Handle the BlogPost "deleted" event.
     */
    public function deleted(BlogPost $blogPost): void
    {
        $blogPost->load([
            'cmsPost',
            'cmsPost.owner:id,name',
            'cmsPost.postCategories:id,name',
            'sliders:id,title',
            'subcontents:id,title',
        ]);

        $logService = app()->make(ActivityLogService::class);
        $logService->logDeletedActivity(
            oldRecord: $blogPost,
            description: "Postagem do blog <b>{$blogPost->cmsPost->title}</b> excluída por <b>" . auth()->user()->name . "</b>"
        );

        $blogPost->cmsPost->slug = $blogPost->cmsPost->slug . '//deleted_' . md5(uniqid());
        $blogPost->cmsPost->save();

        $blogPost->cmsPost->delete();

        $blogPost->sliders->each(
            fn(PostSlider $slider) =>
            $slider->delete()
        );

        $blogPost->subcontents->each(
            fn(PostSubcontent $subcontent) =>
            $subcontent->delete()
        );
    }

    /**
     * Handle the BlogPost "restored" event.
     */
    public function restored(BlogPost $blogPost): void
    {
        //
    }

    /**
     * Handle the BlogPost "force deleted" event.
     */
    public function forceDeleted(BlogPost $blogPost): void
    {
        //
    }
}
