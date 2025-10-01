<?php

namespace App\Filament\Resources\Cms\RelationManagers;

use App\Enums\Cms\PostStatusEnum;
use App\Models\Cms\PostSubcontent;
use App\Services\Cms\PostSubcontentService;
use Filament\Infolists;
use Filament\Infolists\Infolist;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Forms\Get;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Support;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;
use Illuminate\Support\HtmlString;
use Illuminate\Support\Str;
use Livewire\Features\SupportFileUploads\TemporaryUploadedFile;

class SubcontentsRelationManager extends RelationManager
{
    protected static string $relationship = 'subcontents';

    public function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Hidden::make('role')
                    ->default(static::$role),
                Forms\Components\Tabs::make('Tabs')
                    ->tabs([
                        Forms\Components\Tabs\Tab::make(__('Infos. Gerais'))
                            ->schema([
                                static::getGeneralInfosFormSection(),
                            ]),
                        Forms\Components\Tabs\Tab::make(__('Mídias'))
                            ->schema([
                                static::getMediaFormSection(),
                            ]),
                        Forms\Components\Tabs\Tab::make(__('Infos. Complementares'))
                            ->schema([
                                static::getAdditionalInfosFormSection(),
                            ]),
                    ])
                    ->columns(2)
                    ->columnSpanFull(),
            ]);
    }

    protected static function getTitleFormField(): Forms\Components\TextInput
    {
        return Forms\Components\TextInput::make('title')
            ->label(__('Título'))
            ->required()
            ->minLength(2)
            ->maxLength(255)
            ->columnSpanFull();
    }

    protected static function getSubtitleFormField(): Forms\Components\TextInput
    {
        return Forms\Components\TextInput::make('subtitle')
            ->label(__('Subtítulo'))
            ->minLength(2)
            ->maxLength(255)
            ->columnSpanFull();
    }

    protected static function getExcerptFormField(): Forms\Components\Textarea
    {
        return Forms\Components\Textarea::make('excerpt')
            ->label(__('Resumo/Chamada'))
            ->rows(4)
            ->minLength(2)
            ->maxLength(65535)
            ->columnSpanFull();
    }

    protected static function getBodyFormField(): Forms\Components\RichEditor
    {
        return Forms\Components\RichEditor::make('body')
            ->label(__('Conteúdo'))
            ->toolbarButtons([
                'attachFiles',
                'blockquote',
                'bold',
                'bulletList',
                'codeBlock',
                'h2',
                'h3',
                'italic',
                'link',
                'orderedList',
                'redo',
                'strike',
                'undo',
            ])
            ->fileAttachmentsDisk('public')
            ->fileAttachmentsDirectory('pages')
            ->fileAttachmentsVisibility('public')
            ->columnSpanFull();
    }

    protected static function getCtaFormField(): Forms\Components\Fieldset
    {
        return Forms\Components\Fieldset::make(__('Chamada para ação (CTA)'))
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
            ->columns(4);
    }

    protected static function getUrlFormField(): Forms\Components\TextInput
    {
        return Forms\Components\TextInput::make('url')
            ->label(__('URL'))
            ->url()
            // ->prefix('https://')
            ->helperText('https://...')
            ->maxLength(255)
            ->columnSpanFull();
    }

    protected static function getIconFormField(): Forms\Components\TextInput
    {
        return Forms\Components\TextInput::make('icon')
            ->label(__('Ícone'))
            // ->hint(new HtmlString('<a href="' . route('web.pgs.icons') . '" target="_blank">Buscar Ícones</a>'))
            ->helperText('bi-123, uil-comment-block, fa-solid fa-0...')
            ->minLength(2)
            ->maxLength(255)
            ->columnSpanFull();
    }

    protected static function getEmbedVideoFormField(): Forms\Components\TextInput
    {
        return Forms\Components\TextInput::make('embed_video')
            ->label(__('Vídeo destaque no Youtube'))
            ->prefix('.../watch?v=')
            ->helperText(new HtmlString('https://youtube.com/watch?v=<span class="font-bold">kJQP7kiw5Fk</span>'))
            ->maxLength(255);
    }

    protected static function getVideoFormField(): Forms\Components\SpatieMediaLibraryFileUpload
    {
        return Forms\Components\SpatieMediaLibraryFileUpload::make('video')
            ->label(__('Vídeo destaque'))
            ->helperText(__('Tipo de arquivo permitido: .mp4. // Máx. 15 mb.'))
            ->collection('video')
            ->downloadable()
            ->acceptedFileTypes(['video/mp4'])
            ->maxSize(15360)
            ->getUploadedFileNameForStorageUsing(
                fn(TemporaryUploadedFile $file, Get $get): string =>
                (string) str('-' . md5(uniqid()) . '-' . time() . '.' . $file->guessExtension())
                    ->prepend(Str::slug($get('title'))),
            );
    }

    protected static function getImageFormField(): Forms\Components\SpatieMediaLibraryFileUpload
    {
        return Forms\Components\SpatieMediaLibraryFileUpload::make('image')
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
            ->acceptedFileTypes(['image/png', 'image/jpeg', 'image/jpg', 'image/gif'])
            ->maxSize(2048)
            ->getUploadedFileNameForStorageUsing(
                fn(TemporaryUploadedFile $file, Get $get): string =>
                (string) str('-' . md5(uniqid()) . '-' . time() . '.' . $file->guessExtension())
                    ->prepend(Str::slug($get('title'))),
            );
    }

    protected static function getImagesFormField(): Forms\Components\SpatieMediaLibraryFileUpload
    {
        return Forms\Components\SpatieMediaLibraryFileUpload::make('images')
            ->label(__('Imagem destaque'))
            ->helperText(__('Tipos de arquivo permitidos: .png, .jpg, .jpeg, .gif. // Máx. 1920x1080px // 50 arqs. // 5 mb.'))
            ->collection('images')
            ->image()
            ->multiple()
            ->downloadable()
            ->openable()
            ->reorderable()
            ->appendFiles()
            ->imageEditor()
            ->imageEditorAspectRatios([
                '16:9', // ex: 1920x1080px
                '4:3',  // ex: 1024x768px
                '1:1',  // ex: 500x500px
            ])
            // ->circleCropper()
            ->imageResizeTargetWidth('1920')
            ->imageResizeTargetHeight('1080')
            ->acceptedFileTypes(['image/png', 'image/jpeg', 'image/jpg', 'image/gif'])
            // ->required()
            ->maxSize(2048)
            ->maxFiles(50)
            ->getUploadedFileNameForStorageUsing(
                fn(TemporaryUploadedFile $file, Get $get): string =>
                (string) str('-' . md5(uniqid()) . '-' . time() . '.' . $file->guessExtension())
                    ->prepend(Str::slug($get('title'))),
            )
            ->panelLayout('grid')
            ->columnSpanFull();
    }

    protected static function getVideosFormField(): Forms\Components\SpatieMediaLibraryFileUpload
    {
        return Forms\Components\SpatieMediaLibraryFileUpload::make('videos')
            ->label(__('Upload dos vídeos'))
            ->helperText(__('Tipo de arquivo permitido: .mp4. // 5 arqs. // Máx. 15 mb.'))
            ->collection('videos')
            ->multiple()
            ->downloadable()
            ->reorderable()
            ->appendFiles()
            ->acceptedFileTypes(['video/mp4'])
            ->maxSize(15360)
            ->maxFiles(5)
            ->getUploadedFileNameForStorageUsing(
                fn(TemporaryUploadedFile $file, Get $get): string =>
                (string) str('-' . md5(uniqid()) . '-' . time() . '.' . $file->extension())
                    ->prepend(Str::slug($get('title'))),
            )
            ->panelLayout('grid')
            ->columnSpanFull();
    }

    protected static function getEmbedVideosFormField(): Forms\Components\Repeater
    {
        return Forms\Components\Repeater::make('embed_videos')
            ->label(__('Vídeos destaque no Youtube'))
            ->schema([
                Forms\Components\TextInput::make('code')
                    ->label(__('Código Youtube'))
                    ->prefix('.../watch?v=')
                    ->helperText(new HtmlString('https://youtube.com/watch?v=<span class="font-bold">kJQP7kiw5Fk</span>'))
                    ->required()
                    ->maxLength(255),
                Forms\Components\TextInput::make('title')
                    ->label(__('Título do vídeo'))
                    ->minLength(2)
                    ->maxLength(255),
            ])
            ->itemLabel(
                fn(mixed $state): ?string =>
                $state['title'] ?? null
            )
            ->addActionLabel(__('Adicionar novo'))
            ->defaultItems(0)
            ->reorderableWithButtons()
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
            ->columns(2);
    }

    protected static function getTagsFormField(): Forms\Components\TagsInput
    {
        return Forms\Components\TagsInput::make('cms_post.tags')
            ->label(__('Tag(s)'))
            ->helperText(__('As tags são usadas para filtragem e busca. Uma postagem pode ter até 120 tags.'))
            ->nestedRecursiveRules([
                // 'min:1',
                'max:120',
            ])
            ->columnSpanFull();
    }

    protected static function getDatesField(): Forms\Components\Fieldset
    {
        return Forms\Components\Fieldset::make(__('Datas da postagem'))
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
            ]);
    }

    protected static function getOrderFormField(): Forms\Components\TextInput
    {
        return Forms\Components\TextInput::make('order')
            ->numeric()
            ->label(__('Ordem'))
            ->default(1)
            ->minValue(1)
            ->maxValue(100);
    }

    protected static function getStatusFormField(): Forms\Components\Select
    {
        return Forms\Components\Select::make('status')
            ->label(__('Status'))
            ->options(PostStatusEnum::class)
            ->default(1)
            ->selectablePlaceholder(false)
            ->native(false)
            ->required();
    }

    public function table(Table $table): Table
    {
        return $table
            ->striped()
            ->recordTitleAttribute('title')
            ->modifyQueryUsing(
                fn(Builder $query): Builder =>
                $query->byRoles(roles: [static::$role])
            )
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
                    Tables\Actions\DeleteAction::make(),
                ])
                    ->label(__('Ações'))
                    ->icon('heroicon-m-chevron-down')
                    ->size(Support\Enums\ActionSize::ExtraSmall)
                    ->color('gray')
                    ->button(),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DeleteBulkAction::make(),
                ]),
            ])
            ->emptyStateActions([
                Tables\Actions\CreateAction::make(),
            ])
            ->recordAction(Tables\Actions\ViewAction::class)
            ->recordUrl(null);
    }

    public function getTableColumns(): array
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
            Tables\Columns\TextColumn::make('title')
                ->label(__('Título'))
                ->searchable()
                ->sortable(),
            Tables\Columns\TextColumn::make('order')
                ->label(__('Ordem'))
                ->sortable()
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('status')
                ->label(__('Status'))
                ->badge()
                ->searchable(
                    query: fn(PostSubcontentService $service, Builder $query, string $search): Builder =>
                    $service->tableSearchByStatus(query: $query, search: $search, enumClass: PostStatusEnum::class),
                )
                ->sortable(
                    query: fn(PostSubcontentService $service, Builder $query, string $direction): Builder =>
                    $service->tableSortByStatus(query: $query, direction: $direction, enumClass: PostStatusEnum::class),
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

    public function getTableFilters(): array
    {
        return [
            Tables\Filters\SelectFilter::make('status')
                ->label(__('Status'))
                ->multiple()
                ->options(PostStatusEnum::class),
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
                                    function (callable $get, callable $set, ?string $state): void {
                                        if (!empty($get('publish_until')) && $state > $get('publish_until')) {
                                            $set('publish_until', $state);
                                        }
                                    }
                                ),
                            Forms\Components\DatePicker::make('publish_until')
                                ->label(__('Publicação até'))
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (callable $get, callable $set, ?string $state): void {
                                        if (!empty($get('publish_from')) && $state < $get('publish_from')) {
                                            $set('publish_from', $state);
                                        }
                                    }
                                ),
                        ]),
                ])
                ->query(
                    fn(PostSubcontentService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByPublishAt(query: $query, data: $data)
                )
                ->indicateUsing(
                    fn(PostSubcontentService $service, mixed $state): ?string =>
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
                    fn(PostSubcontentService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByCreatedAt(query: $query, data: $data)
                )
                ->indicateUsing(
                    fn(PostSubcontentService $service, mixed $state): ?string =>
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
                    fn(PostSubcontentService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByUpdatedAt(query: $query, data: $data)
                )
                ->indicateUsing(
                    fn(PostSubcontentService $service, mixed $state): ?string =>
                    $service->tableFilterIndicateUsingByUpdatedAt(data: $state),
                ),
        ];
    }

    public function infolist(Infolist $infolist): Infolist
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
                                Infolists\Components\TextEntry::make('title')
                                    ->label(__('Título')),
                                Infolists\Components\TextEntry::make('subtitle')
                                    ->label(__('Subtítulo'))
                                    ->visible(
                                        fn(mixed $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('excerpt')
                                    ->label(__('Resumo/Chamada'))
                                    ->visible(
                                        fn(mixed $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\Fieldset::make('Chamada para ação (CTA)')
                                    ->schema([
                                        Infolists\Components\TextEntry::make('cta.url')
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
                                        fn(PostSubcontent $record): bool =>
                                        !empty($record->cta['url']),
                                    )
                                    ->columns(3)
                                    ->columnSpanFull(),
                                Infolists\Components\TextEntry::make('url')
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
                                Infolists\Components\TextEntry::make('order')
                                    ->label(__('Ordem')),
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
                            ]),
                        Infolists\Components\Tabs\Tab::make(__('Conteúdo e Tags'))
                            ->schema([
                                Infolists\Components\TextEntry::make('body')
                                    ->label(__('Conteúdo'))
                                    ->hiddenLabel()
                                    ->html()
                                    ->visible(
                                        fn(mixed $state): bool =>
                                        !empty($state),
                                    )
                                    ->columnSpanFull(),
                                Infolists\Components\TextEntry::make('tags')
                                    ->label(__('Tag(s)'))
                                    ->badge()
                                    ->visible(
                                        fn(mixed $state): bool =>
                                        !empty($state),
                                    )
                                    ->columnSpanFull(),
                            ])
                            ->visible(
                                fn(PostSubcontent $record): bool =>
                                !empty($record->body) || !empty($record->tags)
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
                                Infolists\Components\TextEntry::make('embed_video')
                                    ->label(__('Vídeo destaque no Youtube'))
                                    ->state(
                                        function (PostSubcontent $record): ?string {
                                            if (!$record->embed_video) {
                                                return null;
                                            }

                                            return "https://www.youtube.com/watch?v={$record->embed_video}";
                                        }
                                    )
                                    ->url(
                                        fn(PostSubcontent $record): string =>
                                        "https://www.youtube.com/watch?v={$record->embed_video}",
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
                                            ->state(
                                                function (mixed $state): ?string {
                                                    return "https://www.youtube.com/watch?v={$state}";
                                                }
                                            )
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
                                fn(PostSubcontent $record): bool =>
                                $record->gallery_images?->isNotEmpty()
                                || !empty($record->embed_video)
                                || $record->gallery_videos?->isNotEmpty()
                                || !empty($record->embed_videos)
                            ),
                    ])
                    ->columns(3)
                    ->columnSpanFull(),
            ])
            ->columns(3);
    }
}
