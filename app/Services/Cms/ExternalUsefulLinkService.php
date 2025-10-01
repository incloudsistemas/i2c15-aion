<?php

namespace App\Services\Cms;

use App\Enums\Cms\ExternalUsefulLinkRoleEnum;
use App\Models\Cms\ExternalUsefulLink;
use App\Models\Cms\Post;
use App\Services\BaseService;
use App\Services\Polymorphics\ActivityLogService;
use Filament\Notifications\Notification;
use Illuminate\Contracts\Database\Eloquent\Builder;

class ExternalUsefulLinkService extends BaseService
{
    public function __construct(protected Post $post, protected ExternalUsefulLink $externalUsefulLink)
    {
        parent::__construct();
    }

    public function tableSearchByRole(Builder $query, string $search): Builder
    {
        $roles = ExternalUsefulLinkRoleEnum::getAssociativeArray();

        $matchingRoles = [];
        foreach ($roles as $index => $role) {
            if (stripos($role, $search) !== false) {
                $matchingRoles[] = $index;
            }
        }

        if ($matchingRoles) {
            return $query->whereIn('role', $matchingRoles);
        }

        return $query;
    }

    public function tableSortByRole(Builder $query, string $direction): Builder
    {
        $roles = ExternalUsefulLinkRoleEnum::getAssociativeArray();

        $caseParts = [];
        $bindings = [];

        foreach ($roles as $key => $role) {
            $caseParts[] = "WHEN ? THEN ?";
            $bindings[] = $key;
            $bindings[] = $role;
        }

        $orderByCase = "CASE role " . implode(' ', $caseParts) . " END";

        return $query->orderByRaw("$orderByCase $direction", $bindings);
    }

    public function afterCreateAction(ExternalUsefulLink $externalUsefulLink, array $data): void
    {
        $externalUsefulLink->load([
            'cmsPost',
            'cmsPost.owner:id,name',
            'cmsPost.postCategories:id,name',
            'sliders:id,title',
            'subcontents:id,title',
        ]);

        $logService = app()->make(ActivityLogService::class);
        $logService->logCreatedActivity(
            currentRecord: $externalUsefulLink,
            description: "Novo link externo <b>{$externalUsefulLink->cmsPost->title}</b> cadastrado por <b>" . auth()->user()->name . "</b>"
        );
    }

    public function mutateRecordDataToEdit(ExternalUsefulLink $externalUsefulLink, array $data): array
    {
        $postService = app()->make(PostService::class);
        $data['cms_post'] = $postService->getPostData(post: $externalUsefulLink->cmsPost);

        return $data;
    }

    public function mutateFormDataToEdit(ExternalUsefulLink $externalUsefulLink, array $data): array
    {
        $externalUsefulLink->load([
            'cmsPost',
            'cmsPost.owner:id,name',
            'cmsPost.postCategories:id,name',
            'sliders:id,title',
            'subcontents:id,title',
        ]);

        $data['_old_record'] = $externalUsefulLink->replicate()
            ->toArray();

        return $data;
    }

    public function afterEditAction(ExternalUsefulLink $externalUsefulLink, array $data): void
    {
        $externalUsefulLink->cmsPost->update($data['cms_post']);

        $externalUsefulLink->cmsPost->postCategories()
            ->sync($data['cms_post']['categories']);

        $externalUsefulLink->load([
            'cmsPost',
            'cmsPost.owner:id,name',
            'cmsPost.postCategories:id,name',
            'sliders:id,title',
            'subcontents:id,title',
        ]);

        $logService = app()->make(ActivityLogService::class);
        $logService->logUpdatedActivity(
            currentRecord: $externalUsefulLink,
            oldRecord: $data['_old_record'],
            description: "Link externo <b>{$externalUsefulLink->cmsPost->title}</b> atualizado por <b>" . auth()->user()->name . "</b>"
        );
    }

    /**
     * $action can be:
     * Filament\Tables\Actions\DeleteAction;
     * Filament\Actions\DeleteAction;
     */
    public function preventDeleteIf($action, ExternalUsefulLink $externalUsefulLink): void
    {
        //
    }
}
