<?php

namespace App\Filament\Resources\Polymorphics\RelationManagers;

use Spatie\Activitylog\Models\Activity as ActivityLog;
use App\Services\Polymorphics\ActivityLogService;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Forms\Get;
use Filament\Forms\Set;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Support;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Filament\Infolists;
use Filament\Infolists\Infolist;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class ActivityLogRelationManager extends RelationManager
{
    protected static string $relationship = 'logActivities';

    protected static ?string $title = 'Interações';

    protected static ?string $modelLabel = 'Interação';

    public function form(Form $form): Form
    {
        return $form
            ->schema([
                //
            ]);
    }

    public function table(Table $table): Table
    {
        return $table
            ->recordTitleAttribute('description')
            ->striped()
            ->columns(static::getTableColumns())
            ->defaultSort(column: 'id', direction: 'desc')
            ->filters(static::getTableFilters(), layout: Tables\Enums\FiltersLayout::AboveContentCollapsible)
            ->filtersFormColumns(2)
            ->headerActions([
                //
            ])
            ->actions([
                Tables\Actions\ActionGroup::make([
                    Tables\Actions\ActionGroup::make([
                        Tables\Actions\ViewAction::make(),
                        // Tables\Actions\EditAction::make(),
                    ])
                        ->dropdown(false),
                    // Tables\Actions\DeleteAction::make(),
                ])
                    ->label(__('Ações'))
                    ->icon('heroicon-m-chevron-down')
                    ->size(Support\Enums\ActionSize::ExtraSmall)
                    ->color('gray')
                    ->button(),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    // Tables\Actions\DeleteBulkAction::make(),
                ]),
            ])
            ->emptyStateActions([
                // Tables\Actions\CreateAction::make(),
            ]);
    }

    protected function getTableColumns(): array
    {
        return [
            Tables\Columns\TextColumn::make('description')
                ->label(__('Descrição'))
                ->searchable()
                ->html(),
            Tables\Columns\TextColumn::make('causer.name')
                ->label(__('Responsável'))
                ->sortable()
                ->searchable()
                ->toggleable(),
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

    protected function getTableFilters(): array
    {
        return [
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
                    fn(ActivityLogService $service, Builder $query, array $data): Builder =>
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
                    fn(ActivityLogService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByUpdatedAt(query: $query, data: $data)
                ),
        ];
    }

    public function infolist(Infolist $infolist): Infolist
    {
        return $infolist
            ->schema([
                Infolists\Components\Tabs::make('Label')
                    ->tabs([
                        Infolists\Components\Tabs\Tab::make(__('Infos. Gerais'))
                            ->schema([
                                Infolists\Components\TextEntry::make('description')
                                    ->label(__('Descrição'))
                                    ->html()
                                    ->columnSpanFull(),
                                Infolists\Components\Grid::make(['default' => 3])
                                    ->schema([
                                        Infolists\Components\TextEntry::make('causer.name')
                                            ->label(__('Responsável')),
                                        Infolists\Components\TextEntry::make('created_at')
                                            ->label(__('Cadastro'))
                                            ->dateTime('d/m/Y H:i'),
                                        Infolists\Components\TextEntry::make('updated_at')
                                            ->label(__('Últ. atualização'))
                                            ->dateTime('d/m/Y H:i'),
                                    ]),
                            ]),
                        Infolists\Components\Tabs\Tab::make(__('Dados e alterações'))
                            ->schema([
                                Infolists\Components\ViewEntry::make('data_audit')
                                    ->state(fn(ActivityLog $record) => $record)
                                    ->view('filament.infolists.polymorphics.activity-log-data-audit-wrapper')
                                    ->columnSpanFull(),
                            ])
                            ->visible(
                                fn(ActivityLog $record): bool =>
                                filled($record->getExtraProperty('attributes'))
                                || filled($record->getExtraProperty('old'))
                            ),
                    ])
                    ->columns(3)
                    ->columnSpanFull(),

            ])
            ->columns(3);
    }

    public static function canViewForRecord(Model $ownerRecord, string $pageClass): bool
    {
        // $ownerRecord->getTable();

        return true;
    }
}
