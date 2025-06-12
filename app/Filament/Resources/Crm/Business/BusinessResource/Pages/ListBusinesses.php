<?php

namespace App\Filament\Resources\Crm\Business\BusinessResource\Pages;

use App\Filament\Resources\Crm\Business\BusinessResource;
use App\Models\Crm\Funnels\Funnel;
use App\Services\Crm\Funnels\FunnelService;
use Filament\Actions;
use Filament\Resources\Components\Tab;
use Filament\Resources\Pages\ListRecords;
use Filament\Forms;
use Filament\Forms\Form;
use Illuminate\Database\Eloquent\Builder;

class ListBusinesses extends ListRecords
{
    protected static string $resource = BusinessResource::class;

    public ?Funnel $activeFunnel = null;

    protected function getHeaderActions(): array
    {
        return [
            Actions\Action::make('funnel')
                ->label($this->activeFunnel->name ?? __('Todos os Funis'))
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
                        ->default($this->activeFunnel->id ?? null)
                        // ->multiple()
                        // ->selectablePlaceholder(false)
                        ->native(false)
                        ->searchable()
                        ->preload(),
                ])
                ->action(function (array $data) {
                    $url = BusinessResource::getUrl('index', ['funnel_id' => $data['funnel_id']]);
                    return redirect()->to($url);
                })
                ->modalHeading(__('Escolha o Funil')),
            Actions\CreateAction::make(),
        ];
    }

    public function getTabs(): array
    {
        $funnelId = request()->input('funnel_id');
        $this->setActiveFunnel(funnelId: $funnelId);

        if ($this->activeFunnel) {
            $tabs = [
                'all' => Tab::make(__('Todos'))
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

        $tabs = [
            'funnel_all' => Tab::make(__('Todos')),
        ];

        $funnels = Funnel::with('stages')
            ->byStatuses(statuses: [1]) // 1 - Ativo
            ->get();

        foreach ($funnels as $funnel) {
            $tabs['funnel_' . $funnel->id] = Tab::make(__($funnel->name))
                ->query(
                    fn($query) =>
                    $query->where('funnel_id', $funnel->id)
                );
        }

        return $tabs;
    }

    public function mount(): void
    {
        parent::mount();

        // $funnelId = request()->input('funnel_id');
        // $this->setActiveFunnel(funnelId: $funnelId);
    }

    public function updatedActiveTab(): void
    {
        $isFunnelTab = str_starts_with($this->activeTab ?? '', 'funnel_');
        $activeId = $isFunnelTab ? str_replace('funnel_', '', $this->activeTab) : $this->activeTab;

        if ($isFunnelTab) {
            $this->tableFilters['funnel_stage_substages']['funnel_id'] = $activeId !== 'all' ? $activeId : null;
        }

        if (!$isFunnelTab) {
            $this->tableFilters['funnel_stage_substages']['funnel_stage_id'] = $activeId !== 'all' ? $activeId : null;
        }
    }

    // public function updatedTableFiltersFunnelStageSubstagesFunnelId(): void
    // {
    //     $funnelId = $this->tableFilters['funnel_stage_substages']['funnel_id'];
    //     $this->setActiveFunnel(funnelId: $funnelId);
    // }

    protected function setActiveFunnel(int|string|null $funnelId): void
    {
        if ($funnelId) {
            $this->activeFunnel = Funnel::with('stages')
                ->byStatuses([1]) // 1 - Ativo
                ->where('id', (int) $funnelId)
                ->first();
        }
    }
}
