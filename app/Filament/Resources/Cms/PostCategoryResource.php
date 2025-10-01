<?php

namespace App\Filament\Resources\Cms;

use App\Enums\DefaultStatusEnum;
use App\Filament\Resources\Cms\PostCategoryResource\Pages;
use App\Filament\Resources\Cms\PostCategoryResource\RelationManagers;
use App\Models\Cms\PostCategory;
use App\Services\Cms\PostCategoryService;
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
use Illuminate\Support\Str;

class PostCategoryResource extends Resource
{
    protected static ?string $model = PostCategory::class;

    protected static ?string $recordTitleAttribute = 'name';

    protected static ?string $modelLabel = 'Categoria';

    protected static ?string $pluralModelLabel = 'Categorias das Postagens';

    protected static ?string $navigationGroup = 'CMS & Marketing';

    protected static ?int $navigationSort = 99;

    protected static ?string $navigationLabel = 'Categorias das Postagens';

    protected static ?string $navigationIcon = 'heroicon-o-tag';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\TextInput::make('name')
                    ->label(__('Nome'))
                    ->required()
                    ->minLength(2)
                    ->maxLength(255)
                    ->live(onBlur: true)
                    ->afterStateUpdated(
                        function (string $operation, Set $set, mixed $state): void {
                            if ($operation === 'edit') {
                                $set('cms_post.slug', Str::slug($state));
                            }
                        }
                    )
                    ->columnSpanFull(),
                Forms\Components\TextInput::make('slug')
                    ->label(__('Slug'))
                    ->helperText(__('O "slug" é a versão do nome amigável para URL. Geralmente é todo em letras minúsculas e contém apenas letras, números e hifens.'))
                    ->required()
                    ->maxLength(255)
                    ->unique(ignoreRecord: true)
                    ->visibleOn('edit')
                    ->columnSpanFull(),
                Forms\Components\Select::make('status')
                    ->label(__('Status'))
                    ->options(DefaultStatusEnum::class)
                    ->default(1)
                    ->selectablePlaceholder(false)
                    ->native(false)
                    ->required(),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->striped()
            ->columns(static::getTableColumns())
            ->defaultSort(column: 'order', direction: 'asc')
            ->reorderable(column: 'order')
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
                            fn(PostCategoryService $service, Tables\Actions\DeleteAction $action, PostCategory $record) =>
                            $service->preventDeleteIf(action: $action, postCategory: $record)
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
                            fn(PostCategoryService $service, Collection $records) =>
                            $service->deleteBulkAction(records: $records)
                        )
                        ->hidden(
                            fn(): bool =>
                            !auth()->user()->can('Deletar [CMS] Categorias'),
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
                ->label(__('Categoria'))
                ->searchable()
                ->sortable(),
            // Tables\Columns\TextColumn::make('order')
            //     ->label(__('Ordem'))
            //     ->sortable()
            //     ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('status')
                ->label(__('Status'))
                ->badge()
                ->searchable(
                    query: fn(PostCategoryService $service, Builder $query, string $search): Builder =>
                    $service->tableSearchByStatus(query: $query, search: $search)
                )
                ->sortable(
                    query: fn(PostCategoryService $service, Builder $query, string $direction): Builder =>
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
                    fn(PostCategoryService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByCreatedAt(query: $query, data: $data)
                )
                ->indicateUsing(
                    fn(PostCategoryService $service, mixed $state): ?string =>
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
                    fn(PostCategoryService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByUpdatedAt(query: $query, data: $data)
                )
                ->indicateUsing(
                    fn(PostCategoryService $service, mixed $state): ?string =>
                    $service->tableFilterIndicateUsingByUpdatedAt(data: $state),
                ),
        ];
    }

    public static function infolist(Infolist $infolist): Infolist
    {
        return $infolist
            ->schema([
                Infolists\Components\TextEntry::make('id')
                    ->label(__('#ID')),
                Infolists\Components\TextEntry::make('name')
                    ->label(__('Categoria')),
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
            'index' => Pages\ManagePostCategories::route('/'),
        ];
    }
}
