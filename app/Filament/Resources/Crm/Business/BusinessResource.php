<?php

namespace App\Filament\Resources\Crm\Business;

use App\Enums\Crm\Business\LossReasonEnum;
use App\Enums\Crm\Business\PriorityEnum;
use App\Enums\ProfileInfos\GenderEnum;
use App\Filament\Resources\Crm\Business\BusinessResource\Pages;
use App\Filament\Resources\Crm\Business\BusinessResource\RelationManagers;
use App\Filament\Resources\Polymorphics\RelationManagers\MediaRelationManager;
use App\Models\Crm\Business\Business;
use App\Models\Crm\Funnels\FunnelStage;
use App\Models\Crm\Funnels\FunnelSubstage;
use App\Services\Crm\Business\BusinessService;
use App\Services\Crm\Contacts\ContactService;
use App\Services\Crm\Funnels\FunnelService;
use App\Services\Crm\SourceService;
use App\Services\System\UserService;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Infolists;
use Filament\Infolists\Infolist;
use Filament\Resources\Resource;
use Filament\Support;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\SoftDeletingScope;
use Spatie\MediaLibrary\MediaCollections\Models\Media;

class BusinessResource extends Resource
{
    protected static ?string $model = Business::class;

    protected static ?string $slug = 'crm/business';

    protected static ?string $recordTitleAttribute = 'name';

    protected static ?string $modelLabel = 'Negócio';

    protected static ?string $navigationGroup = 'CRM';

    protected static ?int $navigationSort = 2;

    protected static ?string $navigationIcon = 'heroicon-o-briefcase';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                static::getGeneralInfosFormSection(),
            ]);
    }

    protected static function getGeneralInfosFormSection(): Forms\Components\Section
    {
        return Forms\Components\Section::make(__('Infos. Gerais'))
            ->description(__('Visão geral e informações fundamentais sobre o negócio.'))
            ->schema([
                Forms\Components\TextInput::make('name')
                    ->label(__('Nome do negócio'))
                    ->required()
                    ->minLength(2)
                    ->maxLength(255)
                    ->columnSpanFull(),
                Forms\Components\Select::make('contact_id')
                    ->label(__('Contato'))
                    ->getSearchResultsUsing(
                        fn(ContactService $service, string $search): array =>
                        $service->getContactOptionsBySearch(search: $search),
                    )
                    ->getOptionLabelUsing(
                        fn(ContactService $service, int $value): string =>
                        $service->getContactOptionLabel(value: $value),
                    )
                    // ->multiple()
                    ->selectablePlaceholder(false)
                    ->native(false)
                    ->searchable()
                    ->preload()
                    ->required()
                    ->when(
                        auth()->user()->can('Cadastrar [CRM] Contatos'),
                        fn(Forms\Components\Select $component): Forms\Components\Select =>
                        $component->suffixAction(
                            fn(ContactService $service): Forms\Components\Actions\Action =>
                            $service->quickCreateActionByContacts(field: 'contact_id'),
                        ),
                    )
                    ->columnSpanFull(),
                Forms\Components\Select::make('funnel_id')
                    ->label(__('Funil'))
                    ->relationship(
                        name: 'funnel',
                        titleAttribute: 'name',
                        modifyQueryUsing: fn(FunnelService $service, Builder $query): Builder =>
                        $service->getQueryByFunnels(query: $query),
                    )
                    ->default(
                        fn(FunnelService $service): ?int =>
                        $service->getBusinessDefaultFunnel()
                    )
                    // ->multiple()
                    ->selectablePlaceholder(false)
                    ->native(false)
                    ->searchable()
                    ->preload()
                    ->required()
                    ->live()
                    ->afterStateUpdated(
                        function (callable $set): void {
                            $set('funnel_stage_id', null);
                            $set('funnel_substage_id', null);
                            $set('business_funnel_stage.loss_reason', null);
                        }
                    )
                    ->disabled(
                        fn(string $operation): bool =>
                        $operation === 'edit',
                    ),
                Forms\Components\Select::make('funnel_stage_id')
                    ->label(__('Etapa do negócio'))
                    ->relationship(
                        name: 'stage',
                        titleAttribute: 'name',
                        modifyQueryUsing: fn(FunnelService $service, Builder $query, callable $get): Builder =>
                        $service->getQueryByFunnelStagesFunnel(query: $query, funnelId: $get('funnel_id'))
                    )
                    // ->multiple()
                    ->selectablePlaceholder(false)
                    ->native(false)
                    ->searchable()
                    ->preload()
                    ->required()
                    ->live()
                    ->afterStateUpdated(
                        function (callable $set): void {
                            $set('funnel_substage_id', null);
                            $set('business_funnel_stage.loss_reason', null);
                        }
                    ),
                Forms\Components\Select::make('funnel_substage_id')
                    ->label(__('Sub-etapa do negócio'))
                    ->relationship(
                        name: 'substage',
                        titleAttribute: 'name',
                        modifyQueryUsing: fn(FunnelService $service, Builder $query, callable $get): Builder =>
                        $service->getQueryByFunnelSubstagesFunnelStage(query: $query, funnelStageId: $get('funnel_stage_id')),
                    )
                    // ->multiple()
                    ->selectablePlaceholder(false)
                    ->native(false)
                    ->searchable()
                    ->preload()
                    ->visible(
                        fn(callable $get): bool =>
                        !empty($get('funnel_stage_id'))
                            && FunnelSubstage::where('funnel_stage_id', $get('funnel_stage_id'))->exists(),
                    ),
                Forms\Components\Select::make('business_funnel_stage.loss_reason')
                    ->label(__('Motivo da perda'))
                    ->options(LossReasonEnum::class)
                    // ->default(1)
                    ->selectablePlaceholder(false)
                    ->required()
                    ->native(false)
                    ->visible(
                        fn(callable $get): bool =>
                        !empty($get('funnel_stage_id'))
                            && FunnelStage::find($get('funnel_stage_id'))->business_probability === 0,
                    ),
                Forms\Components\DatePicker::make('business_funnel_stage.business_at')
                    ->label(__('Dt. fechamento'))
                    ->helperText(__('Data de conclusão do negócio.'))
                    ->displayFormat('d/m/Y')
                    ->seconds(false)
                    ->default(now())
                    ->maxDate(now())
                    ->required()
                    ->visible(
                        fn(callable $get): bool =>
                        !empty($get('funnel_stage_id'))
                            && in_array(FunnelStage::find($get('funnel_stage_id'))->business_probability, [0, 100]),
                    ),
                Forms\Components\TextInput::make('price')
                    ->label(__('Valor'))
                    // ->numeric()
                    ->prefix('R$')
                    ->mask(
                        Support\RawJs::make(<<<'JS'
                            $money($input, ',')
                        JS)
                    )
                    ->placeholder('0,00')
                    ->required(
                        fn(callable $get): bool =>
                        !empty($get('funnel_stage_id'))
                            && FunnelStage::find($get('funnel_stage_id'))->business_probability === 100,
                    )
                    ->maxValue(42949672.95),
                Forms\Components\Textarea::make('description')
                    ->label(__('Descrição/observações do negócio'))
                    ->rows(4)
                    ->minLength(2)
                    ->maxLength(65535)
                    ->columnSpanFull(),
                Forms\Components\Select::make('priority')
                    ->label(__('Prioridade'))
                    ->options(PriorityEnum::class)
                    // ->default(1)
                    // ->selectablePlaceholder(false)
                    // ->required()
                    ->native(false),
                Forms\Components\Select::make('source_id')
                    ->label(__('Origem da captação'))
                    ->relationship(
                        name: 'source',
                        titleAttribute: 'name',
                        modifyQueryUsing: fn(SourceService $service, Builder $query): Builder =>
                        $service->getQueryBySources(query: $query),
                    )
                    // ->multiple()
                    // ->selectablePlaceholder(false)
                    ->native(false)
                    ->searchable()
                    ->preload()
                    // ->required()
                    ->when(
                        auth()->user()->can('Cadastrar [CRM] Origens dos Contatos/Negócios'),
                        fn(Forms\Components\Select $component): Forms\Components\Select =>
                        $component->suffixAction(
                            fn(SourceService $service): Forms\Components\Actions\Action =>
                            $service->quickCreateActionBySources(field: 'source_id'),
                        ),
                    ),

                Forms\Components\Select::make('current_user_id')
                    ->label(__('Responsável'))
                    ->getSearchResultsUsing(
                        fn(UserService $service, string $search): array =>
                        $service->getUserOptionsBySearch(search: $search),
                    )
                    ->getOptionLabelUsing(
                        fn(UserService $service, int $value): string =>
                        $service->getUserOptionLabel(value: $value),
                    )
                    ->default(auth()->user()->id)
                    // ->multiple()
                    ->selectablePlaceholder(false)
                    ->native(false)
                    ->searchable()
                    ->preload()
                    ->required(),
                Forms\Components\DatePicker::make('business_at')
                    ->label(__('Dt. competência'))
                    ->helperText(__('Data em que o negócio se iniciou.'))
                    ->displayFormat('d/m/Y')
                    ->seconds(false)
                    ->default(now())
                    ->maxDate(now())
                    ->required(),
            ])
            ->columns(2)
            ->collapsible();
    }

    public static function table(Table $table): Table
    {
        return $table
            ->striped()
            ->columns(static::getTableColumns())
            ->defaultSort(
                fn(BusinessService $service, Builder $query): Builder =>
                $service->tableDefaultSort(query: $query),
            )
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
                                        fn(Business $record): string =>
                                        self::getUrl('edit', ['record' => $record]),
                                    )
                                    ->hidden(
                                        fn(): bool =>
                                        !auth()->user()->can('Editar [CRM] Negócios')
                                    ),
                            ]),
                        Tables\Actions\EditAction::make(),
                    ])
                        ->dropdown(false),
                    Tables\Actions\DeleteAction::make()
                        ->before(
                            fn(BusinessService $service, Tables\Actions\DeleteAction $action, Business $record) =>
                            $service->preventDeleteIf(action: $action, business: $record),
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
                            fn(BusinessService $service, Collection $records) =>
                            $service->deleteBulkAction(records: $records),
                        )
                        ->hidden(
                            fn(): bool =>
                            !auth()->user()->can('Deletar [CRM] Negócios'),
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
            Tables\Columns\TextColumn::make('id')
                ->label(__('#ID'))
                ->searchable()
                ->sortable()
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('name')
                ->label(__('Negócio'))
                ->searchable()
                ->sortable()
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\SpatieMediaLibraryImageColumn::make('contact.contactable.avatar')
                ->label('')
                ->collection('avatar')
                ->conversion('thumb')
                ->size(45)
                ->circular(),
            Tables\Columns\TextColumn::make('contact.name')
                ->label(__('Contato'))
                ->description(
                    fn(Business $record): ?string =>
                    $record->contact->contactable->cpf ?? $record->contact->contactable->cnpj,
                )
                ->searchable()
                ->sortable(),
            Tables\Columns\TextColumn::make('contact.email')
                ->label(__('Email'))
                ->searchable()
                ->toggleable(isToggledHiddenByDefault: true),
            Tables\Columns\TextColumn::make('contact.display_main_phone')
                ->label(__('Telefone'))
                ->toggleable(isToggledHiddenByDefault: true),
            Tables\Columns\TextColumn::make('funnel.name')
                ->label(__('Funil'))
                ->badge()
                ->searchable()
                ->sortable()
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('stage.name')
                ->label(__('Etapa'))
                ->description(
                    fn(BusinessService $service, Business $record): ?string =>
                    $service->getStageDescription(business: $record),
                    // $record->substage?->name
                )
                ->badge()
                ->color(
                    fn(BusinessService $service, Business $record): string =>
                    $service->getStageColor(business: $record),
                )
                ->searchable()
                ->sortable()
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('display_price')
                ->label(__('Valor (R$)'))
                ->sortable(
                    query: fn(BusinessService $service, Builder $query, string $direction): Builder =>
                    $service->tableSortByPrice(query: $query, direction: $direction),
                )
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('priority')
                ->label(__('Prioridade'))
                ->badge()
                ->searchable(
                    query: fn(BusinessService $service, Builder $query, string $search): Builder =>
                    $service->tableSearchByPriority(query: $query, search: $search),
                )
                ->sortable(
                    query: fn(BusinessService $service, Builder $query, string $direction): Builder =>
                    $service->tableSortByPriority(query: $query, direction: $direction),
                )
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('source.name')
                ->label(__('Origem'))
                ->badge()
                ->searchable()
                ->sortable()
                ->toggleable(isToggledHiddenByDefault: true),
            Tables\Columns\TextColumn::make('currentUserRelation.name')
                ->label(__('Responsável'))
                ->searchable(
                    query: fn(BusinessService $service, Builder $query, string $search): Builder =>
                    $service->tableSearchByCurrentUser(query: $query, search: $search),
                )
                ->sortable(
                    query: fn(BusinessService $service, Builder $query, string $direction): Builder =>
                    $service->tableSortByCurrentUser(query: $query, direction: $direction),
                )
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('business_at')
                ->label(__('Dt. competência'))
                ->dateTime('d/m/Y')
                ->sortable()
                ->size(Tables\Columns\TextColumn\TextColumnSize::ExtraSmall)
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('created_at')
                ->label(__('Cadastro'))
                ->dateTime('d/m/Y H:i')
                ->sortable()
                ->size(Tables\Columns\TextColumn\TextColumnSize::ExtraSmall)
                ->toggleable(isToggledHiddenByDefault: true),
            Tables\Columns\TextColumn::make('updated_at')
                ->label(__('Últ. atualização'))
                ->dateTime('d/m/Y H:i')
                ->sortable()
                ->size(Tables\Columns\TextColumn\TextColumnSize::ExtraSmall)
                ->toggleable(isToggledHiddenByDefault: false),
        ];
    }

    protected static function getTableFilters(): array
    {
        return [
            Tables\Filters\Filter::make('funnel_stage_substages')
                ->label(__('Funis'))
                ->form([
                    Forms\Components\Grid::make(['default' => 3])
                        ->schema([
                            Forms\Components\Select::make('funnel_id')
                                ->label(__('Funil'))
                                ->relationship(
                                    name: 'funnel',
                                    titleAttribute: 'name',
                                    // modifyQueryUsing: fn(FunnelService $service, Builder $query): Builder =>
                                    // $service->getQueryByFunnels(query: $query),
                                )
                                // ->default(
                                //     fn(FunnelService $service): ?int =>
                                //     $service->getBusinessDefaultFunnel()
                                // )
                                // ->multiple()
                                // ->selectablePlaceholder(false)
                                ->native(false)
                                ->searchable()
                                ->preload()
                                ->live()
                                ->afterStateUpdated(
                                    function (callable $set): void {
                                        $set('funnel_stage_id', null);
                                        $set('funnel_substages', null);
                                    }
                                ),
                            Forms\Components\Select::make('funnel_stage_id')
                                ->label(__('Etapa do negócio'))
                                ->relationship(
                                    name: 'stage',
                                    titleAttribute: 'name',
                                    modifyQueryUsing: fn(FunnelService $service, Builder $query, callable $get): Builder =>
                                    $service->getQueryByFunnelStagesFunnel(query: $query, funnelId: $get('funnel_id')),
                                )
                                // ->multiple()
                                // ->selectablePlaceholder(false)
                                ->native(false)
                                ->searchable()
                                ->preload()
                                ->live()
                                ->afterStateUpdated(
                                    fn(callable $set) =>
                                    $set('funnel_substages', null)
                                ),
                            Forms\Components\Select::make('funnel_substages')
                                ->label(__('Sub-etapa(s) do negócio'))
                                ->relationship(
                                    name: 'substage',
                                    titleAttribute: 'name',
                                    modifyQueryUsing: fn(FunnelService $service, Builder $query, callable $get): Builder =>
                                    $service->getQueryByFunnelSubstagesFunnelStage(query: $query, funnelStageId: $get('funnel_stage_id')),
                                )
                                ->multiple()
                                // ->selectablePlaceholder(false)
                                ->native(false)
                                ->searchable()
                                ->preload(),
                        ]),
                ])
                ->query(
                    fn(BusinessService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByCurrentBusinessFunnelStages(query: $query, data: $data),
                )
                ->columnSpanFull(),
            Tables\Filters\SelectFilter::make('contacts')
                ->label(__('Contato(s)'))
                ->relationship(
                    name: 'contact',
                    titleAttribute: 'name',
                    modifyQueryUsing: fn(BusinessService $service, Builder $query): Builder =>
                    $service->getQueryByElementsWhereHasBusinessBasedOnAuthRoles(query: $query),
                )
                ->multiple()
                ->preload(),
            Tables\Filters\Filter::make('price')
                ->label(__('Valor (R$)'))
                ->form([
                    Forms\Components\Grid::make(['default' => 2])
                        ->schema([
                            Forms\Components\TextInput::make('min_price')
                                ->label(__('Valor (min)'))
                                ->prefix('R$')
                                ->mask(
                                    Support\RawJs::make(<<<'JS'
                                        $money($input, ',')
                                    JS)
                                )
                                ->placeholder('0,00')
                                ->maxValue(42949672.95)
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (callable $set, callable $get, ?string $state): void {
                                        if (!empty($get('max_price')) && $state > $get('max_price')) {
                                            $set('max_price', $state);
                                        }
                                    }
                                ),
                            Forms\Components\TextInput::make('max_price')
                                ->label(__('Valor (máx)'))
                                ->prefix('R$')
                                ->mask(
                                    Support\RawJs::make(<<<'JS'
                                        $money($input, ',')
                                    JS)
                                )
                                ->placeholder('0,00')
                                ->maxValue(42949672.95)
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (callable $set, callable $get, ?string $state): void {
                                        if (!empty($get('min_price')) && $state < $get('min_price')) {
                                            $set('min_price', $state);
                                        }
                                    }
                                ),
                        ]),
                ])
                ->query(
                    fn(BusinessService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByPrice(query: $query, data: $data),
                ),
            Tables\Filters\SelectFilter::make('priority')
                ->label(__('Prioridade(s)'))
                ->multiple()
                ->options(PriorityEnum::class),
            Tables\Filters\SelectFilter::make('sources')
                ->label(__('Origem(s)'))
                ->relationship(
                    name: 'source',
                    titleAttribute: 'name',
                )
                ->multiple()
                ->preload(),
            Tables\Filters\SelectFilter::make('current_users')
                ->label(__('Responsável(is)'))
                ->relationship(
                    name: 'currentUserRelation',
                    titleAttribute: 'name',
                    modifyQueryUsing: fn(BusinessService $service, Builder $query): Builder =>
                    $service->getQueryByCurrentUsersWhereHasBusinessBasedOnAuthRoles(query: $query),
                )
                ->query(
                    fn(BusinessService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByCurrentUsers(query: $query, data: $data),
                )
                ->multiple()
                ->preload(),
            Tables\Filters\Filter::make('closed_at')
                ->label(__('Dt. fechamento'))
                ->form([
                    Forms\Components\Grid::make([
                        'default' => 1,
                        'md'      => 2,
                    ])
                        ->schema([
                            Forms\Components\DatePicker::make('closed_from')
                                ->label(__('Dt. fechamento de'))
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (callable $get, callable $set, ?string $state): void {
                                        if (!empty($get('closed_until')) && $state > $get('closed_until')) {
                                            $set('closed_until', $state);
                                        }
                                    }
                                ),
                            Forms\Components\DatePicker::make('closed_until')
                                ->label(__('Dt. fechamento até'))
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (callable $get, callable $set, ?string $state): void {
                                        if (!empty($get('closed_from')) && $state < $get('closed_from')) {
                                            $set('closed_from', $state);
                                        }
                                    }
                                ),
                        ]),
                ])
                ->query(
                    fn(BusinessService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByClosedAt(query: $query, data: $data)
                ),
            Tables\Filters\Filter::make('business_at')
                ->label(__('Dt. competência'))
                ->form([
                    Forms\Components\Grid::make([
                        'default' => 1,
                        'md'      => 2,
                    ])
                        ->schema([
                            Forms\Components\DatePicker::make('business_from')
                                ->label(__('Dt. competência de'))
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (callable $get, callable $set, ?string $state): void {
                                        if (!empty($get('business_until')) && $state > $get('business_until')) {
                                            $set('business_until', $state);
                                        }
                                    }
                                ),
                            Forms\Components\DatePicker::make('business_until')
                                ->label(__('Dt. competência até'))
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (callable $get, callable $set, ?string $state): void {
                                        if (!empty($get('business_from')) && $state < $get('business_from')) {
                                            $set('business_from', $state);
                                        }
                                    }
                                ),
                        ]),
                ])
                ->query(
                    fn(BusinessService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByBusinessAt(query: $query, data: $data)
                ),
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
                                    function (callable $get, callable $set, ?string $state): void {
                                        if (!empty($get('created_until')) && $state > $get('created_until')) {
                                            $set('created_until', $state);
                                        }
                                    }
                                ),
                            Forms\Components\DatePicker::make('created_until')
                                ->label(__('Cadastro até'))
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (callable $get, callable $set, ?string $state): void {
                                        if (!empty($get('created_from')) && $state < $get('created_from')) {
                                            $set('created_from', $state);
                                        }
                                    }
                                ),
                        ]),
                ])
                ->query(
                    fn(BusinessService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByCreatedAt(query: $query, data: $data),
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
                                    function (callable $get, callable $set, ?string $state): void {
                                        if (!empty($get('updated_until')) && $state > $get('updated_until')) {
                                            $set('updated_until', $state);
                                        }
                                    }
                                ),
                            Forms\Components\DatePicker::make('updated_until')
                                ->label(__('Últ. atualização até'))
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (callable $get, callable $set, ?string $state): void {
                                        if (!empty($get('updated_from')) && $state < $get('updated_from')) {
                                            $set('updated_from', $state);
                                        }
                                    }
                                ),
                        ]),
                ])
                ->query(
                    fn(BusinessService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByUpdatedAt(query: $query, data: $data),
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
                                    ->label(__('Negócio')),
                                Infolists\Components\TextEntry::make('funnel.name')
                                    ->label(__('Funil'))
                                    ->badge(),
                                Infolists\Components\TextEntry::make('stage.name')
                                    ->label(__('Etapa'))
                                    ->helperText(
                                        fn(BusinessService $service, Business $record): ?string =>
                                        $service->getStageDescription(business: $record)
                                        // $record->substage?->name
                                    )
                                    ->badge()
                                    ->color(
                                        fn(BusinessService $service, Business $record): string =>
                                        $service->getStageColor(business: $record)
                                    ),
                                Infolists\Components\TextEntry::make('display_price')
                                    ->label(__('Valor (R$)'))
                                    ->visible(
                                        fn(?string $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('priority')
                                    ->label(__('Prioridade'))
                                    ->badge()
                                    ->visible(
                                        fn(?PriorityEnum $state): bool =>
                                        !is_null($state),
                                    ),
                                Infolists\Components\TextEntry::make('source.name')
                                    ->label(__('Origem'))
                                    ->visible(
                                        fn(?string $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('currentUserRelation.name')
                                    ->label(__('Responsável')),
                                Infolists\Components\TextEntry::make('owner.name')
                                    ->label(__('Captador'))
                                    ->visible(
                                        fn(Business $record): bool =>
                                        auth()->user()->hasAnyRole(['Superadministrador', 'Administrador'])
                                            && $record->user_id !== $record->currentUser->id,
                                    ),
                                Infolists\Components\TextEntry::make('description')
                                    ->label(__('Descrição'))
                                    ->visible(
                                        fn(?string $state): bool =>
                                        !empty($state),
                                    )
                                    ->columnSpanFull(),
                                Infolists\Components\Grid::make(['default' => 3])
                                    ->schema([
                                        Infolists\Components\TextEntry::make('business_at')
                                            ->label(__('Dt. competência'))
                                            ->date('d/m/Y'),
                                        Infolists\Components\TextEntry::make('created_at')
                                            ->label(__('Cadastro'))
                                            ->dateTime('d/m/Y H:i'),
                                        Infolists\Components\TextEntry::make('updated_at')
                                            ->label(__('Últ. atualização'))
                                            ->dateTime('d/m/Y H:i'),
                                    ]),
                            ]),
                        Infolists\Components\Tabs\Tab::make(__('Infos. do Contato'))
                            ->schema([
                                Infolists\Components\SpatieMediaLibraryImageEntry::make('contact.contactable.avatar')
                                    ->label(__('Avatar'))
                                    ->hiddenLabel()
                                    ->collection('avatar')
                                    ->conversion('thumb')
                                    ->visible(
                                        fn(?array $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('contact.name')
                                    ->label(__('Contato')),
                                Infolists\Components\TextEntry::make('contact.roles.name')
                                    ->label(__('Tipo(s)'))
                                    ->badge()
                                    ->visible(
                                        fn(array|string|null $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('contact.email')
                                    ->label(__('Email'))
                                    ->visible(
                                        fn(?string $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('contact.display_additional_emails')
                                    ->label(__('Emails adicionais'))
                                    ->visible(
                                        fn(array|string|null $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('contact.display_main_phone_with_name')
                                    ->label(__('Telefone'))
                                    ->visible(
                                        fn(?string $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('contact.display_additional_phones')
                                    ->label(__('Telefones adicionais'))
                                    ->visible(
                                        fn(array|string|null $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('contact.contactable.cpf')
                                    ->label(__('CPF'))
                                    ->visible(
                                        fn(?string $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('contact.contactable.rg')
                                    ->label(__('RG'))
                                    ->visible(
                                        fn(?string $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('contact.contactable.gender')
                                    ->label(__('Sexo'))
                                    ->visible(
                                        fn(?GenderEnum $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('contact.contactable.display_birth_date')
                                    ->label(__('Dt. nascimento'))
                                    ->visible(
                                        fn(?string $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('contact.contactable.occupation')
                                    ->label(__('Cargo'))
                                    ->visible(
                                        fn(?string $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('contact.contactable.cnpj')
                                    ->label(__('CNPJ'))
                                    ->visible(
                                        fn(?string $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('contact.contactable.municipal_registration')
                                    ->label(__('Inscrição municipal'))
                                    ->visible(
                                        fn(?string $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('contact.contactable.state_registration')
                                    ->label(__('Inscrição estadual'))
                                    ->visible(
                                        fn(?string $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('contact.contactable.url')
                                    ->label(__('URL do site'))
                                    ->visible(
                                        fn(?string $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('contact.contactable.sector')
                                    ->label(__('Setor'))
                                    ->visible(
                                        fn(?string $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('contact.contactable.monthly_income')
                                    ->label(__('Faturamento mensal'))
                                    ->visible(
                                        fn(?string $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('contact.source.name')
                                    ->label(__('Origem'))
                                    ->visible(
                                        fn(?string $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('contact.owner.name')
                                    ->label(__('Captador'))
                                    ->visible(
                                        fn(?string $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('contact.complement')
                                    ->label(__('Sobre'))
                                    ->visible(
                                        fn(?string $state): bool =>
                                        !empty($state),
                                    )
                                    ->columnSpanFull(),
                                Infolists\Components\TextEntry::make('contact.contactable.main_address.display_full_address')
                                    ->label(__('Endereço'))
                                    ->visible(
                                        fn(?string $state): bool =>
                                        !empty($state),
                                    )
                                    ->columnSpanFull(),
                            ]),
                        Infolists\Components\Tabs\Tab::make(__('Histórico de Atividades'))
                            ->schema([
                                Infolists\Components\RepeatableEntry::make('activities')
                                    ->label('Atividade(s)')
                                    ->schema([
                                        Infolists\Components\TextEntry::make('activity.description')
                                            ->hiddenLabel()
                                            ->columnSpan(3),
                                        Infolists\Components\TextEntry::make('activity.created_at')
                                            ->label(__('Cadastro'))
                                            ->dateTime('d/m/Y H:i'),
                                    ])
                                    ->columns(4)
                                    ->columnSpanFull(),
                            ]),
                        Infolists\Components\Tabs\Tab::make(__('Anexos'))
                            ->schema([
                                Infolists\Components\RepeatableEntry::make('attachments')
                                    ->label('Arquivo(s)')
                                    ->schema([
                                        Infolists\Components\TextEntry::make('name')
                                            ->label(__('Nome')),
                                        Infolists\Components\TextEntry::make('mime_type')
                                            ->label(__('Mime')),
                                        Infolists\Components\TextEntry::make('size')
                                            ->label(__('Tamanho'))
                                            ->state(
                                                fn(Media $record): string =>
                                                AbbrNumberFormat($record->size),
                                            )
                                            ->hintAction(
                                                Infolists\Components\Actions\Action::make('download')
                                                    ->label(__('Download'))
                                                    ->icon('heroicon-s-arrow-down-tray')
                                                    ->action(
                                                        fn(Media $record) =>
                                                        response()->download($record->getPath(), $record->file_name),
                                                    ),
                                            ),
                                    ])
                                    ->columns(3)
                                    ->columnSpanFull(),
                            ])
                            ->visible(
                                fn(Business $record): bool =>
                                $record->attachments?->count() > 0
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
            MediaRelationManager::class,
        ];
    }

    public static function getPages(): array
    {
        return [
            'index'  => Pages\ListBusinesses::route('/'),
            'create' => Pages\CreateBusiness::route('/create'),
            'edit'   => Pages\EditBusiness::route('/{record}/edit'),
        ];
    }

    public static function getEloquentQuery(): Builder
    {
        $user = auth()->user();

        $query = parent::getEloquentQuery()
            ->with('currentUserRelation')
            ->with('contact')
            ->with('currentBusinessFunnelStageRelation');

        if ($user->hasAnyRole(['Superadministrador', 'Administrador'])) {
            return $query;
        }

        return $query->whereHasCurrentUser(userIds: $user->id);
    }
}
