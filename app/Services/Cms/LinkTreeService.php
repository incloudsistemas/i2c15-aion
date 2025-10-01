<?php

namespace App\Services\Cms;

use App\Enums\Cms\LinkTreeRoleEnum;
use App\Models\Cms\LinkTree;
use App\Models\Cms\Post;
use App\Services\BaseService;
use App\Services\Polymorphics\ActivityLogService;
use Filament\Notifications\Notification;
use Illuminate\Contracts\Database\Eloquent\Builder;

class LinkTreeService extends BaseService
{
    public function __construct(protected Post $post, protected LinkTree $linkTree)
    {
        parent::__construct();
    }

    public function tableSearchByRole(Builder $query, string $search): Builder
    {
        $roles = LinkTreeRoleEnum::getAssociativeArray();

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
        $roles = LinkTreeRoleEnum::getAssociativeArray();

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

    public function afterCreateAction(LinkTree $linkTree, array $data): void
    {
        $linkTree->load([
            'cmsPost',
            'cmsPost.owner:id,name',
            'cmsPost.postCategories:id,name',
            'sliders:id,title',
            'subcontents:id,title',
        ]);

        $logService = app()->make(ActivityLogService::class);
        $logService->logCreatedActivity(
            currentRecord: $linkTree,
            description: "Novo link <b>{$linkTree->cmsPost->title}</b> cadastrado por <b>" . auth()->user()->name . "</b>"
        );
    }

    public function mutateRecordDataToEdit(LinkTree $linkTree, array $data): array
    {
        $postService = app()->make(PostService::class);
        $data['cms_post'] = $postService->getPostData(post: $linkTree->cmsPost);

        return $data;
    }

    public function mutateFormDataToEdit(LinkTree $linkTree, array $data): array
    {
        $linkTree->load([
            'cmsPost',
            'cmsPost.owner:id,name',
            'cmsPost.postCategories:id,name',
            'sliders:id,title',
            'subcontents:id,title',
        ]);

        $data['_old_record'] = $linkTree->replicate()
            ->toArray();

        return $data;
    }

    public function afterEditAction(LinkTree $linkTree, array $data): void
    {
        $linkTree->cmsPost->update($data['cms_post']);

        $linkTree->cmsPost->postCategories()
            ->sync($data['cms_post']['categories']);

        $linkTree->load([
            'cmsPost',
            'cmsPost.owner:id,name',
            'cmsPost.postCategories:id,name',
            'sliders:id,title',
            'subcontents:id,title',
        ]);

        $logService = app()->make(ActivityLogService::class);
        $logService->logUpdatedActivity(
            currentRecord: $linkTree,
            oldRecord: $data['_old_record'],
            description: "Link <b>{$linkTree->cmsPost->title}</b> atualizado por <b>" . auth()->user()->name . "</b>"
        );
    }

    /**
     * $action can be:
     * Filament\Tables\Actions\DeleteAction;
     * Filament\Actions\DeleteAction;
     */
    public function preventDeleteIf($action, LinkTree $linkTree): void
    {
        //
    }
}
