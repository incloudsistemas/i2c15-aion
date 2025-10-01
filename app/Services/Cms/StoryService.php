<?php

namespace App\Services\Cms;

use App\Enums\Cms\StoryRoleEnum;
use App\Models\Cms\Post;
use App\Models\Cms\Story;
use App\Services\BaseService;
use App\Services\Polymorphics\ActivityLogService;
use Filament\Notifications\Notification;
use Illuminate\Contracts\Database\Eloquent\Builder;

class StoryService extends BaseService
{
    public function __construct(protected Post $post, protected Story $story)
    {
        parent::__construct();
    }

    public function tableSearchByRole(Builder $query, string $search): Builder
    {
        $roles = StoryRoleEnum::getAssociativeArray();

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
        $roles = StoryRoleEnum::getAssociativeArray();

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

    public function afterCreateAction(Story $story, array $data): void
    {
        $story->load([
            'cmsPost',
            'cmsPost.owner:id,name',
            'cmsPost.postCategories:id,name',
            'sliders:id,title',
            'subcontents:id,title',
        ]);

        $logService = app()->make(ActivityLogService::class);
        $logService->logCreatedActivity(
            currentRecord: $story,
            description: "Nova história <b>{$story->cmsPost->title}</b> cadastrada por <b>" . auth()->user()->name . "</b>"
        );
    }

    public function mutateRecordDataToEdit(Story $story, array $data): array
    {
        $postService = app()->make(PostService::class);
        $data['cms_post'] = $postService->getPostData(post: $story->cmsPost);

        return $data;
    }

    public function mutateFormDataToEdit(Story $story, array $data): array
    {
        $story->load([
            'cmsPost',
            'cmsPost.owner:id,name',
            'cmsPost.postCategories:id,name',
            'sliders:id,title',
            'subcontents:id,title',
        ]);

        $data['_old_record'] = $story->replicate()
            ->toArray();

        return $data;
    }

    public function afterEditAction(Story $story, array $data): void
    {
        $story->cmsPost->update($data['cms_post']);

        $story->cmsPost->postCategories()
            ->sync($data['cms_post']['categories']);

        $story->load([
            'cmsPost',
            'cmsPost.owner:id,name',
            'cmsPost.postCategories:id,name',
            'sliders:id,title',
            'subcontents:id,title',
        ]);

        $logService = app()->make(ActivityLogService::class);
        $logService->logUpdatedActivity(
            currentRecord: $story,
            oldRecord: $data['_old_record'],
            description: "História <b>{$story->cmsPost->title}</b> atualizada por <b>" . auth()->user()->name . "</b>"
        );
    }

    /**
     * $action can be:
     * Filament\Tables\Actions\DeleteAction;
     * Filament\Actions\DeleteAction;
     */
    public function preventDeleteIf($action, Story $story): void
    {
        //
    }
}
