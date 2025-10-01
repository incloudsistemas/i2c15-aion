<?php

namespace App\Services\Cms;

use App\Enums\Cms\PostSliderRoleEnum;
use App\Models\Cms\PostSlider;
use App\Services\BaseService;
use Filament\Notifications\Notification;
use Illuminate\Contracts\Database\Eloquent\Builder;

class PostSliderService extends BaseService
{
    public function __construct(protected PostSlider $postSlider)
    {
        parent::__construct();
    }

    public function tableSearchByRole(Builder $query, string $search): Builder
    {
        $roles = PostSliderRoleEnum::getAssociativeArray();

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
        $roles = PostSliderRoleEnum::getAssociativeArray();

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

    public function tableFilterByPublishAt(Builder $query, array $data): Builder
    {
        return $query
            ->when(
                $data['publish_from'],
                fn(Builder $query, $date): Builder =>
                $query->whereDate('publish_at', '>=', $date),
            )
            ->when(
                $data['publish_until'],
                fn(Builder $query, $date): Builder =>
                $query->whereDate('publish_at', '<=', $date),
            );
    }

    public function tableFilterIndicateUsingByPublishAt(array $data): ?string
    {
        return $this->indicateUsingByDates(
            from: $data['publish_from'],
            until: $data['publish_until'],
            display: 'Publicação'
        );
    }

    /**
     * $action can be:
     * Filament\Tables\Actions\DeleteAction;
     * Filament\Actions\DeleteAction;
     */
    public function preventDeleteIf($action, PostSlider $postSlider): void
    {
        //
    }
}
