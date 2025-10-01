<?php

namespace App\Filament\Resources\Cms;

use App\Enums\Cms\PostSliderRoleEnum;
use App\Enums\Cms\PostStatusEnum;
use App\Filament\Resources\Cms\MainPostSliderResource\Pages;
use App\Filament\Resources\Cms\MainPostSliderResource\RelationManagers;
use App\Models\Cms\Page;
use App\Models\Cms\PostSlider;
use App\Services\Cms\PostSliderService;
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
use Illuminate\Database\Eloquent\SoftDeletingScope;
use Illuminate\Support\HtmlString;
use Illuminate\Support\Str;
use Livewire\Features\SupportFileUploads\TemporaryUploadedFile;

class MainPostSliderResource extends Resource
{
    protected static ?string $model = PostSlider::class;

    protected static ?string $recordTitleAttribute = 'title';

    protected static ?string $modelLabel = 'Slider';

    protected static ?string $pluralModelLabel = 'Sliders';

    protected static ?string $navigationGroup = 'CMS & Marketing';

    protected static ?string $navigationParentItem = 'Páginas';

    protected static ?int $navigationSort = 1;

    protected static ?string $navigationLabel = 'Sliders';

    protected static ?string $navigationIcon = 'heroicon-o-rectangle-stack';

    public static function form(Form $form): Form
    {
        return $form
            ->schema(static::getFormFields());
    }

    public static function getFormFields(): array
    {
        return [
            Forms\Components\Tabs::make('Tabs')
                ->tabs([
                    Forms\Components\Tabs\Tab::make(__('Infos. Gerais'))
                        ->schema([
                            static::getGeneralInfosFormSection(),
                        ]),
                    Forms\Components\Tabs\Tab::make(__('Infos. Complementares'))
                        ->schema([
                            static::getAdditionalInfosFormSection(),
                        ]),
                ])
                ->columns(2)
                ->columnSpanFull(),
        ];
    }

    protected static function getGeneralInfosFormSection(): Forms\Components\Section
    {
        return Forms\Components\Section::make(__('Infos. Gerais'))
            ->description(__('Visão geral e informações fundamentais sobre a postagem.'))
            ->schema([
                Forms\Components\Grid::make(4)
                    ->schema([
                        Forms\Components\Select::make('role')
                            ->label(__('Tipo do slider'))
                            ->options(PostSliderRoleEnum::class)
                            ->default(1)
                            ->selectablePlaceholder(false)
                            ->native(false)
                            ->required()
                            ->live()
                            ->disabled(
                                fn(string $operation): bool =>
                                $operation === 'edit'
                            )
                            ->columnSpan(3),
                        Forms\Components\Toggle::make('settings.hide_text')
                            ->label(__('Ocultar texto?'))
                            ->inline(false)
                            ->live()
                            ->afterStateUpdated(
                                function (Set $set, mixed $state): void {
                                    if ($state) {
                                        $set('settings.style', 'none');
                                    }
                                }
                            ),
                    ]),
                Forms\Components\TextInput::make('title')
                    ->label(__('Título'))
                    ->required()
                    ->minLength(2)
                    ->maxLength(255)
                    ->columnSpanFull(),
                // Forms\Components\TextInput::make('subtitle')
                //     ->label(__('Subtítulo'))
                //     ->minLength(2)
                //     ->maxLength(255)
                //     ->hidden(
                //         fn(Get $get): bool =>
                //         $get('settings.hide_text') === true
                //     )
                //     ->columnSpanFull(),
                Forms\Components\Textarea::make('body')
                    ->label(__('Conteúdo'))
                    ->rows(4)
                    ->minLength(2)
                    ->maxLength(65535)
                    ->hidden(
                        fn(Get $get): bool =>
                        $get('settings.hide_text') === true
                    )
                    ->columnSpanFull(),
                Forms\Components\Fieldset::make(__('Chamada para ação (CTA)'))
                    ->schema([
                        Forms\Components\TextInput::make('cta.url')
                            ->label(__('URL'))
                            ->url()
                            ->helperText('https://...')
                            ->columnSpan(2),
                        Forms\Components\TextInput::make('cta.call')
                            ->label(__('Chamada'))
                            ->helperText(__('Ex: Saiba mais!')),
                        Forms\Components\Select::make('cta.target')
                            ->label(__('Alvo'))
                            ->options([
                                '_self'  => 'Mesma janela',
                                '_blank' => 'Nova janela',
                            ])
                            ->default('_self')
                            ->selectablePlaceholder(false)
                            ->native(false),
                    ])
                    ->columns(4),
                Forms\Components\TextInput::make('embed_video')
                    ->label(__('Vídeo destaque no Youtube'))
                    ->prefix('.../watch?v=')
                    ->helperText(new HtmlString('https://youtube.com/watch?v=<span class="font-bold">kJQP7kiw5Fk</span>'))
                    ->required(
                        fn(Get $get): bool =>
                        (int) $get('role') === 3
                    )
                    ->maxLength(255)
                    ->hidden(
                        fn(Get $get): bool =>
                        (int) $get('role') !== 3
                    ),
                Forms\Components\SpatieMediaLibraryFileUpload::make('video')
                    ->label(__('Vídeo destaque'))
                    ->helperText(__('Tipo de arquivo permitido: .mp4. // Máx. 15 mb.'))
                    ->collection('video')
                    ->downloadable()
                    ->required(
                        fn(Get $get): bool =>
                        (int) $get('role') === 2
                    )
                    ->acceptedFileTypes(['video/mp4'])
                    ->maxSize(15360)
                    ->getUploadedFileNameForStorageUsing(
                        fn(TemporaryUploadedFile $file, Get $get): string =>
                        (string) str('-' . md5(uniqid()) . '-' . time() . '.' . $file->guessExtension())
                            ->prepend(Str::slug($get('title'))),
                    )
                    ->hidden(
                        fn(Get $get): bool =>
                        (int) $get('role') !== 2
                    ),
                Forms\Components\SpatieMediaLibraryFileUpload::make('image')
                    ->label(__('Imagem destaque'))
                    ->helperText(__('Tipos de arquivo permitidos: .png, .jpg, .jpeg, .gif. // Máx. 1920x1080px // 2 mb.'))
                    ->collection('image')
                    ->image()
                    // ->avatar()
                    ->downloadable()
                    ->imageEditor()
                    ->imageEditorAspectRatios([
                        '16:9', // ex: 1920x1080px
                        // '4:3',  // ex: 1024x768px
                        // '1:1',  // ex: 500x500px
                    ])
                    // ->circleCropper()
                    ->imageResizeTargetWidth('1920')
                    ->imageResizeTargetHeight('1080')
                    ->required(
                        fn(Get $get): bool =>
                        (int) $get('role') === 1
                    )
                    ->acceptedFileTypes(['image/png', 'image/jpeg', 'image/jpg', 'image/gif'])
                    ->maxSize(2048)
                    ->getUploadedFileNameForStorageUsing(
                        fn(TemporaryUploadedFile $file, Get $get): string =>
                        (string) str('-' . md5(uniqid()) . '-' . time() . '.' . $file->guessExtension())
                            ->prepend(Str::slug($get('title'))),
                    ),
            ])
            ->columns(2)
            ->collapsible();
    }

    protected static function getAdditionalInfosFormSection(): Forms\Components\Section
    {
        return Forms\Components\Section::make(__('Infos. Complementares'))
            ->description(__('Forneça informações adicionais relevantes sobre a postagem.'))
            ->schema([
                Forms\Components\Fieldset::make(__('Configs. de estilo'))
                    ->schema([
                        Forms\Components\Select::make('settings.style')
                            ->label(__('Contraste'))
                            ->options([
                                'dark'  => 'Escuro',
                                'light' => 'Claro',
                                'none'  => 'Nenhum'
                            ])
                            ->default('dark')
                            ->selectablePlaceholder(false)
                            ->native(false),
                        Forms\Components\Select::make('settings.image_indent')
                            ->label(__('Identação da imagem'))
                            ->options([
                                'left'   => 'Esquerda',
                                'right'  => 'Direita',
                                'center' => 'Centro',
                                'top'    => 'Topo',
                                'bottom' => 'Base',
                            ])
                            ->default('center')
                            ->selectablePlaceholder(false)
                            ->native(false)
                            ->hidden(
                                fn(Get $get): bool =>
                                (int) $get('role') !== 1
                            ),
                        Forms\Components\Select::make('settings.text_indent')
                            ->label(__('Identação do texto'))
                            ->options([
                                'left'   => 'Esquerda',
                                'right'  => 'Direita',
                                'center' => 'Centro'
                            ])
                            ->default('left')
                            ->selectablePlaceholder(false)
                            ->native(false)
                            ->hidden(
                                fn(Get $get): bool =>
                                $get('settings.hide_text') === true
                            ),
                        Forms\Components\ColorPicker::make('settings.text_color')
                            ->label(__('Cor do texto (hexadecimal)'))
                            ->hidden(
                                fn(Get $get): bool =>
                                $get('settings.hide_text') === true
                            ),
                    ])
                    ->columns(3),
                Forms\Components\Fieldset::make(__('Datas da postagem'))
                    ->schema([
                        Forms\Components\DateTimePicker::make('publish_at')
                            ->label(__('Dt. publicação'))
                            ->displayFormat('d/m/Y H:i')
                            ->seconds(false)
                            ->default(now())
                            ->required(),
                        Forms\Components\DateTimePicker::make('expiration_at')
                            ->label(__('Dt. expiração'))
                            ->displayFormat('d/m/Y H:i')
                            ->seconds(false)
                            ->minDate(
                                fn(Get $get): string =>
                                $get('publish_at')
                            ),
                    ]),
                Forms\Components\Select::make('status')
                    ->label(__('Status'))
                    ->options(PostStatusEnum::class)
                    ->default(1)
                    ->selectablePlaceholder(false)
                    ->native(false)
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
            ->defaultSort(column: 'order', direction: 'asc')
            ->reorderable(column: 'order')
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
                                        fn(PostSlider $record): string =>
                                        self::getUrl('edit', ['record' => $record]),
                                    )
                                    ->hidden(
                                        fn(): bool =>
                                        !auth()->user()->can('Editar [CMS] Sliders'),
                                    ),
                            ]),
                        Tables\Actions\EditAction::make(),
                    ])
                        ->dropdown(false),
                    Tables\Actions\DeleteAction::make()
                        ->label(__('Excluir'))
                        ->before(
                            fn(PostSliderService $service, Tables\Actions\DeleteAction $action, PostSlider $record) =>
                            $service->preventDeleteIf(action: $action, postSlider: $record)
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
                        ->hidden(
                            fn(): bool =>
                            !auth()->user()->can('Deletar [CMS] Sliders'),
                        ),
                ]),
            ])
            ->emptyStateActions([
                Tables\Actions\CreateAction::make(),
            ])
            ->recordAction(Tables\Actions\ViewAction::class)
            ->recordUrl(null);
    }

    public static function getTableColumns(): array
    {
        return [
            Tables\Columns\SpatieMediaLibraryImageColumn::make('image')
                ->label('')
                ->collection('image')
                ->conversion('thumb')
                ->size(45)
                ->limit(1)
                ->circular(),
            Tables\Columns\TextColumn::make('title')
                ->label(__('Título'))
                ->searchable()
                ->sortable(),
            Tables\Columns\TextColumn::make('role')
                ->label(__('Tipo'))
                ->searchable(
                    query: fn(PostSliderService $service, Builder $query, string $search): Builder =>
                    $service->tableSearchByRole(query: $query, search: $search)
                )
                ->sortable(
                    query: fn(PostSliderService $service, Builder $query, string $direction): Builder =>
                    $service->tableSortByRole(query: $query, direction: $direction)
                )
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('order')
                ->label(__('Ordem'))
                ->sortable()
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('status')
                ->label(__('Status'))
                ->badge()
                ->searchable(
                    query: fn(PostSliderService $service, Builder $query, string $search): Builder =>
                    $service->tableSearchByStatus(query: $query, search: $search, enumClass: PostStatusEnum::class)
                )
                ->sortable(
                    query: fn(PostSliderService $service, Builder $query, string $direction): Builder =>
                    $service->tableSortByStatus(query: $query, direction: $direction, enumClass: PostStatusEnum::class)
                )
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('publish_at')
                ->label(__('Publicação'))
                ->dateTime('d/m/Y H:i')
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

    public static function getTableFilters(): array
    {
        return [
            Tables\Filters\SelectFilter::make('role')
                ->label(__('Tipo'))
                ->options(PostSliderRoleEnum::class)
                ->multiple(),
            Tables\Filters\SelectFilter::make('status')
                ->label(__('Status'))
                ->options(PostStatusEnum::class)
                ->multiple(),
            Tables\Filters\Filter::make('publish_at')
                ->label(__('Publicação'))
                ->form([
                    Forms\Components\Grid::make([
                        'default' => 1,
                        'md'      => 2,
                    ])
                        ->schema([
                            Forms\Components\DatePicker::make('publish_from')
                                ->label(__('Publicação de'))
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (Get $get, Set $set, mixed $state): void {
                                        if (!empty($get('publish_until')) && $state > $get('publish_until')) {
                                            $set('publish_until', $state);
                                        }
                                    }
                                ),
                            Forms\Components\DatePicker::make('publish_until')
                                ->label(__('Publicação até'))
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (Get $get, Set $set, mixed $state): void {
                                        if (!empty($get('publish_from')) && $state < $get('publish_from')) {
                                            $set('publish_from', $state);
                                        }
                                    }
                                ),
                        ]),
                ])
                ->query(
                    fn(PostSliderService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByPublishAt(query: $query, data: $data)
                )
                ->indicateUsing(
                    fn(PostSliderService $service, mixed $state): ?string =>
                    $service->tableFilterIndicateUsingByPublishAt(data: $state),
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
                                    function (Get $get, Set $set, mixed $state): void {
                                        if (!empty($get('created_until')) && $state > $get('created_until')) {
                                            $set('created_until', $state);
                                        }
                                    }
                                ),
                            Forms\Components\DatePicker::make('created_until')
                                ->label(__('Cadastro até'))
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (Get $get, Set $set, mixed $state): void {
                                        if (!empty($get('created_from')) && $state < $get('created_from')) {
                                            $set('created_from', $state);
                                        }
                                    }
                                ),
                        ]),
                ])
                ->query(
                    fn(PostSliderService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByCreatedAt(query: $query, data: $data)
                )
                ->indicateUsing(
                    fn(PostSliderService $service, mixed $state): ?string =>
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
                                    function (Get $get, Set $set, mixed $state): void {
                                        if (!empty($get('updated_until')) && $state > $get('updated_until')) {
                                            $set('updated_until', $state);
                                        }
                                    }
                                ),
                            Forms\Components\DatePicker::make('updated_until')
                                ->label(__('Últ. atualização até'))
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (Get $get, Set $set, mixed $state): void {
                                        if (!empty($get('updated_from')) && $state < $get('updated_from')) {
                                            $set('updated_from', $state);
                                        }
                                    }
                                ),
                        ]),
                ])
                ->query(
                    fn(PostSliderService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByUpdatedAt(query: $query, data: $data)
                )
                ->indicateUsing(
                    fn(PostSliderService $service, mixed $state): ?string =>
                    $service->tableFilterIndicateUsingByUpdatedAt(data: $state),
                ),
        ];
    }

    public static function infolist(Infolist $infolist): Infolist
    {
        return $infolist
            ->schema(static::getInfolist())
            ->columns(3);
    }

    public static function getInfolist(): array
    {
        return [
            Infolists\Components\SpatieMediaLibraryImageEntry::make('image')
                ->label(__('Avatar'))
                ->hiddenLabel()
                ->collection('image')
                ->conversion('thumb')
                ->circular()
                ->visible(
                    fn(mixed $state): bool =>
                    !empty($state),
                ),
            Infolists\Components\TextEntry::make('title')
                ->label(__('Título')),
            Infolists\Components\TextEntry::make('role')
                ->label(__('Tipo da postagem'))
                ->badge(),
            Infolists\Components\TextEntry::make('subtitle')
                ->label(__('Subtítulo'))
                ->visible(
                    fn(mixed $state): bool =>
                    !empty($state),
                ),
            Infolists\Components\TextEntry::make('body')
                ->label(__('Conteúdo'))
                ->visible(
                    fn(mixed $state): bool =>
                    !empty($state),
                ),
            Infolists\Components\TextEntry::make('order')
                ->label(__('Ordem'))
                ->visible(
                    fn(mixed $state): bool =>
                    !empty($state),
                ),
            Infolists\Components\Fieldset::make('Chamada para ação (CTA)')
                ->schema([
                    Infolists\Components\TextEntry::make('cta.url')
                        ->label(__('URL'))
                        ->url(
                            fn(string $state): string =>
                            $state,
                        )
                        ->openUrlInNewTab()
                        ->visible(
                            fn(mixed $state): bool =>
                            !empty($state),
                        ),
                    Infolists\Components\TextEntry::make('cta.call')
                        ->label(__('Chamada'))
                        ->visible(
                            fn(mixed $state): bool =>
                            !empty($state),
                        ),
                    Infolists\Components\TextEntry::make('cta.target')
                        ->label(__('Alvo'))
                        ->visible(
                            fn(mixed $state): bool =>
                            !empty($state),
                        ),
                ])
                ->visible(
                    fn(PostSlider $record): bool =>
                    !empty($record->cta['url']),
                )
                ->columns(3)
                ->columnSpanFull(),
            Infolists\Components\Grid::make(['default' => 3])
                ->schema([
                    Infolists\Components\TextEntry::make('status')
                        ->label(__('Status'))
                        ->badge(),
                    Infolists\Components\TextEntry::make('publish_at')
                        ->label(__('Dt. publicação'))
                        ->dateTime('d/m/Y H:i'),
                    Infolists\Components\TextEntry::make('expiration_at')
                        ->label(__('Dt. expiração'))
                        ->dateTime('d/m/Y H:i')
                        ->visible(
                            fn(mixed $state): bool =>
                            !empty($state),
                        ),
                    Infolists\Components\TextEntry::make('created_at')
                        ->label(__('Cadastro'))
                        ->dateTime('d/m/Y H:i'),
                    Infolists\Components\TextEntry::make('updated_at')
                        ->label(__('Últ. atualização'))
                        ->dateTime('d/m/Y H:i'),
                ]),
        ];
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
            'index'  => Pages\ListMainPostSliders::route('/'),
            'create' => Pages\CreateMainPostSlider::route('/create'),
            'edit'   => Pages\EditMainPostSlider::route('/{record}/edit'),
        ];
    }

    public static function getEloquentQuery(): Builder
    {
        $idxPg = Page::whereHas('cmsPost', function (Builder $query): Builder {
            return $query->where('slug', 'index');
        })
            ->firstOrFail();

        $type = MorphMapByClass(model: Page::class);

        return parent::getEloquentQuery()
            ->where('slideable_type', $type)
            ->where('slideable_id', $idxPg->id); // Index
    }
}
