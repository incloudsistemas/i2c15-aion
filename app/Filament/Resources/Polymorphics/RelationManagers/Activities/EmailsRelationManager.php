<?php

namespace App\Filament\Resources\Polymorphics\RelationManagers\Activities;

use App\Models\Polymorphics\Activities\Activity;
use App\Models\Polymorphics\Activities\Email;
use App\Services\Crm\Contacts\ContactService;
use App\Services\Polymorphics\Activities\ActivityService;
use App\Services\Polymorphics\Activities\EmailService;
use App\Services\Polymorphics\MediaService;
use App\Services\System\UserService;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Support;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;
use Livewire\Features\SupportFileUploads\TemporaryUploadedFile;
use Illuminate\Support\Str;
use Filament\Infolists;
use Filament\Infolists\Infolist;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\MediaCollections\Models\Media;

class EmailsRelationManager extends RelationManager
{
    protected static string $relationship = 'activities';

    protected static ?string $title = 'Emails';

    protected static ?string $modelLabel = 'Email';

    public function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Tabs::make('Tabs')
                    ->tabs([
                        Forms\Components\Tabs\Tab::make(__('Infos. Gerais'))
                            ->schema(
                                static::getGeneralInfosFormSection(),
                            ),
                        Forms\Components\Tabs\Tab::make(__('Anexos'))
                            ->schema(
                                static::getAttachmentsFormSection(),
                            ),
                    ])
                    ->columns(2)
                    ->columnSpanFull(),
            ]);
    }

    protected static function getGeneralInfosFormSection(): array
    {
        return [
            Forms\Components\TextInput::make('subject')
                ->label(__('Assunto'))
                ->required()
                ->minLength(2)
                ->maxLength(255)
                ->columnSpanFull(),
            Forms\Components\Fieldset::make(__('Enviar para'))
                ->schema([
                    Forms\Components\Select::make('contacts')
                        ->label(__('Contatos'))
                        ->getSearchResultsUsing(
                            fn(ContactService $service, string $search): array =>
                            $service->getContactOptionsBySearch(search: $search),
                        )
                        ->getOptionLabelsUsing(
                            fn(ContactService $service, array $values): array =>
                            $service->getContactOptionLabels(values: $values),
                        )
                        ->multiple()
                        // ->selectablePlaceholder(false)
                        ->native(false)
                        ->searchable()
                        ->preload()
                        // ->required()
                        ->when(
                            auth()->user()->can('Cadastrar [CRM] Contatos'),
                            fn(Forms\Components\Select $component): Forms\Components\Select =>
                            $component->suffixAction(
                                fn(ContactService $service): Forms\Components\Actions\Action =>
                                $service->quickCreateActionByContacts(field: 'contact_id'),
                            ),
                        )
                        ->columnSpanFull(),
                    Forms\Components\Select::make('users')
                        ->label(__('Usuários'))
                        ->getSearchResultsUsing(
                            fn(UserService $service, string $search): array =>
                            $service->getUserOptionsBySearch(search: $search),
                        )
                        ->getOptionLabelsUsing(
                            fn(UserService $service, array $values): array =>
                            $service->getUserOptionLabels(values: $values),
                        )
                        // ->default([auth()->user()->id])
                        ->multiple()
                        ->selectablePlaceholder(false)
                        ->native(false)
                        ->searchable()
                        ->preload()
                        // ->required()
                        ->columnSpanFull(),
                ]),
            Forms\Components\RichEditor::make('body')
                ->label(__('Descrição'))
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
                ->columnSpanFull(),
            Forms\Components\DateTimePicker::make('email.send_at')
                ->label(__('Dt. envio'))
                ->displayFormat('d/m/Y H:i')
                ->seconds(false)
                ->default(now())
                ->maxDate(now())
                ->required(),
        ];
    }

    protected static function getAttachmentsFormSection(): array
    {
        // Documentos, imagens e arquivos complementares relacionados à atividade.
        return [
            Forms\Components\FileUpload::make('attachments')
                ->label(__('Anexar arquivo(s)'))
                ->helperText(__('Máx. 10 arqs. // 5 mb.'))
                ->directory('attachments')
                ->multiple()
                ->reorderable()
                ->appendFiles()
                ->downloadable()
                // ->required()
                ->maxSize(5120)
                ->maxFiles(10)
                // ->panelLayout('grid')
                ->getUploadedFileNameForStorageUsing(
                    fn(TemporaryUploadedFile $file, callable $get): string =>
                    (string) str('-' . md5(uniqid()) . '-' . time() . '.' . $file->guessExtension())
                        ->prepend(Str::slug($get('subject'))),
                )
                // ->hidden(
                //     fn(string $operation): bool =>
                //     $operation === 'edit'
                // )
                ->columnSpanFull(),
            Forms\Components\Repeater::make('current_attachments')
                ->label(__('Arquivo(s)'))
                ->relationship(
                    name: 'media',
                    // titleAttribute: 'name',
                    modifyQueryUsing: fn(MediaService $service, Builder $query): Builder =>
                    $service->getQueryByAttachments(query: $query)
                )
                ->schema([
                    Forms\Components\Hidden::make('file_name'),
                    Forms\Components\TextInput::make('name')
                        ->label(__('Nome'))
                        ->required()
                        ->maxLength(255)
                        ->hintAction(
                            Forms\Components\Actions\Action::make('download')
                                ->label(__('Download'))
                                ->icon('heroicon-s-arrow-down-tray')
                                ->action(
                                    fn(Media $record) =>
                                    response()->download($record->getPath(), $record->file_name),
                                ),
                        )
                        // ->disabled()
                        ->columnSpanFull(),
                    Forms\Components\Placeholder::make('mime_type')
                        ->label(__('Mime'))
                        ->content(
                            fn(Media $record): string =>
                            $record->mime_type
                        ),
                    Forms\Components\Placeholder::make('size')
                        ->label(__('Tamanho'))
                        ->content(
                            fn(Media $record): string =>
                            AbbrNumberFormat($record->size)
                        ),
                    Forms\Components\Placeholder::make('created_at')
                        ->label(__('Cadastro'))
                        ->content(
                            fn(Media $record): string =>
                            $record->created_at->format('d/m/Y H:i')
                        ),
                ])
                ->itemLabel(
                    fn(array $state): ?string =>
                    $state['file_name'] ?? null
                )
                // ->addActionLabel(__('Adicionar'))
                ->addable(false)
                ->defaultItems(0)
                ->orderColumn('order_column')
                ->reorderableWithButtons()
                ->collapsible()
                ->collapseAllAction(
                    fn(Forms\Components\Actions\Action $action) =>
                    $action->label(__('Minimizar todos'))
                )
                // ->deletable(false)
                ->deleteAction(
                    fn(Forms\Components\Actions\Action $action) =>
                    $action->requiresConfirmation()
                )
                ->visibleOn('edit')
                ->columnSpanFull()
                ->columns(3),
        ];
    }

    public function table(Table $table): Table
    {
        return $table
            ->recordTitleAttribute('subject')
            ->modifyQueryUsing(
                fn(ActivityService $service, Builder $query): Builder =>
                $service->getQueryByActivitable(query: $query, model: Email::class),
            )
            ->striped()
            ->columns(static::getTableColumns())
            // ->reorderable('order_column')
            ->defaultSort(column: 'created_at', direction: 'desc')
            ->filters(static::getTableFilters(), layout: Tables\Enums\FiltersLayout::AboveContentCollapsible)
            ->filtersFormColumns(2)
            ->headerActions([
                Tables\Actions\CreateAction::make()
                    ->fillForm(
                        fn(EmailService $service): array =>
                        $service->mutateRecordDataToCreate(ownerRecord: $this->ownerRecord)
                    )
                    ->mutateFormDataUsing(
                        fn(EmailService $service, array $data): array =>
                        $service->mutateFormDataToCreate(ownerRecord: $this->ownerRecord, data: $data),
                    )
                    ->using(
                        fn(EmailService $service, array $data): Model =>
                        $service->createAction(data: $data, ownerRecord: $this->ownerRecord),
                    ),
            ])
            ->actions([
                Tables\Actions\ActionGroup::make([
                    Tables\Actions\ActionGroup::make([
                        Tables\Actions\ViewAction::make(),
                        Tables\Actions\EditAction::make()
                            ->mutateRecordDataUsing(
                                fn(EmailService $service, Activity $record, array $data): array =>
                                $service->mutateRecordDataToEdit(ownerRecord: $this->ownerRecord, activity: $record, data: $data)
                            )
                            ->mutateFormDataUsing(
                                fn(EmailService $service, Activity $record, array $data): array =>
                                $service->mutateFormDataToEdit(ownerRecord: $this->ownerRecord, activity: $record, data: $data)
                            )
                            ->using(
                                fn(EmailService $service, Activity $record, array $data): Model =>
                                $service->editAction(ownerRecord: $this->ownerRecord, activity: $record, data: $data),
                            ),
                    ])
                        ->dropdown(false),
                    Tables\Actions\DeleteAction::make()
                        ->before(
                            fn(EmailService $service, Tables\Actions\DeleteAction $action, Activity $record) =>
                            $service->preventDeleteIf(action: $action, activity: $record)
                        )
                        ->using(
                            fn(EmailService $service, Activity $record): bool =>
                            $service->deleteAction(ownerRecord: $this->ownerRecord, activity: $record),
                        )
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
                Tables\Actions\CreateAction::make(),
            ]);
    }

    protected function getTableColumns(): array
    {
        return [
            Tables\Columns\TextColumn::make('subject')
                ->label(__('Assunto'))
                ->searchable()
                ->sortable(),
            Tables\Columns\TextColumn::make('contacts.name')
                ->label(__('Contato(s)'))
                ->searchable()
                ->sortable()
                ->toggleable(isToggledHiddenByDefault: true),
            Tables\Columns\TextColumn::make('users.name')
                ->label(__('Usuário(s)'))
                ->searchable()
                ->sortable()
                ->toggleable(isToggledHiddenByDefault: true),
            Tables\Columns\TextColumn::make('owner.name')
                ->label(__('Criado por'))
                ->searchable()
                ->sortable()
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('activityable.send_at')
                ->label(__('Dt. envio'))
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

    protected function getTableFilters(): array
    {
        return [
            Tables\Filters\SelectFilter::make('contacts')
                ->label(__('Contato(s)'))
                ->relationship(
                    name: 'contacts',
                    titleAttribute: 'name',
                    modifyQueryUsing: fn(EmailService $service, Builder $query): Builder =>
                    $service->getQueryWhereHasEmails(query: $query),
                )
                ->multiple()
                ->preload(),
            Tables\Filters\SelectFilter::make('users')
                ->label(__('Usuário(s)'))
                ->relationship(
                    name: 'users',
                    titleAttribute: 'name',
                    modifyQueryUsing: fn(EmailService $service, Builder $query): Builder =>
                    $service->getQueryWhereHasEmails(query: $query),
                )
                ->multiple()
                ->preload(),
            Tables\Filters\SelectFilter::make('owners')
                ->label(__('Criado(s) por'))
                ->relationship(
                    name: 'owner',
                    titleAttribute: 'name',
                    modifyQueryUsing: fn(EmailService $service, Builder $query): Builder =>
                    $service->getQueryByOwnersWhereHasEmails(query: $query),
                )
                ->multiple()
                ->preload(),
            Tables\Filters\Filter::make('activityable.send_at')
                ->label(__('Dt. Envio'))
                ->form([
                    Forms\Components\Grid::make([
                        'default' => 1,
                        'md'      => 2,
                    ])
                        ->schema([
                            Forms\Components\DatePicker::make('send_from')
                                ->label(__('Dt. Envio de'))
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (callable $get, callable $set, ?string $state): void {
                                        if (!empty($get('send_until')) && $state > $get('send_until')) {
                                            $set('send_until', $state);
                                        }
                                    }
                                ),
                            Forms\Components\DatePicker::make('send_until')
                                ->label(__('Dt. Envio até'))
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (callable $get, callable $set, ?string $state): void {
                                        if (!empty($get('send_from')) && $state < $get('send_from')) {
                                            $set('send_from', $state);
                                        }
                                    }
                                ),
                        ]),
                ])
                ->query(
                    fn(EmailService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterBySendAt(query: $query, data: $data)
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
                    fn(ActivityService $service, Builder $query, array $data): Builder =>
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
                    fn(ActivityService $service, Builder $query, array $data): Builder =>
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
                                Infolists\Components\TextEntry::make('subject')
                                    ->label(__('Assunto')),
                                Infolists\Components\TextEntry::make('contacts.name')
                                    ->label(__('Contato(s)'))
                                    ->visible(
                                        fn(array|string|null $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('users.name')
                                    ->label(__('Usuário(s)'))
                                    ->visible(
                                        fn(array|string|null $state): bool =>
                                        !empty($state),
                                    ),
                                Infolists\Components\TextEntry::make('body')
                                    ->label(__('Conteúdo'))
                                    ->html()
                                    ->visible(
                                        fn(?string $state): bool =>
                                        !empty($state),
                                    )
                                    ->columnSpanFull(),
                                Infolists\Components\Grid::make(['default' => 3])
                                    ->schema([
                                        Infolists\Components\TextEntry::make('owner.name')
                                            ->label(__('Criado por')),
                                        Infolists\Components\TextEntry::make('activityable.send_at')
                                            ->label(__('Dt. Envio'))
                                            ->dateTime('d/m/Y H:i'),
                                        Infolists\Components\TextEntry::make('created_at')
                                            ->label(__('Cadastro'))
                                            ->dateTime('d/m/Y H:i'),
                                        Infolists\Components\TextEntry::make('updated_at')
                                            ->label(__('Últ. atualização'))
                                            ->dateTime('d/m/Y H:i'),
                                    ]),
                            ]),
                        Infolists\Components\Tabs\Tab::make(__('Anexos'))
                            ->schema([
                                Infolists\Components\RepeatableEntry::make('attachments')
                                    ->label('Arquivo(s)')
                                    ->schema([
                                        Infolists\Components\TextEntry::make('name')
                                            ->label(__('Nome'))
                                            ->helperText(
                                                fn(Media $record): string =>
                                                $record->file_name
                                            )
                                            ->columnSpan(2),
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
                                    ->columns(4)
                                    ->columnSpanFull(),
                            ])
                            ->visible(
                                fn(Activity $record): bool =>
                                $record->attachments?->count() > 0
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
