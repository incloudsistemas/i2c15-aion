<?php

namespace App\Filament\Resources\Financial;

use App\Enums\DefaultStatusEnum;
use App\Filament\Resources\Financial\BankInstitutionResource\Pages;
use App\Filament\Resources\Financial\BankInstitutionResource\RelationManagers;
use App\Models\Financial\BankInstitution;
use App\Services\Financial\BankInstitutionService;
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

class BankInstitutionResource extends Resource
{
    protected static ?string $model = BankInstitution::class;

    protected static ?string $recordTitleAttribute = 'name';

    protected static ?string $modelLabel = 'Instituição Bancária';

    protected static ?string $pluralModelLabel = 'Instituições Bancárias';

    protected static ?string $navigationGroup = 'Financeiro';

    protected static ?string $navigationParentItem = 'Contas Bancárias';

    protected static ?int $navigationSort = 99;

    protected static ?string $navigationLabel = 'Instituições Bancárias';

    protected static ?string $navigationIcon = 'heroicon-o-squares-plus';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\TextInput::make('name')
                    ->label(__('Nome'))
                    ->required()
                    ->minLength(2)
                    ->maxLength(255),
                Forms\Components\TextInput::make('short_name')
                    ->label(__('Nome abreviado'))
                    // ->required()
                    ->minLength(2)
                    ->maxLength(255),
                Forms\Components\TextInput::make('code')
                    ->label(__('Código COMPE'))
                    ->helperText(__('Atribuído pelo Banco Central do Brasil (BACEN) e usado em transações financeiras, como TEDs, DOCs e PIX.'))
                    // ->required()
                    ->minLength(2)
                    ->maxLength(255)
                    ->unique(ignoreRecord: true),
                Forms\Components\TextInput::make('ispb')
                    ->label(__('Ispb'))
                    ->helperText(__('Identificador de Sistema de Pagamentos Brasileiro'))
                    // ->required()
                    ->minLength(2)
                    ->maxLength(255)
                    ->unique(ignoreRecord: true),
                Forms\Components\Select::make('status')
                    ->label(__('Status'))
                    ->options(DefaultStatusEnum::class)
                    ->default(1)
                    ->selectablePlaceholder(false)
                    ->native(false)
                    ->required()
                    ->visibleOn('edit'),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->striped()
            ->columns(static::getTableColumns())
            ->defaultSort(column: 'created_at', direction: 'desc')
            ->filters(static::getTableFilters(), layout: Tables\Enums\FiltersLayout::AboveContentCollapsible)
            ->filtersFormColumns(2)
            ->actions([
                Tables\Actions\ActionGroup::make([
                    Tables\Actions\ActionGroup::make([
                        Tables\Actions\ViewAction::make(),
                        Tables\Actions\EditAction::make(),
                    ])
                        ->dropdown(false),
                    Tables\Actions\DeleteAction::make()
                        ->before(
                            fn(BankInstitutionService $service, Tables\Actions\DeleteAction $action, BankInstitution $record) =>
                            $service->preventDeleteIf(action: $action, bankInstitution: $record)
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
                            fn(BankInstitutionService $service, Collection $records) =>
                            $service->deleteBulkAction(records: $records)
                        )
                        ->hidden(
                            fn(): bool =>
                            !auth()->user()->can('Deletar [Financeiro] Instituições Bancárias'),
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
            Tables\Columns\TextColumn::make('code')
                ->label(__('Código COMPE'))
                ->searchable()
                ->sortable()
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('name')
                ->label(__('Instituição bancária'))
                ->searchable()
                ->sortable(),
            Tables\Columns\TextColumn::make('status')
                ->label(__('Status'))
                ->badge()
                ->searchable(
                    query: fn(BankInstitutionService $service, Builder $query, string $search): Builder =>
                    $service->tableSearchByStatus(query: $query, search: $search)
                )
                ->sortable(
                    query: fn(BankInstitutionService $service, Builder $query, string $direction): Builder =>
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
                    fn(BankInstitutionService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByCreatedAt(query: $query, data: $data)
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
                    fn(BankInstitutionService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByUpdatedAt(query: $query, data: $data)
                ),
        ];
    }

    public static function infolist(Infolist $infolist): Infolist
    {
        return $infolist
            ->schema([
                Infolists\Components\TextEntry::make('id')
                    ->label(__('#ID')),
                Infolists\Components\TextEntry::make('code')
                    ->label(__('Código COMPE'))
                    ->visible(
                        fn(mixed $state): bool =>
                        !empty($state),
                    ),
                Infolists\Components\TextEntry::make('ispb')
                    ->label(__('ISPB'))
                    ->visible(
                        fn(mixed $state): bool =>
                        !empty($state),
                    ),
                Infolists\Components\TextEntry::make('name')
                    ->label(__('Instituição bancária')),
                Infolists\Components\TextEntry::make('short_name')
                    ->label(__('Nome abreviado'))
                    ->visible(
                        fn(mixed $state): bool =>
                        !empty($state),
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
            ])
            ->columns(3);
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ManageBankInstitutions::route('/'),
        ];
    }
}
