<?php

namespace App\Filament\Resources\Financial;

use App\Enums\DefaultStatusEnum;
use App\Enums\Financial\BankAccountRoleEnum;
use App\Enums\Financial\BankAccountTypePersonEnum;
use App\Filament\Resources\Financial\BankAccountResource\Pages;
use App\Filament\Resources\Financial\BankAccountResource\RelationManagers;
use App\Models\Financial\BankAccount;
use App\Models\Financial\BankInstitution;
use App\Services\Financial\BankAccountService;
use App\Services\Financial\BankInstitutionService;
use App\Services\Financial\TransactionService;
use App\Services\System\AgencyService;
use Filament\Infolists;
use Filament\Infolists\Infolist;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Forms\Get;
use Filament\Forms\Set;
use Filament\Resources\Resource;
use Filament\Support;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class BankAccountResource extends Resource
{
    protected static ?string $model = BankAccount::class;

    protected static ?string $recordTitleAttribute = 'name';

    protected static ?string $modelLabel = 'Conta Bancária';

    protected static ?string $pluralModelLabel = 'Contas Bancárias';

    protected static ?string $navigationGroup = 'Financeiro';

    protected static ?int $navigationSort = 98;

    protected static ?string $navigationLabel = 'Contas Bancárias';

    protected static ?string $navigationIcon = 'heroicon-o-wallet';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Select::make('bank_institution_id')
                    ->label(__('Instituição bancária'))
                    ->relationship(
                        name: 'bankInstitution',
                        titleAttribute: 'name',
                        modifyQueryUsing: fn(BankInstitutionService $service, Builder $query): Builder =>
                        $service->getQueryByBankInstitutions(query: $query)
                    )
                    ->getOptionLabelFromRecordUsing(
                        fn(BankInstitution $record): string =>
                        "{$record->code} - {$record->name}"
                    )
                    ->searchable(['name', 'code'])
                    ->preload()
                    ->native(false)
                    ->required(),
                Forms\Components\Select::make('role')
                    ->label(__('Tipo de conta'))
                    ->options(BankAccountRoleEnum::class)
                    ->default(1)
                    ->selectablePlaceholder(false)
                    ->native(false)
                    ->required(),
                Forms\Components\Select::make('type_person')
                    ->label(__('Modalidade'))
                    ->options(BankAccountTypePersonEnum::class)
                    ->default(1)
                    ->selectablePlaceholder(false)
                    ->native(false)
                    ->required(),
                Forms\Components\Select::make('agency_id')
                    ->label(__('Agência'))
                    ->relationship(
                        name: 'agency',
                        titleAttribute: 'name',
                        modifyQueryUsing: fn(AgencyService $service, Builder $query): Builder =>
                        $service->getQueryByAgencies(query: $query)
                    )
                    ->searchable()
                    ->preload()
                    ->native(false),
                Forms\Components\TextInput::make('name')
                    ->label(__('Nome da conta'))
                    ->required()
                    ->maxLength(255)
                    ->unique(ignoreRecord: true)
                    ->columnSpanFull(),
                Forms\Components\TextInput::make('balance')
                    ->label(__('Saldo inicial'))
                    // ->numeric()
                    ->prefix('R$')
                    ->mask(
                        Support\RawJs::make(<<<'JS'
                            $money($input, ',')
                        JS)
                    )
                    ->placeholder('0,00')
                    ->default('0,00')
                    ->required()
                    ->maxValue(42949672.95),
                Forms\Components\DatePicker::make('balance_date')
                    ->label(__('Início dos lançamentos'))
                    ->helperText(__('Valor existente na sua conta antes do primeiro lançamento em nossa aplicação.'))
                    ->displayFormat('d/m/Y')
                    ->seconds(false)
                    ->default(now())
                    ->maxDate(now())
                    ->required(),
                Forms\Components\Toggle::make('is_main')
                    ->label(__('Utilizar como conta principal'))
                    ->helperText('Com esta opção selecionada, esta conta bancária vai vir pré-preenchida por padrão quando você criar receitas e despesas. Você pode alterar isso a qualquer momento.')
                    ->inline(false)
                    ->default(
                        fn(): bool =>
                        BankAccount::all()
                            ->count() === 0
                    )
                    ->accepted(
                        fn(): bool =>
                        BankAccount::all()
                            ->count() === 0
                    )
                    ->live()
                    ->afterStateUpdated(
                        fn(mixed $state, Set $set): ?int =>
                        $state ? $set('status', 1) : null,
                    )
                    ->disabled(
                        fn(?BankAccount $record): bool =>
                        $record && $record->is_main,
                    ),
                Forms\Components\Select::make('status')
                    ->label(__('Status'))
                    ->options(DefaultStatusEnum::class)
                    ->default(1)
                    ->selectablePlaceholder(false)
                    ->native(false)
                    ->required()
                    ->disabled(
                        fn(Get $get, ?BankAccount $record): bool =>
                        $get('is_main') || ($record && $record->is_main)
                    )
                    ->dehydrated()
                    ->visibleOn('edit'),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->striped()
            ->columns(static::getTableColumns())
            ->defaultSort(
                fn(TransactionService $service, Builder $query): Builder =>
                $service->tableDefaultSort(query: $query),
            )
            ->filters(static::getTableFilters(), layout: Tables\Enums\FiltersLayout::AboveContentCollapsible)
            ->filtersFormColumns(2)
            ->actions([
                Tables\Actions\ActionGroup::make([
                    Tables\Actions\ActionGroup::make([
                        Tables\Actions\ViewAction::make(),
                        Tables\Actions\EditAction::make()
                            ->mutateRecordDataUsing(
                                fn(BankAccountService $service, BankAccount $record, array $data): array =>
                                $service->mutateRecordDataToEdit(bankAccount: $record, data: $data)
                            )
                            ->mutateFormDataUsing(
                                fn(BankAccountService $service, BankAccount $record, array $data): array =>
                                $service->mutateFormDataToEdit(bankAccount: $record, data: $data)
                            )
                            ->before(
                                fn(BankAccountService $service, BankAccount $record, array $data) =>
                                $service->beforeEditAction(bankAccount: $record, data: $data)
                            )
                            ->after(
                                fn(BankAccountService $service, BankAccount $record, array $data) =>
                                $service->afterEditAction(bankAccount: $record, data: $data)
                            ),
                    ])
                        ->dropdown(false),
                    Tables\Actions\DeleteAction::make()
                        ->before(
                            fn(BankAccountService $service, Tables\Actions\DeleteAction $action, BankAccount $record) =>
                            $service->preventDeleteIf(action: $action, bankAccount: $record)
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
                            fn(BankAccountService $service, Collection $records) =>
                            $service->deleteBulkAction(records: $records)
                        )
                        ->hidden(
                            fn(): bool =>
                            !auth()->user()->can('Deletar [Financeiro] Contas Bancárias'),
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
                ->label(__('Conta'))
                ->searchable()
                ->sortable(),
            Tables\Columns\TextColumn::make('bankInstitution.name')
                ->label(__('Instituição bancária'))
                ->searchable()
                ->sortable()
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('role')
                ->label(__('Tipo de conta'))
                ->description(
                    fn(BankAccount $record): string =>
                    $record->type_person->getLabel(),

                )
                ->searchable()
                ->sortable()
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('agency.name')
                ->label(__('Agência'))
                ->badge()
                ->searchable()
                ->sortable()
                ->toggleable(isToggledHiddenByDefault: true),
            Tables\Columns\TextColumn::make('display_balance')
                ->label(__('Saldo inicial (R$)'))
                // ->searchable()
                ->sortable()
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\IconColumn::make('is_main')
                ->label(__('Principal'))
                ->icon(
                    fn(bool $state): string =>
                    match ($state) {
                        false => 'heroicon-m-minus-small',
                        true  => 'heroicon-o-check-circle',
                    }
                )
                ->color(
                    fn(bool $state): string =>
                    match ($state) {
                        true    => 'success',
                        default => 'gray',
                    }
                )
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('status')
                ->label(__('Status'))
                ->badge()
                ->searchable(
                    query: fn(BankAccountService $service, Builder $query, string $search): Builder =>
                    $service->tableSearchByStatus(query: $query, search: $search)
                )
                ->sortable(
                    query: fn(BankAccountService $service, Builder $query, string $direction): Builder =>
                    $service->tableSortByStatus(query: $query, direction: $direction)
                )
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('balance_date')
                ->label(__('Lançamento'))
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
                ->toggleable(isToggledHiddenByDefault: true),
        ];
    }

    protected static function getTableFilters(): array
    {
        return [
            Tables\Filters\SelectFilter::make('bank_institutions')
                ->label(__('Instituição(ões) bancária(s)'))
                ->relationship(
                    name: 'bankInstitution',
                    titleAttribute: 'name',
                    modifyQueryUsing: fn(Builder $query): Builder =>
                    $query->whereHas('bankAccounts'),
                )
                ->multiple()
                ->preload(),
            Tables\Filters\SelectFilter::make('role')
                ->label(__('Tipo(s) de conta(s)'))
                ->multiple()
                ->options(BankAccountRoleEnum::class),
            Tables\Filters\SelectFilter::make('type_person')
                ->label(__('Modalidade(s)'))
                ->multiple()
                ->options(BankAccountTypePersonEnum::class),
            Tables\Filters\SelectFilter::make('agencies')
                ->label(__('Agência(s)'))
                ->relationship(
                    name: 'agency',
                    titleAttribute: 'name',
                    modifyQueryUsing: fn(Builder $query): Builder =>
                    $query->whereHas('bankAccounts'),
                )
                ->multiple()
                ->preload(),
            Tables\Filters\SelectFilter::make('status')
                ->label(__('Status'))
                ->multiple()
                ->options(DefaultStatusEnum::class),
            Tables\Filters\Filter::make('balance_date')
                ->label(__('Lançamento'))
                ->form([
                    Forms\Components\Grid::make([
                        'default' => 1,
                        'md'      => 2,
                    ])
                        ->schema([
                            Forms\Components\DatePicker::make('balance_from')
                                ->label(__('Lançamento de'))
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (mixed $state, Set $set, Get $get): void {
                                        if (!empty($get('balance_until')) && $state > $get('balance_until')) {
                                            $set('balance_until', $state);
                                        }
                                    }
                                ),
                            Forms\Components\DatePicker::make('balance_until')
                                ->label(__('Lançamento até'))
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (mixed $state, Set $set, Get $get): void {
                                        if (!empty($get('balance_from')) && $state < $get('balance_from')) {
                                            $set('balance_from', $state);
                                        }
                                    }
                                ),
                        ]),
                ])
                ->query(
                    fn(BankAccountService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByBalanceDate(query: $query, data: $data)
                )
                ->indicateUsing(
                    fn(BankAccountService $service, mixed $state): ?string =>
                    $service->indicateUsingByDates(from: $state['balance_from'], until: $state['balance_until'], display: 'Lançamento'),
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
                                    function (mixed $state, Set $set, Get $get): void {
                                        if (!empty($get('created_until')) && $state > $get('created_until')) {
                                            $set('created_until', $state);
                                        }
                                    }
                                ),
                            Forms\Components\DatePicker::make('created_until')
                                ->label(__('Cadastro até'))
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (mixed $state, Set $set, Get $get): void {
                                        if (!empty($get('created_from')) && $state < $get('created_from')) {
                                            $set('created_from', $state);
                                        }
                                    }
                                ),
                        ]),
                ])
                ->query(
                    fn(BankAccountService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByCreatedAt(query: $query, data: $data)
                )
                ->indicateUsing(
                    fn(BankAccountService $service, mixed $state): ?string =>
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
                                    function (mixed $state, Set $set, Get $get): void {
                                        if (!empty($get('updated_until')) && $state > $get('updated_until')) {
                                            $set('updated_until', $state);
                                        }
                                    }
                                ),
                            Forms\Components\DatePicker::make('updated_until')
                                ->label(__('Últ. atualização até'))
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (mixed $state, Set $set, Get $get): void {
                                        if (!empty($get('updated_from')) && $state < $get('updated_from')) {
                                            $set('updated_from', $state);
                                        }
                                    }
                                ),
                        ]),
                ])
                ->query(
                    fn(BankAccountService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByUpdatedAt(query: $query, data: $data)
                )
                ->indicateUsing(
                    fn(BankAccountService $service, mixed $state): ?string =>
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
                                    ->label(__('Conta')),
                                Infolists\Components\TextEntry::make('bankInstitution.name')
                                    ->label(__('Instituição bancária'))
                                    ->visible(
                                        fn(mixed $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('role')
                                    ->label(__('Tipo de conta'))
                                    ->visible(
                                        fn(mixed $state): bool =>
                                        !is_null($state),
                                    ),
                                Infolists\Components\TextEntry::make('type_person')
                                    ->label(__('Modalidade'))
                                    ->visible(
                                        fn(mixed $state): bool =>
                                        !is_null($state),
                                    ),
                                Infolists\Components\TextEntry::make('agency.name')
                                    ->label(__('Agência'))
                                    ->badge()
                                    ->visible(
                                        fn(mixed $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('display_balance')
                                    ->label(__('Saldo inicial (R$)'))
                                    ->visible(
                                        fn(mixed $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('balance_date')
                                    ->label(__('Início dos lançamentos'))
                                    ->dateTime('d/m/Y'),
                                Infolists\Components\IconEntry::make('is_main')
                                    ->label(__('Principal'))
                                    ->icon(
                                        fn(mixed $state): string =>
                                        match ($state) {
                                            false => 'heroicon-m-minus-small',
                                            true  => 'heroicon-o-check-circle',
                                        }
                                    )
                                    ->color(
                                        fn(mixed $state): string =>
                                        match ($state) {
                                            true    => 'success',
                                            default => 'gray',
                                        }
                                    ),
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
                        Infolists\Components\Tabs\Tab::make(__('Histórico de Interações'))
                            ->schema([
                                Infolists\Components\RepeatableEntry::make('logActivities')
                                    ->label('Interação(ões)')
                                    ->hiddenLabel()
                                    ->schema([
                                        Infolists\Components\TextEntry::make('description')
                                            ->hiddenLabel()
                                            ->html()
                                            ->columnSpan(3),
                                        Infolists\Components\TextEntry::make('causer.name')
                                            ->label(__('Por:')),
                                        Infolists\Components\TextEntry::make('created_at')
                                            ->label(__('Cadastro'))
                                            ->dateTime('d/m/Y H:i'),
                                    ])
                                    ->columns(5)
                                    ->columnSpanFull(),
                            ]),
                    ])
                    ->columns(3)
                    ->columnSpanFull(),
            ])
            ->columns(3);
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ManageBankAccounts::route('/'),
        ];
    }
}
