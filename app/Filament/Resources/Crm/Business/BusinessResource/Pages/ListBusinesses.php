<?php

namespace App\Filament\Resources\Crm\Business\BusinessResource\Pages;

use App\Filament\Resources\Crm\Business\BusinessResource;
use App\Models\Crm\Funnels\Funnel;
use App\Services\Crm\Funnels\FunnelService;
use Filament\Actions;
use Filament\Resources\Components\Tab;
use Filament\Resources\Pages\ListRecords;
use Filament\Forms;
use Illuminate\Database\Eloquent\Builder;

class ListBusinesses extends ListRecords
{
    protected static string $resource = BusinessResource::class;

    public ?Funnel $activeFunnel = null;

    public function __construct()
    {
        $funnelId = request()->input('activeFunnel');
        $this->setActiveFunnel(funnelId: $funnelId);
    }

    protected function getHeaderActions(): array
    {
        return [
            $this->getFunnelFilterAction(),
            Actions\CreateAction::make(),
        ];
    }

    protected function getFunnelFilterAction(): Actions\Action
    {
        return Actions\Action::make('funnel')
            ->label($this->activeFunnel?->name ?? __('Todos os Funis'))
            ->button()
            ->color('gray')
            ->icon('heroicon-o-funnel')
            ->form([
                Forms\Components\Select::make('funnel_id')
                    ->label(__('Funil'))
                    ->hiddenLabel()
                    ->placeholder(__('Todos os Funis'))
                    ->options(
                        fn(FunnelService $service): array =>
                        $service->getOptionsByFunnels(),
                    )
                    ->default($this->activeFunnel?->id)
                    // ->multiple()
                    // ->selectablePlaceholder(false)
                    ->native(false)
                    ->searchable()
                    ->preload(),
            ])
            ->action(
                function (array $data) {
                    $url = static::$resource::getUrl('index', ['activeFunnel' => $data['funnel_id']]);
                    return redirect()->to($url);
                }
            )
            ->modalHeading(__('Escolha o Funil'));
    }

    public function mount(): void
    {
        parent::mount();
    }

    public function getTabs(): array
    {
        if ($this->activeFunnel) {
            return $this->getFunnelStagesTabs();
        }

        return $this->getAllFunnelsTabs();
    }

    protected function getFunnelStagesTabs(): array
    {
        $tabs = [
            'all' => Tab::make(__('Todas as etapas'))
                ->query(
                    fn(Builder $query): Builder =>
                    $query->where('funnel_id', $this->activeFunnel->id)
                ),
        ];

        foreach ($this->activeFunnel->stages as $stage) {
            $tabs[$stage->id] = Tab::make(__($stage->name))
                ->query(
                    fn(Builder $query): Builder =>
                    $query->where('funnel_id', $this->activeFunnel->id)
                        ->where('funnel_stage_id', $stage->id)
                );
        }

        return $tabs;
    }

    protected function getAllFunnelsTabs(): array
    {
        $tabs = [
            'funnel_all' => Tab::make(__('Todos os funis')),
        ];

        $allFunnels = Funnel::with('stages')
            ->byStatuses(statuses: [1]) // 1 - Ativo
            ->get();

        foreach ($allFunnels as $funnel) {
            $tabs['funnel_' . $funnel->id] = Tab::make(__($funnel->name))
                ->query(
                    fn(Builder $query) =>
                    $query->where('funnel_id', $funnel->id)
                );
        }

        return $tabs;
    }

    public function updatedActiveTab(): void
    {
        $activeTab = $this->activeFunnel
            ? $this->activeTab
            : str_replace('funnel_', '', $this->activeTab);

        $this->tableFilters['funnel_stage_substages']['funnel_substages'] = null;

        if ($this->activeFunnel) {
            $this->tableFilters['funnel_stage_substages']['funnel_stage_id'] = $activeTab !== 'all'
                ? (int) $activeTab
                : null;
        }

        if (!$this->activeFunnel) {
            $this->tableFilters['funnel_stage_substages']['funnel_id'] = $activeTab !== 'all'
                ? (int) $activeTab
                : null;
        }
    }

    public function updatedTableFilters(): void
    {
        parent::updatedTableFilters();

        $this->syncActiveTabWithFilters();
    }

    protected function syncActiveTabWithFilters(): void
    {
        $filterData = $this->tableFilters['funnel_stage_substages'] ?? [];

        if ($this->activeFunnel) {
            if (is_numeric($filterData['funnel_stage_id'] ?? null)) {
                $this->activeTab = $filterData['funnel_stage_id'];
                return;
            }

            $this->activeTab = 'all';
            return;
        }

        if (is_numeric($filterData['funnel_id'] ?? null)) {
            $this->activeTab = 'funnel_' . $filterData['funnel_id'];
            return;
        }

        $this->activeTab = 'funnel_all';
    }

    protected function setActiveFunnel(int|string|null $funnelId): void
    {
        if (blank($funnelId)) {
            return;
        }

        $this->activeFunnel = Funnel::with('stages')
            ->byStatuses([1]) // 1 - Ativo
            ->find($funnelId);
    }
}
