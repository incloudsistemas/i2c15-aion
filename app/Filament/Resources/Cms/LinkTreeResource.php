<?php

namespace App\Filament\Resources\Cms;

use App\Enums\Cms\LinkTreeRoleEnum;
use App\Enums\Cms\PostStatusEnum;
use App\Filament\Resources\Cms\LinkTreeResource\Pages;
use App\Filament\Resources\Cms\LinkTreeResource\RelationManagers;
use App\Models\Cms\LinkTree;
use App\Services\Cms\LinkTreeService;
use App\Services\Cms\PostCategoryService;
use App\Services\Cms\PostService;
use Closure;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Infolists;
use Filament\Infolists\Infolist;
use Filament\Forms\Get;
use Filament\Forms\Set;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Filament\Support;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;
use Illuminate\Support\HtmlString;
use Illuminate\Support\Str;
use Livewire\Features\SupportFileUploads\TemporaryUploadedFile;

class LinkTreeResource extends Resource
{
    protected static ?string $model = LinkTree::class;

    protected static ?string $modelLabel = 'Árvore de Link';

    protected static ?string $navigationGroup = 'CMS & Marketing';

    protected static ?string $navigationParentItem = 'Páginas';

    protected static ?int $navigationSort = 99;

    protected static ?string $navigationLabel = 'Árvore de Links (Bio)';

    protected static ?string $navigationIcon = 'heroicon-o-link';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Select::make('role')
                    ->label(__('Tipo da postagem'))
                    ->options(LinkTreeRoleEnum::class)
                    ->default(1)
                    ->selectablePlaceholder(false)
                    ->native(false)
                    ->required()
                    ->live()
                    ->disabled(
                        fn(string $operation): bool =>
                        $operation === 'edit'
                    )
                    ->columnSpanFull(),
                Forms\Components\TextInput::make('cms_post.title')
                    ->label(__('Título'))
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
                Forms\Components\TextInput::make('cms_post.slug')
                    ->label(__('Slug'))
                    ->helperText(__('O "slug" é a versão do nome amigável para URL. Geralmente é todo em letras minúsculas e contém apenas letras, números e hifens.'))
                    ->required()
                    ->maxLength(255)
                    ->rules([
                        function (PostService $service, ?LinkTree $record): Closure {
                            return function (
                                string $attribute,
                                mixed $state,
                                Closure $fail
                            ) use ($service, $record): void {
                                $postableType = MorphMapByClass(model: static::$model);

                                $service->validateSlug(
                                    record: $record,
                                    postableType: $postableType,
                                    attribute: $attribute,
                                    state: $state,
                                    fail: $fail
                                );
                            };
                        },
                    ])
                    ->visibleOn('edit')
                    ->columnSpanFull(),
                Forms\Components\Select::make('cms_post.categories')
                    ->label(__('Categoria(s)'))
                    ->options(
                        fn(PostCategoryService $service): array =>
                        $service->getOptionsByPostCategories(),
                    )
                    ->multiple()
                    ->searchable()
                    ->preload()
                    ->when(
                        auth()->user()->can('Cadastrar [CMS] Categorias'),
                        fn(Forms\Components\Select $component): Forms\Components\Select =>
                        $component->suffixAction(
                            fn(PostCategoryService $service): Forms\Components\Actions\Action =>
                            $service->quickCreateActionByPostCategories(field: 'cms_post.categories', multiple: true),
                        ),
                    )
                    ->columnSpanFull(),
                Forms\Components\TextInput::make('cms_post.url')
                    ->label(__('URL'))
                    ->url()
                    // ->prefix('https://')
                    ->helperText('https://...')
                    ->required()
                    ->maxLength(255)
                    ->columnSpanFull(),
                Forms\Components\TextInput::make('icon')
                    ->label(__('Ícone'))
                    // ->hint(new HtmlString('<a href="' . route('web.pgs.icons') . '" target="_blank">Buscar Ícones</a>'))
                    ->helperText('bi-123, uil-comment-block, fa-solid fa-0...')
                    // ->required()
                    ->minLength(2)
                    ->maxLength(255)
                    ->visible(
                        fn(Get $get): bool =>
                        (int) $get('role') === 1 // 1 - Padrão
                    )
                    ->columnSpanFull(),
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
                        '4:3',  // ex: 1024x768px
                        '1:1',  // ex: 500x500px
                    ])
                    // ->circleCropper()
                    ->imageResizeTargetWidth('1920')
                    ->imageResizeTargetHeight('1080')
                    ->required(
                        fn(Get $get): bool =>
                        (int) $get('role') === 2 // 2 - Imagem
                    )
                    ->acceptedFileTypes(['image/png', 'image/jpeg', 'image/jpg', 'image/gif'])
                    ->maxSize(2048)
                    ->getUploadedFileNameForStorageUsing(
                        fn(TemporaryUploadedFile $file, Get $get): string =>
                        (string) str('-' . md5(uniqid()) . '-' . time() . '.' . $file->guessExtension())
                            ->prepend(Str::slug($get('cms_post.title'))),
                    )
                    ->visible(
                        fn(Get $get): bool =>
                        (int) $get('role') === 2 // 2 - Imagem
                    ),
                Forms\Components\Fieldset::make(__('Configs. de estilo'))
                    ->schema([
                        Forms\Components\ColorPicker::make('button_settings.color')
                            ->label(__('Cor do botão (hexadecimal)')),
                        Forms\Components\ColorPicker::make('button_settings.text_color')
                            ->label(__('Cor do texto (hexadecimal)')),
                    ])
                    ->columns(2)
                    ->visible(
                        fn(Get $get): bool =>
                        (int) $get('role') === 1 // 1 - Padrão
                    ),
                Forms\Components\Fieldset::make(__('Datas da postagem'))
                    ->schema([
                        Forms\Components\DateTimePicker::make('cms_post.publish_at')
                            ->label(__('Dt. publicação'))
                            ->displayFormat('d/m/Y H:i')
                            ->seconds(false)
                            ->default(now())
                            ->required(),
                        Forms\Components\DateTimePicker::make('cms_post.expiration_at')
                            ->label(__('Dt. expiração'))
                            ->displayFormat('d/m/Y H:i')
                            ->seconds(false)
                            ->minDate(
                                fn(Get $get): string =>
                                $get('cms_post.publish_at')
                            ),
                    ]),
                // Forms\Components\TextInput::make('cms_post.order')
                //     ->numeric()
                //     ->label(__('Ordem'))
                //     ->default(1)
                //     ->minValue(1)
                //     ->maxValue(100),
                Forms\Components\Select::make('cms_post.status')
                    ->label(__('Status'))
                    ->options(PostStatusEnum::class)
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
            ->defaultSort(
                fn(PostService $service, Builder $query): Builder =>
                $service->tableDefaultSort(query: $query, publishAtDirection: 'asc')
            )
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
                                        fn(LinkTree $record): string =>
                                        self::getUrl('edit', ['record' => $record]),
                                    )
                                    ->hidden(
                                        fn(): bool =>
                                        !auth()->user()->can('Editar [CMS] Árvore de Links'),
                                    ),
                            ]),
                        Tables\Actions\EditAction::make()
                            ->mutateRecordDataUsing(
                                fn(LinkTreeService $service, LinkTree $record, array $data): array =>
                                $service->mutateRecordDataToEdit(linkTree: $record, data: $data)
                            )
                            ->mutateFormDataUsing(
                                fn(LinkTreeService $service, LinkTree $record, array $data): array =>
                                $service->mutateFormDataToEdit(linkTree: $record, data: $data)
                            )
                            ->after(
                                fn (LinkTreeService $service, LinkTree $record, array $data) =>
                                $service->afterCreateAction(linkTree: $record, data: $data),
                            ),
                    ])
                        ->dropdown(false),
                    Tables\Actions\DeleteAction::make()
                        ->label(__('Excluir'))
                        ->before(
                            fn(LinkTreeService $service, Tables\Actions\DeleteAction $action, LinkTree $record) =>
                            $service->preventDeleteIf(action: $action, linkTree: $record)
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
                            !auth()->user()->can('Deletar [CMS] Árvore de Links'),
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
            Tables\Columns\TextColumn::make('id')
                ->label(__('#ID'))
                ->searchable()
                ->sortable()
                ->toggleable(isToggledHiddenByDefault: true),
            Tables\Columns\SpatieMediaLibraryImageColumn::make('image')
                ->label('')
                ->collection('image')
                ->conversion('thumb')
                ->size(45)
                ->circular(),
            Tables\Columns\TextColumn::make('cmsPost.title')
                ->label(__('Título'))
                ->searchable()
                ->sortable(),
            Tables\Columns\TextColumn::make('role')
                ->label(__('Tipo'))
                ->badge()
                ->searchable(
                    query: fn(LinkTreeService $service, Builder $query, string $search): Builder =>
                    $service->tableSearchByRole(query: $query, search: $search)
                )
                ->sortable(
                    query: fn(LinkTreeService $service, Builder $query, string $direction): Builder =>
                    $service->tableSortByRole(query: $query, direction: $direction)
                )
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('cmsPost.postCategories.name')
                ->label(__('Categoria(s)'))
                ->badge()
                ->searchable()
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('cmsPost.order')
                ->label(__('Ordem'))
                ->sortable()
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('cmsPost.owner.name')
                ->label(__('Autor'))
                ->searchable()
                ->sortable()
                ->toggleable(isToggledHiddenByDefault: true),
            Tables\Columns\TextColumn::make('cmsPost.status')
                ->label(__('Status'))
                ->badge()
                ->searchable(
                    query: fn(PostService $service, Builder $query, string $search): Builder =>
                    $service->tableSearchByPostStatus(query: $query, search: $search),
                )
                ->sortable(
                    query: fn(PostService $service, Builder $query, string $direction): Builder =>
                    $service->tableSortByPostStatus(query: $query, direction: $direction),
                )
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('cmsPost.publish_at')
                ->label(__('Publicação'))
                ->dateTime('d/m/Y H:i')
                ->sortable()
                ->size(Tables\Columns\TextColumn\TextColumnSize::ExtraSmall)
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('cmsPost.created_at')
                ->label(__('Cadastro'))
                ->dateTime('d/m/Y H:i')
                ->sortable()
                ->size(Tables\Columns\TextColumn\TextColumnSize::ExtraSmall)
                ->toggleable(isToggledHiddenByDefault: true),
            Tables\Columns\TextColumn::make('cmsPost.updated_at')
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
                ->label(__('Tipo(s)'))
                ->options(LinkTreeRoleEnum::class)
                ->multiple(),
            Tables\Filters\SelectFilter::make('cmsPost.postCategories')
                ->label(__('Categoria(s)'))
                ->options(
                    fn(PostService $service): array =>
                    $service->getOptionsByPostCategoriesWhereHasPosts(postableType: MorphMapByClass(model: static::$model))
                )
                ->query(
                    fn(PostService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByPostCategories(query: $query, data: $data)
                )
                ->multiple(),
            Tables\Filters\SelectFilter::make('cmsPost.owners')
                ->label(__('Autor(es)'))
                ->options(
                    fn(PostService $service): array =>
                    $service->getOptionsByPostOwnersWhereHasPosts(postableType: MorphMapByClass(model: static::$model)),
                )
                ->query(
                    fn(PostService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByPostOwners(query: $query, data: $data)
                )
                ->multiple(),
            Tables\Filters\SelectFilter::make('cmsPost.status')
                ->label(__('Status'))
                ->multiple()
                ->options(PostStatusEnum::class)
                ->query(
                    fn(PostService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByPostStatuses(query: $query, data: $data)
                ),
            Tables\Filters\Filter::make('cmsPost.publish_at')
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
                    fn(PostService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByPostPublishAt(query: $query, data: $data)
                )
                ->indicateUsing(
                    fn(PostService $service, mixed $state): ?string =>
                    $service->tableFilterIndicateUsingByPostPublishAt(data: $state),
                ),
            Tables\Filters\Filter::make('cmsPost.created_at')
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
                    fn(PostService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByPostCreatedAt(query: $query, data: $data)
                )
                ->indicateUsing(
                    fn(LinkTreeService $service, mixed $state): ?string =>
                    $service->tableFilterIndicateUsingByCreatedAt(data: $state),
                ),
            Tables\Filters\Filter::make('cmsPost.updated_at')
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
                    fn(PostService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByPostUpdatedAt(query: $query, data: $data)
                )
                ->indicateUsing(
                    fn(LinkTreeService $service, mixed $state): ?string =>
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
                        Infolists\Components\Tabs\Tab::make(__('Dados Gerais'))
                            ->schema([
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
                                Infolists\Components\TextEntry::make('cmsPost.title')
                                    ->label(__('Título')),
                                Infolists\Components\TextEntry::make('role')
                                    ->label(__('Tipo da postagem'))
                                    ->badge(),
                                Infolists\Components\TextEntry::make('cmsPost.postCategories.name')
                                    ->label(__('Categoria(s)'))
                                    ->badge()
                                    ->visible(
                                        fn(mixed $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('cmsPost.subtitle')
                                    ->label(__('Subtítulo'))
                                    ->visible(
                                        fn(mixed $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('cmsPost.excerpt')
                                    ->label(__('Resumo/Chamada'))
                                    ->visible(
                                        fn(mixed $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('cmsPost.url')
                                    ->label(__('URL'))
                                    ->url(
                                        fn(mixed $state): string =>
                                        $state,
                                    )
                                    ->openUrlInNewTab()
                                    ->visible(
                                        fn(mixed $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('icon')
                                    ->label(__('Ícone'))
                                    ->visible(
                                        fn(mixed $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('cmsPost.meta_title')
                                    ->label(__('Título SEO'))
                                    ->visible(
                                        fn(mixed $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('cmsPost.meta_description')
                                    ->label(__('Descrição SEO'))
                                    ->visible(
                                        fn(mixed $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('cmsPost.owner.name')
                                    ->label(__('Autor'))
                                    ->visible(
                                        fn(mixed $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('cmsPost.order')
                                    ->label(__('Ordem')),
                                Infolists\Components\IconEntry::make('cmsPost.featured')
                                    ->label(__('Destaque?'))
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
                                Infolists\Components\IconEntry::make('cmsPost.comment')
                                    ->label(__('Comentário?'))
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
                                        Infolists\Components\TextEntry::make('cmsPost.status')
                                            ->label(__('Status'))
                                            ->badge(),
                                        Infolists\Components\TextEntry::make('cmsPost.publish_at')
                                            ->label(__('Dt. publicação'))
                                            ->dateTime('d/m/Y H:i'),
                                        Infolists\Components\TextEntry::make('cmsPost.expiration_at')
                                            ->label(__('Dt. expiração'))
                                            ->dateTime('d/m/Y H:i')
                                            ->visible(
                                                fn(mixed $state): bool =>
                                                !empty($state),
                                            ),
                                        Infolists\Components\TextEntry::make('cmsPost.created_at')
                                            ->label(__('Cadastro'))
                                            ->dateTime('d/m/Y H:i'),
                                        Infolists\Components\TextEntry::make('cmsPost.updated_at')
                                            ->label(__('Últ. atualização'))
                                            ->dateTime('d/m/Y H:i'),
                                    ]),
                            ]),
                        Infolists\Components\Tabs\Tab::make(__('Conteúdo e Tags'))
                            ->schema([
                                Infolists\Components\TextEntry::make('cmsPost.body')
                                    ->label(__('Conteúdo'))
                                    ->hiddenLabel()
                                    ->html()
                                    ->visible(
                                        fn(mixed $state): bool =>
                                        !empty($state),
                                    )
                                    ->columnSpanFull(),
                                Infolists\Components\TextEntry::make('cmsPost.tags')
                                    ->label(__('Tag(s)'))
                                    ->badge()
                                    ->visible(
                                        fn(mixed $state): bool =>
                                        !empty($state),
                                    )
                                    ->columnSpanFull(),
                            ])
                            ->visible(
                                fn(LinkTree $record): bool =>
                                !empty($record->cmsPost->body) || !empty($record->cmsPost->tags)
                            ),
                        Infolists\Components\Tabs\Tab::make(__('Mídias'))
                            ->schema([
                                Infolists\Components\SpatieMediaLibraryImageEntry::make('images')
                                    ->label(__('Galeria de imagens'))
                                    ->collection('images')
                                    ->conversion('thumb')
                                    ->visible(
                                        fn(mixed $state): bool =>
                                        !empty($state),
                                    )
                                    ->columnSpanFull(),
                                Infolists\Components\TextEntry::make('cmsPost.embed_video')
                                    ->label(__('Vídeo destaque no Youtube'))
                                    ->state(
                                        function (LinkTree $record): ?string {
                                            if (!$record->cmsPost->embed_video) {
                                                return null;
                                            }

                                            return "https://www.youtube.com/watch?v={$record->cmsPost->embed_video}";
                                        }
                                    )
                                    ->url(
                                        fn(LinkTree $record): string =>
                                        "https://www.youtube.com/watch?v={$record->cmsPost->embed_video}",
                                    )
                                    ->openUrlInNewTab()
                                    ->visible(
                                        fn(mixed $state): bool =>
                                        !empty($state),
                                    )
                                    ->columnSpanFull(),
                                // Infolists\Components\SpatieMediaLibraryImageEntry::make('videos')
                                //     ->label(__('Galeria de vídeos'))
                                //     ->collection('videos')
                                //     ->visible(
                                //         fn(mixed $state): bool =>
                                //         !empty($state),
                                //     )
                                //     ->columnSpanFull(),
                                Infolists\Components\RepeatableEntry::make('embed_videos')
                                    ->label('Vídeos destaque no Youtube')
                                    ->schema([
                                        Infolists\Components\TextEntry::make('title')
                                            ->label(__('Título'))
                                            ->visible(
                                                fn(mixed $state): bool =>
                                                !empty($state),
                                            ),
                                        Infolists\Components\TextEntry::make('code')
                                            ->label(__('Código Youtube'))
                                            ->url(
                                                fn(mixed $state): string =>
                                                "https://youtube.com/watch?v={$state}"
                                            )
                                            ->openUrlInNewTab()
                                            ->visible(
                                                fn(mixed $state): bool =>
                                                !empty($state),
                                            ),
                                    ])
                                    ->visible(
                                        fn(mixed $state): bool =>
                                        !empty($state),
                                    )
                                    ->columns(2)
                                    ->columnSpanFull(),
                            ])
                            ->visible(
                                fn(LinkTree $record): bool =>
                                in_array('images', $record->settings)
                                || in_array('video', $record->settings)
                                || in_array('embed_video', $record->settings)
                                || in_array('embed_videos', $record->settings),
                            ),
                    ])
                    ->columns(3)
                    ->columnSpanFull(),
            ])
            ->columns(3);
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ManageLinkTrees::route('/'),
        ];
    }

    public static function getEloquentQuery(): Builder
    {
        return parent::getEloquentQuery()
            ->with('cmsPost')
            ->whereHas('cmsPost');
    }
}
