<?php

namespace App\Filament\Resources\Crm\Funnels;

use App\Enums\DefaultStatusEnum;
use App\Filament\Resources\Crm\Funnels\FunnelResource\Pages;
use App\Filament\Resources\Crm\Funnels\FunnelResource\RelationManagers;
use App\Models\Crm\Funnels\Funnel;
use App\Models\Crm\Funnels\FunnelStage;
use App\Services\Crm\Funnels\FunnelService;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Forms\Get;
use Filament\Forms\Set;
use Filament\Infolists;
use Filament\Infolists\Infolist;
use Filament\Resources\Resource;
use Filament\Support;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class FunnelResource extends Resource
{
    protected static ?string $model = Funnel::class;

    protected static ?string $slug = 'crm/funnels';

    protected static ?string $recordTitleAttribute = 'name';

    protected static ?string $modelLabel = 'Funil de Negócio';

    protected static ?string $pluralModelLabel = 'Funis de Negócios';

    protected static ?string $navigationGroup = 'CRM';

    protected static ?string $navigationParentItem = 'Negócios';

    protected static ?int $navigationSort = 99;

    protected static ?string $navigationLabel = 'Funis de Negócios';

    protected static ?string $navigationIcon = 'heroicon-o-funnel';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                static::getGeneralInfosFormSection(),
                static::getFunnelStagesFormSection(),
            ]);
    }

    protected static function getGeneralInfosFormSection(): Forms\Components\Section
    {
        return Forms\Components\Section::make(__('Infos. Gerais'))
            ->description(__('Visão geral e informações fundamentais sobre o funil.'))
            ->schema([
                Forms\Components\TextInput::make('name')
                    ->label(__('Nome do funil'))
                    ->required()
                    ->minLength(2)
                    ->maxLength(255)
                    ->columnSpanFull(),
                Forms\Components\Textarea::make('description')
                    ->label(__('Descrição'))
                    ->rows(4)
                    ->minLength(2)
                    ->maxLength(65535)
                    ->columnSpanFull(),
                Forms\Components\Select::make('status')
                    ->label(__('Status'))
                    ->options(DefaultStatusEnum::class)
                    ->default(1)
                    ->selectablePlaceholder(false)
                    ->required()
                    ->native(false)
                    ->visibleOn('edit'),
            ])
            ->columns(2)
            ->collapsible();
    }

    protected static function getFunnelStagesFormSection(): Forms\Components\Section
    {
        return Forms\Components\Section::make(__('Etapas do Funil'))
            ->description(__('Mapeie, organize e otimize cada estágio do seu funil.'))
            ->schema([
                Forms\Components\Repeater::make('stages')
                    ->hiddenLabel()
                    ->relationship(
                        name: 'stages',
                        modifyQueryUsing: fn(FunnelService $service, Builder $query): Builder =>
                        $service->getQueryByStagesIgnoringClosure(query: $query)
                    )
                    ->schema([
                        Forms\Components\TextInput::make('name')
                            ->label(__('Etapa'))
                            ->required()
                            ->minLength(2)
                            ->maxLength(255),
                        Forms\Components\Select::make('business_probability')
                            ->label(__('Probabilidade de negócio'))
                            ->options([
                                10 => '10%',
                                20 => '20%',
                                30 => '30%',
                                40 => '40%',
                                50 => '50%',
                                60 => '60%',
                                70 => '70%',
                                80 => '80%',
                                90 => '90%',
                            ])
                            // ->multiple()
                            // ->selectablePlaceholder(false)
                            ->native(false)
                            ->searchable()
                            ->preload(),
                        Forms\Components\Repeater::make('stages')
                            ->hiddenLabel()
                            ->relationship(name: 'substages')
                            ->schema([
                                Forms\Components\TextInput::make('name')
                                    ->label(__('Sub-etapa'))
                                    ->required()
                                    ->minLength(2)
                                    ->maxLength(255)
                                    ->columnSpanFull(),
                            ])
                            ->itemLabel(
                                fn(mixed $state): ?string =>
                                $state['name'] ?? null
                            )
                            ->addActionLabel(__('Adicionar sub-etapa'))
                            ->defaultItems(0)
                            ->reorderable(true)
                            ->reorderableWithButtons()
                            ->orderColumn('order')
                            ->collapsible()
                            ->collapseAllAction(
                                fn(Forms\Components\Actions\Action $action) =>
                                $action->label(__('Minimizar todos'))
                            )
                            ->deleteAction(
                                fn(Forms\Components\Actions\Action $action) =>
                                $action->requiresConfirmation()
                            )
                            ->columnSpanFull()
                            ->columns(2),
                    ])
                    ->itemLabel(
                        fn(mixed $state): ?string =>
                        $state['name'] ?? null
                    )
                    ->addActionLabel(__('Adicionar etapa'))
                    ->defaultItems(1)
                    ->reorderable(true)
                    ->reorderableWithButtons()
                    ->orderColumn('order')
                    ->collapsible()
                    ->collapseAllAction(
                        fn(Forms\Components\Actions\Action $action) =>
                        $action->label(__('Minimizar todos'))
                    )
                    ->deleteAction(
                        fn(Forms\Components\Actions\Action $action) =>
                        $action->requiresConfirmation()
                    )
                    ->columnSpanFull()
                    ->columns(2),
                Forms\Components\Fieldset::make(__('Fases de Fechamento'))
                    ->schema([
                        Forms\Components\TextInput::make('closing_stages.done.name')
                            ->label(__('Fechado'))
                            ->default('Fechado – Ganhou')
                            ->required()
                            ->minLength(2)
                            ->maxLength(255),
                        Forms\Components\Select::make('closing_stages.done.business_probability')
                            ->label(__('Probabilidade de negócio'))
                            ->options([
                                100 => '100%',
                            ])
                            ->default(100)
                            ->disabled()
                            ->dehydrated(),
                        Forms\Components\TextInput::make('closing_stages.lost.name')
                            ->label(__('Perdido'))
                            ->default('Fechado – Perdido')
                            ->required()
                            ->minLength(2)
                            ->maxLength(255),
                        Forms\Components\Select::make('closing_stages.lost.business_probability')
                            ->label(__('Probabilidade de negócio'))
                            ->options([
                                0 => '0%',
                            ])
                            ->default(0)
                            ->disabled()
                            ->dehydrated(),
                    ])
                    ->columns(4),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->striped()
            ->columns(static::getTableColumns())
            ->defaultSort(column: 'order', direction: 'asc')
            ->reorderable('order')
            ->filters(static::getTableFilters(), layout: Tables\Enums\FiltersLayout::AboveContentCollapsible)
            ->filtersFormColumns(2)
            ->actions([
                Tables\Actions\ActionGroup::make([
                    Tables\Actions\ActionGroup::make([
                        Tables\Actions\ViewAction::make()
                            ->extraModalFooterActions([
                                Tables\Actions\Action::make('edit')
                                    ->label(__('Editar'))
                                    ->button()
                                    ->url(
                                        fn(Funnel $record): string =>
                                        self::getUrl('edit', ['record' => $record]),
                                    )
                                    ->hidden(
                                        fn(): bool =>
                                        !auth()->user()->can('Editar [CRM] Funis de Negócios')
                                    ),
                            ]),
                        Tables\Actions\EditAction::make(),
                    ])
                        ->dropdown(false),
                    Tables\Actions\DeleteAction::make()
                        ->before(
                            fn(FunnelService $service, Tables\Actions\DeleteAction $action, Funnel $record) =>
                            $service->preventDeleteIf(action: $action, funnel: $record)
                        ),
                ])
                    ->label(__('Ações'))
                    ->icon('heroicon-m-chevron-down')
                    ->size(Support\Enums\ActionSize::ExtraSmall)
                    ->color('gray')
                    ->button(),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DeleteBulkAction::make()
                        ->action(
                            fn(FunnelService $service, Collection $records) =>
                            $service->deleteBulkAction(records: $records)
                        )
                        ->hidden(
                            fn(): bool =>
                            !auth()->user()->can('Deletar [CRM] Funis de Negócios'),
                        ),
                ]),
            ])
            ->emptyStateActions([
                Tables\Actions\CreateAction::make(),
            ])
            ->recordAction(Tables\Actions\ViewAction::class)
            ->recordUrl(null);
    }

    protected static function getTableColumns(): array
    {
        return [
            Tables\Columns\TextColumn::make('name')
                ->label(__('Funil'))
                ->searchable()
                ->sortable(),
            Tables\Columns\TextColumn::make('order')
                ->label(__('Ordem'))
                ->sortable()
                ->toggleable(isToggledHiddenByDefault: true),
            Tables\Columns\TextColumn::make('status')
                ->label(__('Status'))
                ->badge()
                ->searchable(
                    query: fn(FunnelService $service, Builder $query, string $search): Builder =>
                    $service->tableSearchByStatus(query: $query, search: $search)
                )
                ->sortable(
                    query: fn(FunnelService $service, Builder $query, string $direction): Builder =>
                    $service->tableSortByStatus(query: $query, direction: $direction)
                )
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('created_at')
                ->label(__('Cadastro'))
                ->dateTime('d/m/Y H:i')
                ->sortable()
                ->size(Tables\Columns\TextColumn\TextColumnSize::ExtraSmall)
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('updated_at')
                ->label(__('Últ. atualização'))
                ->dateTime('d/m/Y H:i')
                ->sortable()
                ->size(Tables\Columns\TextColumn\TextColumnSize::ExtraSmall)
                ->toggleable(isToggledHiddenByDefault: true),
        ];
    }

    protected static function getTableFilters(): array
    {
        return [
            Tables\Filters\SelectFilter::make('status')
                ->label(__('Status'))
                ->multiple()
                ->options(DefaultStatusEnum::class),
            Tables\Filters\Filter::make('created_at')
                ->label(__('Cadastro'))
                ->form([
                    Forms\Components\Grid::make([
                        'default' => 1,
                        'md'      => 2,
                    ])
                        ->schema([
                            Forms\Components\DatePicker::make('created_from')
                                ->label(__('Cadastro de'))
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (Set $set, Get $get, mixed $state): void {
                                        if (!empty($get('created_until')) && $state > $get('created_until')) {
                                            $set('created_until', $state);
                                        }
                                    }
                                ),
                            Forms\Components\DatePicker::make('created_until')
                                ->label(__('Cadastro até'))
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (Set $set, Get $get, mixed $state): void {
                                        if (!empty($get('created_from')) && $state < $get('created_from')) {
                                            $set('created_from', $state);
                                        }
                                    }
                                ),
                        ]),
                ])
                ->query(
                    fn(FunnelService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByCreatedAt(query: $query, data: $data)
                )
                ->indicateUsing(
                    fn(FunnelService $service, mixed $state): ?string =>
                    $service->tableFilterIndicateUsingByCreatedAt(data: $state),
                ),
            Tables\Filters\Filter::make('updated_at')
                ->label(__('Últ. atualização'))
                ->form([
                    Forms\Components\Grid::make([
                        'default' => 1,
                        'md'      => 2,
                    ])
                        ->schema([
                            Forms\Components\DatePicker::make('updated_from')
                                ->label(__('Últ. atualização de'))
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (Set $set, Get $get, mixed $state): void {
                                        if (!empty($get('updated_until')) && $state > $get('updated_until')) {
                                            $set('updated_until', $state);
                                        }
                                    }
                                ),
                            Forms\Components\DatePicker::make('updated_until')
                                ->label(__('Últ. atualização até'))
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (Set $set, Get $get, mixed $state): void {
                                        if (!empty($get('updated_from')) && $state < $get('updated_from')) {
                                            $set('updated_from', $state);
                                        }
                                    }
                                ),
                        ]),
                ])
                ->query(
                    fn(FunnelService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByUpdatedAt(query: $query, data: $data)
                )
                ->indicateUsing(
                    fn(FunnelService $service, mixed $state): ?string =>
                    $service->tableFilterIndicateUsingByUpdatedAt(data: $state),
                ),
        ];
    }

    public static function infolist(Infolist $infolist): Infolist
    {
        return $infolist
            ->schema([
                Infolists\Components\Tabs::make('Label')
                    ->tabs([
                        Infolists\Components\Tabs\Tab::make(__('Infos. Gerais'))
                            ->schema([
                                Infolists\Components\TextEntry::make('id')
                                    ->label(__('#ID')),
                                Infolists\Components\TextEntry::make('name')
                                    ->label(__('Funil')),
                                Infolists\Components\TextEntry::make('description')
                                    ->label(__('Descrição'))
                                    ->visible(
                                        fn(mixed $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('order')
                                    ->label(__('Ordem')),
                                Infolists\Components\Grid::make(['default' => 3])
                                    ->schema([
                                        Infolists\Components\TextEntry::make('status')
                                            ->label(__('Status'))
                                            ->badge(),
                                        Infolists\Components\TextEntry::make('created_at')
                                            ->label(__('Cadastro'))
                                            ->dateTime('d/m/Y H:i'),
                                        Infolists\Components\TextEntry::make('updated_at')
                                            ->label(__('Últ. atualização'))
                                            ->dateTime('d/m/Y H:i'),
                                    ]),
                            ]),
                        Infolists\Components\Tabs\Tab::make(__('Etapas do Funil'))
                            ->schema([
                                Infolists\Components\RepeatableEntry::make('stages')
                                    ->hiddenLabel()
                                    ->schema([
                                        Infolists\Components\TextEntry::make('name')
                                            ->label(__('Etapa')),
                                        Infolists\Components\TextEntry::make('business_probability')
                                            ->label(__('Probabilidade de negócio'))
                                            ->visible(
                                                fn(mixed $state): bool =>
                                                !empty($state),
                                            ),
                                        Infolists\Components\RepeatableEntry::make('substages')
                                            ->label(_('Sub-etapa(s)'))
                                            ->schema([
                                                Infolists\Components\TextEntry::make('name')
                                                    ->hiddenLabel(),
                                            ])
                                            ->columns(2)
                                            ->columnSpanFull()
                                            ->visible(
                                                fn(FunnelStage $record): bool =>
                                                $record->substages?->count() > 0
                                            ),
                                    ])
                                    ->columns(2)
                                    ->columnSpanFull(),
                            ])
                            ->visible(
                                fn(Funnel $record): bool =>
                                $record->stages?->count() > 0
                            ),
                    ])
                    ->columns(3)
                    ->columnSpanFull(),
            ])
            ->columns(3);
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index'  => Pages\ListFunnels::route('/'),
            'create' => Pages\CreateFunnel::route('/create'),
            'edit'   => Pages\EditFunnel::route('/{record}/edit'),
        ];
    }
}
