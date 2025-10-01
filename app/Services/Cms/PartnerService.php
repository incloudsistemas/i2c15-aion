<?php

namespace App\Services\Cms;

use App\Models\Cms\Partner;
use App\Models\Cms\Post;
use App\Services\BaseService;
use App\Services\Polymorphics\ActivityLogService;
use Filament\Notifications\Notification;
use Illuminate\Contracts\Database\Eloquent\Builder;

class PartnerService extends BaseService
{
    public function __construct(protected Post $post, protected Partner $partner)
    {
        parent::__construct();
    }

    public function afterCreateAction(Partner $partner, array $data): void
    {
        $partner->load([
            'cmsPost',
            'cmsPost.owner:id,name',
            'cmsPost.postCategories:id,name',
            'sliders:id,title',
            'subcontents:id,title',
        ]);

        $logService = app()->make(ActivityLogService::class);
        $logService->logCreatedActivity(
            currentRecord: $partner,
            description: "Novo parceiro <b>{$partner->cmsPost->title}</b> cadastrado por <b>" . auth()->user()->name . "</b>"
        );
    }

    public function mutateRecordDataToEdit(Partner $partner, array $data): array
    {
        $postService = app()->make(PostService::class);
        $data['cms_post'] = $postService->getPostData(post: $partner->cmsPost);

        return $data;
    }

    public function mutateFormDataToEdit(Partner $partner, array $data): array
    {
        $partner->load([
            'cmsPost',
            'cmsPost.owner:id,name',
            'cmsPost.postCategories:id,name',
            'sliders:id,title',
            'subcontents:id,title',
        ]);

        $data['_old_record'] = $partner->replicate()
            ->toArray();

        return $data;
    }

    public function afterEditAction(Partner $partner, array $data): void
    {
        $partner->cmsPost->update($data['cms_post']);

        $partner->cmsPost->postCategories()
            ->sync($data['cms_post']['categories']);

        $partner->load([
            'cmsPost',
            'cmsPost.owner:id,name',
            'cmsPost.postCategories:id,name',
            'sliders:id,title',
            'subcontents:id,title',
        ]);

        $logService = app()->make(ActivityLogService::class);
        $logService->logUpdatedActivity(
            currentRecord: $partner,
            oldRecord: $data['_old_record'],
            description: "Parceiro <b>{$partner->cmsPost->title}</b> atualizado por <b>" . auth()->user()->name . "</b>"
        );
    }

    /**
     * $action can be:
     * Filament\Tables\Actions\DeleteAction;
     * Filament\Actions\DeleteAction;
     */
    public function preventDeleteIf($action, Partner $partner): void
    {
        //
    }
}
