<?php

namespace App\Services\Financial;

use App\Models\Financial\Category;
use App\Services\BaseService;
use Filament\Notifications\Notification;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Collection;
use Filament\Forms;

class CategoryService extends BaseService
{
    public function __construct(protected Category $category)
    {
        parent::__construct();
    }

    public function getQueryByCategories(Builder $query): Builder
    {
        return $query->byStatuses(statuses: [1]); // 1 - Ativo
    }

    public function getOptionsByCategories(): array
    {
        return $this->category->byStatuses(statuses: [1]) // 1 - Ativo
            ->pluck('name', 'id')
            ->toArray();
    }

    public function getQueryByMainCategories(Builder $query, ?Category $category = null): Builder
    {
        return $query->byStatuses(statuses: [1]) // 1 - Ativo
            ->whereDoesntHave('mainCategory')
            ->when($category, function (Builder $query) use ($category): Builder {
                return $query->where('id', '<>', $category->id);
            });
    }

    public function getOptionsByMainCategories(?Category $category = null): array
    {
        return $this->category->byStatuses(statuses: [1]) // 1 - Ativo
            ->whereDoesntHave('mainCategory')
            ->when($category, function (Builder $query) use ($category): Builder {
                return $query->where('id', '<>', $category->id);
            })
            ->pluck('name', 'id')
            ->toArray();
    }

    public function getQueryByUpToLevelTwoCategories(Builder $query, ?Category $category = null): Builder
    {
        return $query->byStatuses(statuses: [1]) // 1 - Ativo
            ->where(function (Builder $query): Builder {
                return $query->whereDoesntHave('mainCategory')
                    ->orWhereHas('mainCategory', function ($query) {
                        $query->whereNull('category_id')
                            ->orWhere('category_id', -1);
                    });
            })
            ->when($category, function (Builder $query) use ($category): Builder {
                return $query->where('id', '<>', $category->id);
            });
    }

    public function getOptionsByUpToLevelTwoCategories(?Category $category = null): array
    {
        return $this->category->byStatuses(statuses: [1]) // 1 - Ativo
            ->where(function (Builder $query): Builder {
                return $query->whereDoesntHave('mainCategory')
                    ->orWhereHas('mainCategory', function ($query) {
                        $query->whereNull('category_id')
                            ->orWhere('category_id', -1);
                    });
            })
            ->when($category, function (Builder $query) use ($category): Builder {
                return $query->where('id', '<>', $category->id);
            })
            ->pluck('name', 'id')
            ->toArray();
    }

    public function quickCreateActionByCategories(
        string $field,
        bool $multiple = false
    ): Forms\Components\Actions\Action {
        return Forms\Components\Actions\Action::make($field)
            ->label(__('Criar Categoria Financeira'))
            ->icon('heroicon-o-plus')
            ->form([
                Forms\Components\Grid::make(['default' => 2])
                    ->schema([
                        Forms\Components\TextInput::make('name')
                            ->label(__('Nome'))
                            ->required()
                            ->minLength(2)
                            ->maxLength(255)
                            ->columnSpanFull(),
                        Forms\Components\Select::make('category_id')
                            ->label(__('Categoria parental'))
                            ->helperText(__('As categorias podem ter uma hierarquia. Você pode ter uma categoria de Impostos, e sob ela ter categorias filhas como: "ICMS ST sobre Vendas", "ISS sobre Faturamento"... Totalmente opcional.'))
                            ->relationship(
                                name: 'mainCategory',
                                titleAttribute: 'name',
                                modifyQueryUsing: fn(Builder $query): Builder =>
                                $this->getQueryByUpToLevelTwoCategories(query: $query)
                            )
                            // ->multiple()
                            // ->selectablePlaceholder(false)
                            ->native(false)
                            ->searchable()
                            ->preload()
                            // ->required()
                            ->columnSpanFull(),
                    ]),
            ])
            ->action(
                function (array $data, string|array|null $state, callable $set) use ($field, $multiple): void {
                    $category = $this->category->create($data);

                    if ($multiple) {
                        $values = is_array($state) ? $state : [];
                        $set($field, array_merge($values, [$category->id]));
                    } else {
                        $set($field, $category->id);
                    }
                }
            );
    }

    /**
     * $action can be:
     * Filament\Tables\Actions\DeleteAction;
     * Filament\Actions\DeleteAction;
     */
    public function preventDeleteIf($action, Category $category): void
    {
        $title = __('Ação proibida: Exclusão de categoria');

        if ($this->isAssignedToTransactions(category: $category)) {
            Notification::make()
                ->title($title)
                ->warning()
                ->body(__('Esta categoria possui transações financeiras associadas. Para excluir, você deve primeiro desvincular todas as transações que estão associados a ela.'))
                ->send();

            $action->halt();
        }
    }

    public function deleteBulkAction(Collection $records): void
    {
        $blocked = [];
        $allowed = [];

        foreach ($records as $category) {
            if ($this->isAssignedToTransactions(category: $category)) {
                $blocked[] = $category->name;
                continue;
            }

            $allowed[] = $category;
        }

        if (!empty($blocked)) {
            $displayBlocked = array_slice($blocked, 0, 5);
            $extraCount = count($blocked) - 5;

            $message = __('As seguintes categorias não podem ser excluídas: ') . implode(', ', $displayBlocked);

            if ($extraCount > 0) {
                $message .= " ... (+$extraCount " . __('outros') . ")";
            }

            Notification::make()
                ->title(__('Algumas categorias não puderam ser excluídas'))
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

    protected function isAssignedToTransactions(Category $category): bool
    {
        return $category->financialTransactions()
            ->exists();
    }
}
