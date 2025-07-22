<?php

namespace App\Filament\Resources\Financial\TransactionResource\Pages;

use App\Filament\Resources\Financial\TransactionResource;
use App\Services\Financial\TransactionService;
use Carbon\Carbon;
use Filament\Actions;
use Filament\Resources\Components\Tab;
use Filament\Resources\Pages\ListRecords;
use Filament\Forms;
use Illuminate\Database\Eloquent\Builder;

abstract class ListTransactions extends ListRecords
{
    protected static string $resource = TransactionResource::class;

    protected int $role;

    public ?string $activeYear = null;

    public function __construct()
    {
        $this->role = static::$resource::$role;

        $year = request()->input('activeYear', now()->year);
        $this->activeYear = $this->validateYear(year: (string) $year);

        $tab = request()->input('activeTab', now()->month);
        $this->activeTab = $this->validateTab(tab: (string) $tab);
    }

    protected function getHeaderActions(): array
    {
        return [
            $this->getYearFilterAction(),
            Actions\CreateAction::make(),
        ];
    }

    protected function getYearFilterAction(): Actions\Action
    {
        return Actions\Action::make('year')
            ->label($this->activeYear ?? __('Todos os Anos'))
            ->button()
            ->color('gray')
            ->icon('heroicon-o-calendar')
            ->form([
                Forms\Components\Select::make('year')
                    ->label(__('Ano'))
                    ->hiddenLabel()
                    ->placeholder(__('Todos os Anos'))
                    ->options(
                        fn(TransactionService $service): array =>
                        $service->getOptionsByAvailableYears(role: $this->role),
                    )
                    ->default($this->activeYear)
                    // ->multiple()
                    ->selectablePlaceholder(false)
                    ->native(false)
                    ->searchable()
                    ->preload(),
            ])
            ->action(
                function (array $data) {
                    $url = static::$resource::getUrl('index', ['activeYear' => $data['year']]);
                    return redirect()->to($url);
                }
            )
            ->modalHeading(__('Escolha o Ano'));
    }

    public function mount(): void
    {
        parent::mount();
    }

    public function getTabs(): array
    {
        $tabs = [
            'all'  => Tab::make(__('Todas as transações')),
            'year' => Tab::make(__($this->activeYear))
                ->query(
                    fn(Builder $query): Builder =>
                    $query->whereYear('due_at', $this->activeYear)
                ),
        ];

        foreach (range(1, 12) as $month) {
            $monthName = Carbon::create()
                ->month($month)
                ->locale('pt_BR')
                ->getTranslatedShortMonthName();

            $tabs[$month] = Tab::make(__(ucfirst($monthName)))
                ->query(
                    fn(Builder $query): Builder =>
                    $query->whereMonth('due_at', $month)
                        ->whereYear('due_at', $this->activeYear)
                );
        }

        return $tabs;
    }

    public function updatedActiveTab(): void
    {
        if ($this->activeTab === 'all') {
            $this->tableFilters['by_default_date'] = [
                'year'            => $this->activeYear,
                'interval'        => null,
                'custom_interval' => null,
            ];

            return;
        }

        if ($this->activeTab === 'year') {
            $this->tableFilters['by_default_date'] = [
                'year'            => $this->activeYear,
                'interval'        => 'custom',
                'custom_interval' => 'this_year',
            ];

            return;
        }

        if (is_numeric($this->activeTab) && $this->activeTab >= 1 && $this->activeTab <= 12) {
            $this->tableFilters['by_default_date'] = [
                'year'            => $this->activeYear,
                'interval'        => $this->activeTab,
                'custom_interval' => null,
            ];
        }
    }

    public function updatedTableFilters(): void
    {
        parent::updatedTableFilters();

        $this->syncActiveTabWithFilters();
    }

    protected function syncActiveTabWithFilters(): void
    {
        $filterData = $this->tableFilters['by_default_date'] ?? [];

        if (
            ($filterData['interval'] ?? null) === 'custom'
            && ($filterData['custom_interval'] ?? null) === 'this_year'
        ) {
            $this->activeTab = 'year';
            return;
        }

        if (
            is_numeric($filterData['interval'] ?? null)
            && $filterData['interval'] >= 1
            && $filterData['interval'] <= 12
        ) {
            $this->activeTab = $filterData['interval'];
            return;
        }

        $this->activeTab = 'all';
    }

    protected function validateYear(string $year): string
    {
        if (!is_numeric($year) || $year < 2000 || $year > 2100) {
            return (string) now()->year;
        }

        return (string) $year;
    }

    protected function validateTab(string $tab): string
    {
        $validTabs = array_merge(['all', 'year'], range(1, 12));

        if (!in_array($tab, $validTabs)) {
            return (string) now()->month;
        }

        return (string) $tab;
    }
}
