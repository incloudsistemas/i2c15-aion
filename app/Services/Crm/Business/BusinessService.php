<?php

namespace App\Services\Crm\Business;

use App\Enums\Crm\Business\PriorityEnum;
use App\Models\Crm\Business\Business;
use App\Services\BaseService;
use Filament\Notifications\Notification;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Support\Facades\DB;

class BusinessService extends BaseService
{
    public function __construct(protected Business $business)
    {
        parent::__construct();
    }

    public function getStageDescription(Business $business): ?string
    {
        $substage = $business->substage?->name;
        $lossReason = $business->current_business_funnel_stage->loss_reason;
        $businessAt = ConvertEnToPtBrDate(date: $business->current_business_funnel_stage->business_at);

        if (!in_array($business->stage->business_probability, [0, 100])) {
            return $substage;
        }

        if ($lossReason) {
            return "{$businessAt} – {$lossReason->getLabel()}";
        }

        return $businessAt;
    }

    public function getStageColor(Business $business): string
    {
        return match (true) {
            $business->stage->business_probability === 100 => 'success',
            $business->stage->business_probability >= 70   => 'warning',
            $business->stage->business_probability === 0   => 'danger',
            default                                        => 'primary',
        };
    }

    public function tableSortByPrice(Builder $query, string $direction): Builder
    {
        return $query->orderBy('price', $direction);
    }

    public function tableSearchByPriority(Builder $query, string $search): Builder
    {
        $priorities = PriorityEnum::getAssociativeArray();

        $matchingStatuses = [];
        foreach ($priorities as $index => $priority) {
            if (stripos($priority, $search) !== false) {
                $matchingStatuses[] = $index;
            }
        }

        if ($matchingStatuses) {
            return $query->whereIn('priority', $matchingStatuses);
        }

        return $query;
    }

    public function tableSortByPriority(Builder $query, string $direction): Builder
    {
        $priorities = PriorityEnum::getAssociativeArray();

        $caseParts = [];
        $bindings = [];

        foreach ($priorities as $key => $priority) {
            $caseParts[] = "WHEN ? THEN ?";
            $bindings[] = $key;
            $bindings[] = $priority;
        }

        $orderByCase = "CASE priority " . implode(' ', $caseParts) . " END";

        return $query->orderByRaw("$orderByCase $direction", $bindings);
    }

    public function tableSearchByCurrentUser(Builder $query, string $search): Builder
    {
        $subQr = DB::table('crm_business_user')
            ->join('users', 'users.id', '=', 'crm_business_user.user_id')
            ->whereColumn('crm_business_user.business_id', 'crm_business.id')
            ->orderByDesc('crm_business_user.business_at')
            ->limit(1)
            ->select('users.name');

        return $query->whereRaw("({$subQr->toSql()}) LIKE ?", ["%{$search}%"])
            ->mergeBindings($subQr);
    }

    public function tableSortByCurrentUser(Builder $query, string $direction): Builder
    {
        return $query->addSelect([
            'current_user_name' => DB::table('users')
                ->join('crm_business_user', 'users.id', '=', 'crm_business_user.user_id')
                ->whereColumn('crm_business_user.business_id', "crm_business.id")
                ->orderByDesc('crm_business_user.business_at')
                ->limit(1)
                ->select('users.name'),
        ])
            ->orderBy('current_user_name', $direction);
    }

    public function tableDefaultSort(Builder $query): Builder
    {
        return $query->orderBy('updated_at', 'desc')
            ->orderBy('business_at', 'desc')
            ->orderBy('created_at', 'desc');
    }

    public function tableFilterByCurrentBusinessFunnelStages(Builder $query, array $data): Builder
    {
        if (!$data['funnel_id'] && !$data['funnel_stage_id']) {
            return $query;
        }

        return $query->with('currentBusinessFunnelStageRelation')
            ->whereHas('currentBusinessFunnelStageRelation', function (Builder $query) use ($data): Builder {
                return $query->when(
                    $data['funnel_id'],
                    fn(Builder $query, int $funnelId): Builder =>
                    $query->where('funnel_id', $funnelId)
                )
                    ->when(
                        $data['funnel_stage_id'],
                        fn(Builder $query, int $stageId): Builder =>
                        $query->where('funnel_stage_id', $stageId)
                    )
                    ->when(
                        $data['funnel_substages'],
                        fn(Builder $query, array $substageIds): Builder =>
                        $query->whereIn('funnel_substage_id', $substageIds)
                    );
            });
    }

    public function getQueryByElementsWhereHasBusinessBasedOnAuthRoles(Builder $query): Builder
    {
        $user = auth()->user();

        $query = $query->with('business');

        if ($user->hasAnyRole(['Superadministrador', 'Administrador'])) {
            return $query->whereHas('business');
        }

        return $query->whereHas(
            'business',
            fn(Builder $query): Builder =>
            $query->whereHasCurrentUser(userIds: $user->id),
        );
    }

    public function tableFilterByPrice(Builder $query, array $data): Builder
    {
        if (!$data['min_price'] && !$data['max_price']) {
            return $query;
        }

        $data['min_price'] = ConvertPtBrFloatStringToInt(value: $data['min_price']);
        $data['max_price'] = ConvertPtBrFloatStringToInt(value: $data['max_price']);

        return $query->when(
            $data['min_price'],
            fn(Builder $query, $price): Builder =>
            $query->where('price', '>=', $price),
        )
            ->when(
                $data['max_price'],
                fn(Builder $query, $price): Builder =>
                $query->where('price', '<=', $price),
            );
    }

    public function getQueryByCurrentUsersWhereHasBusinessBasedOnAuthRoles(Builder $query): Builder
    {
        $user = auth()->user();

        if ($user->hasAnyRole(['Superadministrador', 'Administrador'])) {
            return $query->whereExists(function ($subquery) {
                $subquery->select(DB::raw(1))
                    ->from('crm_business_user as bu')
                    ->whereColumn('bu.user_id', 'users.id');
            });
        }

        return $query->whereExists(function ($subquery) use ($user) {
            $subquery->select(DB::raw(1))
                ->from('crm_business_user as bu')
                ->whereColumn('bu.user_id', 'users.id')
                ->where('bu.user_id', $user->id)
                ->whereRaw('bu.business_at = (
                    select max(inner_bu.business_at)
                    from crm_business_user as inner_bu
                    where inner_bu.business_id = bu.business_id
                )');
        });
    }

    public function tableFilterByCurrentUsers(Builder $query, array $data): Builder
    {
        if (!$data['values']) {
            return $query;
        }

        return $query->whereHasCurrentUser(userIds: $data['values']);
    }

    public function tableFilterByClosedAt(Builder $query, array $data): Builder
    {
        if (!$data['closed_from'] && !$data['closed_until']) {
            return $query;
        }

        return $query->with('currentBusinessFunnelStageRelation')
            ->whereHas('currentBusinessFunnelStageRelation', function (Builder $query) use ($data): Builder {
                return $query->whereHas(
                    'stage',
                    fn(Builder $query): Builder =>
                    $query->whereIn('business_probability', [0, 100])
                )->when(
                    $data['closed_from'],
                    function (Builder $query, string $date) use ($data) {
                        if (empty($data['closed_until'])) {
                            return $query->whereDate('business_at', '=', $date);
                        }

                        return $query->whereDate('business_at', '>=', $date);
                    }
                )->when(
                    $data['closed_until'],
                    fn(Builder $query, string $date): Builder =>
                    $query->whereDate('business_at', '<=', $date)
                );
            });
    }

    public function tableFilterByBusinessAt(Builder $query, array $data): Builder
    {
        if (!$data['business_from'] && !$data['business_until']) {
            return $query;
        }

        return $query->when(
            $data['business_from'],
            function (Builder $query, string $date) use ($data) {
                if (empty($data['business_until'])) {
                    return $query->whereDate('business_at', '=', $date);
                }

                return $query->whereDate('business_at', '>=', $date);
            }
        )->when(
            $data['business_until'],
            fn(Builder $query, string $date): Builder =>
            $query->whereDate('business_at', '<=', $date)
        );
    }

    /**
     * $action can be:
     * Filament\Tables\Actions\DeleteAction;
     * Filament\Actions\DeleteAction;
     */
    public function preventDeleteIf($action, Business $business): void
    {
        $title = __('Ação proibida: Exclusão de negócio');

        // if ($this->isAssignedTo??(source: $source)) {
        //     Notification::make()
        //         ->title($title)
        //         ->warning()
        //         ->body(__('Esta origem possui contatos associados. Para excluir, você deve primeiro desvincular todos os contatos que estão associados a ela.'))
        //         ->send();

        //     $action->halt();
        // }
    }

    public function deleteBulkAction(Collection $records): void
    {
        $blocked = [];
        $allowed = [];

        foreach ($records as $business) {
            // if ($this->isAssignedTo??(business: $business)) {
            //     $blocked[] = $business->name;
            //     continue;
            // }

            $allowed[] = $business;
        }

        if (!empty($blocked)) {
            $displayBlocked = array_slice($blocked, 0, 5);
            $extraCount = count($blocked) - 5;

            $message = __('Os seguintes negócios não podem ser excluídos: ') . implode(', ', $displayBlocked);

            if ($extraCount > 0) {
                $message .= " ... (+$extraCount " . __('outros') . ")";
            }

            Notification::make()
                ->title(__('Alguns negócios não puderam ser excluídos'))
                ->warning()
                ->body($message)
                ->send();
        }

        collect($allowed)->each->delete();

        if (!empty($allowed)) {
            Notification::make()
                ->title(__('Excluído'))
                ->success()
                ->send();
        }
    }
}
