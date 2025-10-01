<?php

namespace App\Services\Cms;

use App\Enums\Cms\TestimonialRoleEnum;
use App\Models\Cms\Testimonial;
use App\Models\Cms\Post;
use App\Services\BaseService;
use App\Services\Polymorphics\ActivityLogService;
use Filament\Notifications\Notification;
use Illuminate\Contracts\Database\Eloquent\Builder;

class TestimonialService extends BaseService
{
    public function __construct(protected Post $post, protected Testimonial $testimonial)
    {
        parent::__construct();
    }

    public function tableSearchByRole(Builder $query, string $search): Builder
    {
        $roles = TestimonialRoleEnum::getAssociativeArray();

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
        $roles = TestimonialRoleEnum::getAssociativeArray();

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

    public function afterCreateAction(Testimonial $testimonial, array $data): void
    {
        $testimonial->load([
            'cmsPost',
            'cmsPost.owner:id,name',
            'cmsPost.postCategories:id,name',
            'sliders:id,title',
            'subcontents:id,title',
        ]);

        $logService = app()->make(ActivityLogService::class);
        $logService->logCreatedActivity(
            currentRecord: $testimonial,
            description: "Novo depoimento <b>{$testimonial->cmsPost->title}</b> cadastrado por <b>" . auth()->user()->name . "</b>"
        );
    }

    public function mutateRecordDataToEdit(Testimonial $testimonial, array $data): array
    {
        $postService = app()->make(PostService::class);
        $data['cms_post'] = $postService->getPostData(post: $testimonial->cmsPost);

        return $data;
    }

    public function mutateFormDataToEdit(Testimonial $testimonial, array $data): array
    {
        $testimonial->load([
            'cmsPost',
            'cmsPost.owner:id,name',
            'cmsPost.postCategories:id,name',
            'sliders:id,title',
            'subcontents:id,title',
        ]);

        $data['_old_record'] = $testimonial->replicate()
            ->toArray();

        return $data;
    }

    public function afterEditAction(Testimonial $testimonial, array $data): void
    {
        $testimonial->cmsPost->update($data['cms_post']);

        $testimonial->cmsPost->postCategories()
            ->sync($data['cms_post']['categories']);

        $testimonial->load([
            'cmsPost',
            'cmsPost.owner:id,name',
            'cmsPost.postCategories:id,name',
            'sliders:id,title',
            'subcontents:id,title',
        ]);

        $logService = app()->make(ActivityLogService::class);
        $logService->logUpdatedActivity(
            currentRecord: $testimonial,
            oldRecord: $data['_old_record'],
            description: "Depoimento <b>{$testimonial->cmsPost->title}</b> atualizado por <b>" . auth()->user()->name . "</b>"
        );
    }

    /**
     * $action can be:
     * Filament\Tables\Actions\DeleteAction;
     * Filament\Actions\DeleteAction;
     */
    public function preventDeleteIf($action, Testimonial $testimonial): void
    {
        //
    }
}
