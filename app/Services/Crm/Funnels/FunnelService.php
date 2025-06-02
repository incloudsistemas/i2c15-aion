<?php

namespace App\Services\Crm\Funnels;

use App\Enums\DefaultStatusEnum;
use App\Models\Crm\Funnels\Funnel;
use App\Models\Crm\Funnels\FunnelStage;
use App\Models\Crm\Funnels\FunnelSubstage;
use App\Services\BaseService;
use Filament\Notifications\Notification;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Collection;

class FunnelService extends BaseService
{
    public function __construct(
        protected Funnel $funnel,
        protected FunnelStage $funnelStage,
        protected FunnelSubstage $funnelSubstage
    ) {
        parent::__construct();
    }

    public function getQueryByStagesIgnoringClosure(Builder $query): Builder
    {
        return $query->where(function (Builder $query): Builder {
            return $query->whereNotIn('business_probability', [100, 0])
                ->orWhereNull('business_probability');
        })
            ->orderBy('order', 'asc')
            ->orderBy('created_at', 'asc');
    }

    public function getQueryByFunnels(Builder $query): Builder
    {
        return $query->byStatuses(statuses: [1]) // 1 - Ativo
            ->orderBy('order', 'asc')
            ->orderBy('created_at', 'asc');
    }

    public function getOptionsByFunnels(): array
    {
        return $this->funnel->byStatuses(statuses: [1]) // 1 - Ativo
            ->orderBy('order', 'asc')
            ->orderBy('created_at', 'asc')
            ->pluck('name', 'id')
            ->toArray();
    }

    public function getBusinessDefaultFunnel(): ?int
    {
        return $this->funnel->byStatuses(statuses: [1]) // 1 - Ativo
            ->orderBy('order', 'asc')
            ->orderBy('created_at', 'asc')
            ->first()
            ?->id;
    }

    public function getQueryByFunnelStagesFunnel(Builder $query, ?int $funnelId): Builder
    {
        return $query->where('funnel_id', $funnelId)
            ->orderBy('order', 'asc')
            ->orderBy('created_at', 'asc');
    }

    public function getOptionsByFunnelStagesFunnel(?int $funnelId): array
    {
        return $this->funnelStage->where('funnel_id', $funnelId)
            ->orderBy('order', 'asc')
            ->orderBy('created_at', 'asc')
            ->pluck('name', 'id')
            ->toArray();
    }

    public function getQueryByFunnelSubstagesFunnelStage(Builder $query, ?int $funnelStageId): Builder
    {
        return $query->where('funnel_stage_id', $funnelStageId)
            ->orderBy('order', 'asc')
            ->orderBy('created_at', 'asc');
    }

    public function getOptionsByFunnelSubstagesFunnelStage(?int $funnelStageId): array
    {
        return $this->funnelSubstage->where('funnel_stage_id', $funnelStageId)
            ->orderBy('order', 'asc')
            ->orderBy('created_at', 'asc')
            ->pluck('name', 'id')
            ->toArray();
    }

    /**
     * $action can be:
     * Filament\Tables\Actions\DeleteAction;
     * Filament\Actions\DeleteAction;
     */
    public function preventDeleteIf($action, Funnel $funnel): void
    {
        $title = __('Ação proibida: Exclusão de funil');

        if ($this->isAssignedToBusiness(funnel: $funnel)) {
            Notification::make()
                ->title($title)
                ->warning()
                ->body(__('Este funil possui negócios associados. Para excluir, você deve primeiro desvincular todos os negócios que estão associados a ele.'))
                ->send();

            $action->halt();
        }
    }

    public function deleteBulkAction(Collection $records): void
    {
        $blocked = [];
        $allowed = [];

        foreach ($records as $funnel) {
            if ($this->isAssignedToBusiness(funnel: $funnel)) {
                $blocked[] = $funnel->name;
                continue;
            }

            $allowed[] = $funnel;
        }

        if (!empty($blocked)) {
            $displayBlocked = array_slice($blocked, 0, 5);
            $extraCount = count($blocked) - 5;

            $message = __('Os seguintes funis não podem ser excluídos: ') . implode(', ', $displayBlocked);

            if ($extraCount > 0) {
                $message .= " ... (+$extraCount " . __('outros') . ")";
            }

            Notification::make()
                ->title(__('Alguns funis não puderam ser excluídos'))
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

    protected function isAssignedToBusiness(Funnel $funnel): bool
    {
        return $funnel->businessFunnelStages()
            ->exists();
    }
}
