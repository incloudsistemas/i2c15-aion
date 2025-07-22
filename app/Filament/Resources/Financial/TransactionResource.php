<?php

namespace App\Filament\Resources\Financial;

use App\Enums\Financial\TransactionPaymentMethodEnum;
use App\Enums\Financial\TransactionRepeatFrequencyEnum;
use App\Enums\Financial\TransactionRepeatPaymentEnum;
use App\Filament\Resources\Financial\TransactionResource\Pages;
use App\Filament\Resources\Financial\TransactionResource\RelationManagers;
use App\Models\Financial\Transaction;
use App\Services\Crm\Contacts\ContactService;
use App\Services\Financial\BankAccountService;
use App\Services\Financial\CategoryService;
use App\Services\Financial\TransactionService;
use App\Services\Polymorphics\MediaService;
use Closure;
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
use Illuminate\Database\Eloquent\Collection;
use Livewire\Features\SupportFileUploads\TemporaryUploadedFile;
use Illuminate\Support\Str;
use Spatie\MediaLibrary\MediaCollections\Models\Media;

abstract class TransactionResource extends Resource
{
    protected static ?string $model = Transaction::class;

    public static function form(Form $form): Form
    {
        return $form
            ->schema(static::getFormSchema(role: static::$role));
    }

    protected static function getFormSchema(int $role): array
    {
        return [
            Forms\Components\Group::make()
                ->schema([
                    Forms\Components\Hidden::make('role')
                        ->default($role),
                    static::getCreateGeneralInfosFormSection(),
                    static::getCreatePaymentMethodFormSection(),
                ])
                ->visibleOn('create')
                ->columnSpanFull(),
            Forms\Components\Group::make()
                ->schema([
                    Forms\Components\Tabs::make('Tabs')
                        ->tabs([
                            Forms\Components\Tabs\Tab::make(__('Condições de Pagamentos'))
                                ->schema(
                                    static::getEditPaymentMethodFormSection(),
                                ),
                            Forms\Components\Tabs\Tab::make(__('Infos. Gerais'))
                                ->schema(
                                    static::getEditGeneralInfosFormSection(),
                                ),
                            Forms\Components\Tabs\Tab::make(__('Anexos'))
                                ->schema(
                                    static::getAttachmentsFormSection(),
                                ),
                        ])
                        ->columns(2)
                        ->columnSpanFull(),
                    Forms\Components\Select::make('change_scope')
                        ->label(__('As alterações nesta transação devem ser refletidas:'))
                        ->helperText(__('*obs: Os anexos não são alterados nas transações relacionadas.'))
                        ->options([
                            1 => 'Somente a transação atual',
                            2 => 'A transação atual e anteriores que não possuem baixas',
                            3 => 'A transação atual e posteriores que não possuem baixas',
                            4 => 'A transação atual e todas outras que não possuem baixas',
                            5 => 'Todas as transações',
                        ])
                        // ->default(1)
                        ->selectablePlaceholder(false)
                        ->native(false)
                        ->required()
                        ->visible(
                            fn(Transaction $record): bool =>
                            $record->mainTransaction()->exists(),
                        )
                        ->columnSpanFull(),
                ])
                ->visibleOn('edit')
                ->columnSpanFull(),
        ];
    }

    protected static function getCreateGeneralInfosFormSection(): Forms\Components\Section
    {
        return Forms\Components\Section::make(__('Infos. Gerais'))
            ->description(__('Visão geral e informações fundamentais sobre a transação.'))
            ->schema([
                static::getContactFormField(),
                Forms\Components\TextInput::make('name')
                    ->label(__('Nome da transação'))
                    ->required()
                    ->minLength(2)
                    ->maxLength(255)
                    ->live(onBlur: true)
                    ->afterStateUpdated(
                        static::updateInstallmentsDataBySpecificFieldCallback(field: 'name')
                    )
                    ->columnSpanFull(),
                static::getCreateCategoriesFormField(),
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
                    ->required()
                    ->maxValue(42949672.95)
                    ->live(onBlur: true)
                    ->afterStateUpdated(
                        static::updateInstallmentsDataBySpecificFieldCallback(field: 'price')
                    ),
                Forms\Components\DatePicker::make('due_at')
                    ->label(__('Dt. vencimento'))
                    ->displayFormat('d/m/Y')
                    ->seconds(false)
                    ->default(now())
                    // ->maxDate(now())
                    ->required()
                    ->live(onBlur: true)
                    ->afterStateUpdated(
                        static::updateInstallmentsDataBySpecificFieldCallback(field: 'due_at')
                    ),
            ])
            ->columns(2)
            ->collapsible();
    }

    protected static function getCreatePaymentMethodFormSection(): Forms\Components\Section
    {
        return Forms\Components\Section::make(__('Condições de Pagamentos'))
            ->description(__('Informe o método, revise e confirme as condições de pagamento.'))
            ->schema([
                Forms\Components\Group::make()
                    ->schema([
                        Forms\Components\Select::make('bank_account_id')
                            ->label(__('Conta bancária'))
                            ->relationship(
                                name: 'bankAccount',
                                titleAttribute: 'name',
                                modifyQueryUsing: fn(BankAccountService $service, Builder $query): Builder =>
                                $service->getQueryByBankAccounts(query: $query)
                            )
                            ->default(
                                fn(BankAccountService $service): ?int =>
                                $service->getTransactionDefaultBankAccount()
                            )
                            ->selectablePlaceholder(false)
                            ->native(false)
                            ->required()
                            ->live()
                            ->afterStateUpdated(
                                static::updateInstallmentsDataBySpecificFieldCallback(field: 'bank_account_id')
                            ),
                        // 1 - Dinheiro, 2 - Pix, 3 - Cheque, 4 - Transferência bancária,
                        // 5 - Cartão de débito, 6 - Cartão de crédito, 7 - Outros...
                        Forms\Components\Select::make('payment_method')
                            ->label(__('Método de pagamento'))
                            ->options(TransactionPaymentMethodEnum::class)
                            // ->default(1)
                            ->selectablePlaceholder(false)
                            ->native(false)
                            ->searchable()
                            ->preload()
                            ->required()
                            ->live()
                            ->afterStateUpdated(
                                static::updateInstallmentsDataBySpecificFieldCallback(field: 'payment_method')
                            ),
                        // 1 - 'À vista', 2 - 'Parcelado', 3 - 'Recorrente'.
                        Forms\Components\Select::make('repeat_payment')
                            ->label(__('Forma de pagamento'))
                            ->options(TransactionRepeatPaymentEnum::class)
                            ->default(1)
                            ->selectablePlaceholder(false)
                            ->native(false)
                            ->required()
                            ->live()
                            ->afterStateUpdated(
                                static::getInstallmentsDataCallback(),
                            ),
                    ])
                    ->columns(3)
                    ->columnSpanFull(),
                Forms\Components\Group::make()
                    ->schema([
                        Forms\Components\Select::make('repeat_frequency')
                            ->label(__('Frequência'))
                            ->options(TransactionRepeatFrequencyEnum::class)
                            // ->default(1)
                            ->selectablePlaceholder(false)
                            ->native(false)
                            ->required()
                            ->hidden(
                                fn(Get $get): bool =>
                                (int) $get('repeat_payment') !== 3 // 3 - Recorrente
                            ),
                        Forms\Components\Select::make('repeat_occurrence')
                            ->label(__('Ocorrências'))
                            ->options(
                                array_combine(
                                    range(1, 24),
                                    array_map(
                                        fn($value) =>
                                        "{$value}x",
                                        range(1, 24)
                                    )
                                )
                            )
                            ->default(1)
                            ->searchable()
                            ->selectablePlaceholder(false)
                            ->native(false)
                            ->required()
                            ->live()
                            ->afterStateUpdated(
                                static::getInstallmentsDataCallback()
                            ),
                    ])
                    ->hidden(
                        fn(Get $get): bool =>
                        (int) $get('repeat_payment') === 1 // 1 - À vista
                    )
                    ->columns(2)
                    ->columnSpanFull(),
                Forms\Components\Repeater::make('installments')
                    ->label(__('Parcelas'))
                    ->schema([
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
                            ->required()
                            ->maxValue(42949672.95)
                            ->live(onBlur: true)
                            ->afterStateUpdated(
                                function (
                                    TransactionService $service,
                                    mixed $state,
                                    Set $set,
                                    Get $get,
                                    Forms\Components\TextInput $component
                                ) {
                                    $path = $component->getStatePath();
                                    preg_match('/installments\.(\d+)\.price$/', $path, $m);
                                    $index = isset($m[1]) ? (int) $m[1] : null;

                                    $installments = $service->recalculateInstallmentsPrice(
                                        state: $state,
                                        totalPrice: $get('../../price'),
                                        installments: $get('../../installments'),
                                        index: $index,
                                    );

                                    $set('../../installments', $installments);
                                }
                            ),
                        Forms\Components\DatePicker::make('due_at')
                            ->label(__('Dt. vencimento'))
                            ->required()
                            ->minDate(
                                function (Get $get, Forms\Components\DatePicker $component) {
                                    $path = $component->getStatePath();
                                    preg_match('/installments\.(\d+)\.due_at$/', $path, $m);
                                    $index = isset($m[1]) ? (int) $m[1] : 0;

                                    if ($index > 0) {
                                        $prev = $get('../../installments')[$index - 1]['due_at'];
                                        return $prev;
                                    }

                                    return null;
                                }
                            )
                            ->live(),
                        static::getBankAccountFormField(),
                        static::getPaymentMethodFormField(),
                        static::getNameFormField(),
                    ])
                    ->itemLabel(
                        fn(array $state): ?string =>
                        $state['name'] ?? null
                    )
                    // ->addActionLabel(__('Adicionar parcela'))
                    ->addable(false)
                    ->defaultItems(0)
                    ->reorderable(false)
                    // ->reorderableWithButtons()
                    ->collapsible()
                    ->collapseAllAction(
                        fn(Forms\Components\Actions\Action $action) =>
                        $action->label(__('Minimizar todos'))
                    )
                    ->deletable(false)
                    // ->deleteAction(
                    //     fn(Forms\Components\Actions\Action $action) =>
                    //     $action->requiresConfirmation()
                    // )
                    ->rules([
                        function (TransactionService $service, Get $get): Closure {
                            return function (
                                string  $attribute,
                                array   $installments,
                                Closure $fail,
                            ) use ($service, $get): void {
                                $service->validateInstallments(
                                    price: $get('price'),
                                    installments: $installments,
                                    attribute: $attribute,
                                    fail: $fail,
                                );
                            };
                        },
                    ])
                    ->hidden(
                        fn(Get $get): bool =>
                        (int) $get('repeat_payment') !== 2 // 2 - Parcelado
                    )
                    ->grid(2)
                    ->columns(2)
                    ->columnSpanFull(),
            ])
            ->columns(2)
            ->collapsible();
    }

    protected static function getEditPaymentMethodFormSection(): array
    {
        return [
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
                ->required()
                ->maxValue(42949672.95)
                ->live(onBlur: true)
                ->afterStateUpdated(
                    static::getFinalPriceCallback()
                ),
            static::getDueAtFormField(),
            Forms\Components\Group::make()
                ->schema([
                    Forms\Components\TextInput::make('interest')
                        ->label(__('Juros'))
                        // ->numeric()
                        ->prefix('R$')
                        ->mask(
                            Support\RawJs::make(<<<'JS'
                                    $money($input, ',')
                                JS)
                        )
                        ->placeholder('0,00')
                        // ->required()
                        ->maxValue(42949672.95)
                        ->live(onBlur: true)
                        ->afterStateUpdated(
                            static::getFinalPriceCallback()
                        ),
                    Forms\Components\TextInput::make('fine')
                        ->label(__('Multa'))
                        // ->numeric()
                        ->prefix('R$')
                        ->mask(
                            Support\RawJs::make(<<<'JS'
                                    $money($input, ',')
                                JS)
                        )
                        ->placeholder('0,00')
                        // ->required()
                        ->maxValue(42949672.95)
                        ->live(onBlur: true)
                        ->afterStateUpdated(
                            static::getFinalPriceCallback()
                        ),
                    Forms\Components\TextInput::make('discount')
                        ->label(__('Desconto'))
                        // ->numeric()
                        ->prefix('R$')
                        ->mask(
                            Support\RawJs::make(<<<'JS'
                                    $money($input, ',')
                                JS)
                        )
                        ->placeholder('0,00')
                        // ->required()
                        ->maxValue(42949672.95)
                        ->live(onBlur: true)
                        ->afterStateUpdated(
                            static::getFinalPriceCallback()
                        ),
                ])
                ->columns(3)
                ->columnSpanFull(),
            Forms\Components\TextInput::make('final_price')
                ->label(__('Total'))
                // ->numeric()
                ->prefix('R$')
                ->mask(
                    Support\RawJs::make(<<<'JS'
                            $money($input, ',')
                        JS)
                )
                ->placeholder('0,00')
                ->required()
                ->maxValue(42949672.95)
                ->disabled()
                ->dehydrated(),
            Forms\Components\DatePicker::make('paid_at')
                ->label(__('Dt. pagamento'))
                ->displayFormat('d/m/Y')
                ->seconds(false)
                ->maxDate(now()),
            static::getBankAccountFormField(),
            static::getPaymentMethodFormField(),
        ];
    }

    protected static function getEditGeneralInfosFormSection(): array
    {
        return [
            static::getContactFormField(),
            static::getNameFormField(),
            static::getEditCategoriesFormField(),
            Forms\Components\Textarea::make('description')
                ->label(__('Descrição/observações da transação'))
                ->rows(4)
                ->minLength(2)
                ->maxLength(65535)
                ->columnSpanFull(),
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
                    fn(TemporaryUploadedFile $file, Get $get): string =>
                    (string) str('-' . md5(uniqid()) . '-' . time() . '.' . $file->guessExtension())
                        ->prepend(Str::slug($get('name'))),
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
                ->visible(
                    fn(Transaction $record): bool =>
                    $record->attachments->count() > 0
                )
                ->columnSpanFull()
                ->columns(3),
        ];
    }

    protected static function getContactFormField(): Forms\Components\Select
    {
        return Forms\Components\Select::make('contact_id')
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
            ->columnSpanFull();
    }

    protected static function getNameFormField(): Forms\Components\TextInput
    {
        return Forms\Components\TextInput::make('name')
            ->label(__('Nome da transação'))
            ->required()
            ->minLength(2)
            ->maxLength(255)
            ->columnSpanFull();
    }

    protected static function getCreateCategoriesFormField(): Forms\Components\Select
    {
        return Forms\Components\Select::make('categories')
            ->label(__('Categoria(s)'))
            ->relationship(
                name: 'categories',
                titleAttribute: 'name',
                modifyQueryUsing: fn(CategoryService $service, Builder $query): Builder =>
                $service->getQueryByUpToLevelTwoCategories(query: $query)
            )
            ->multiple()
            // ->selectablePlaceholder(false)
            ->native(false)
            ->searchable()
            ->preload()
            // ->required()
            ->when(
                auth()->user()->can('Cadastrar [Financeiro] Categorias'),
                fn(Forms\Components\Select $component): Forms\Components\Select =>
                $component->suffixAction(
                    fn(CategoryService $service): Forms\Components\Actions\Action =>
                    $service->quickCreateActionByCategories(field: 'categories', multiple: true),
                ),
            )
            ->columnSpanFull();
    }

    protected static function getEditCategoriesFormField(): Forms\Components\Select
    {
        return Forms\Components\Select::make('categories')
            ->label(__('Categoria(s)'))
            ->options(
                fn(CategoryService $service): array =>
                $service->getOptionsByUpToLevelTwoCategories(),
            )
            ->multiple()
            // ->selectablePlaceholder(false)
            ->native(false)
            ->searchable()
            ->preload()
            // ->required()
            ->when(
                auth()->user()->can('Cadastrar [Financeiro] Categorias'),
                fn(Forms\Components\Select $component): Forms\Components\Select =>
                $component->suffixAction(
                    fn(CategoryService $service): Forms\Components\Actions\Action =>
                    $service->quickCreateActionByCategories(field: 'categories', multiple: true),
                ),
            )
            ->columnSpanFull();
    }

    protected static function getDueAtFormField(): Forms\Components\DatePicker
    {
        return Forms\Components\DatePicker::make('due_at')
            ->label(__('Dt. vencimento'))
            ->displayFormat('d/m/Y')
            ->seconds(false)
            ->default(now())
            // ->maxDate(now())
            ->required();
    }

    protected static function getBankAccountFormField(): Forms\Components\Select
    {
        return Forms\Components\Select::make('bank_account_id')
            ->label(__('Conta bancária'))
            ->relationship(
                name: 'bankAccount',
                titleAttribute: 'name',
                modifyQueryUsing: fn(BankAccountService $service, Builder $query): Builder =>
                $service->getQueryByBankAccounts(query: $query)
            )
            ->default(
                fn(BankAccountService $service): ?int =>
                $service->getTransactionDefaultBankAccount()
            )
            ->selectablePlaceholder(false)
            ->native(false)
            ->required();
    }

    protected static function getPaymentMethodFormField(): Forms\Components\Select
    {
        // 1 - Dinheiro, 2 - Pix, 3 - Cheque, 4 - Transferência bancária,
        // 5 - Cartão de débito, 6 - Cartão de crédito, 7 - Outros...
        return Forms\Components\Select::make('payment_method')
            ->label(__('Método de pagamento'))
            ->options(TransactionPaymentMethodEnum::class)
            // ->default(1)
            ->selectablePlaceholder(false)
            ->native(false)
            ->searchable()
            ->preload()
            ->required();
    }

    public static function table(Table $table): Table
    {
        return $table
            ->striped()
            ->columns(static::getTableColumns())
            ->defaultSort(column: 'due_at', direction: 'desc')
            ->filters(static::getTableFilters(), layout: Tables\Enums\FiltersLayout::AboveContentCollapsible)
            ->filtersFormColumns(2)
            ->actions(static::getTableActions())
            ->bulkActions(static::getTableBulkActions())
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
                ->toggleable(isToggledHiddenByDefault: true),
            Tables\Columns\TextColumn::make('due_at')
                ->label(__('Vencimento'))
                ->date('d/m/Y')
                ->searchable()
                ->sortable(),
            Tables\Columns\TextColumn::make('name')
                ->label(__('Transação'))
                ->description(
                    fn(Transaction $record): ?string =>
                    $record->mainTransaction()->exists()
                        ? "{$record->repeat_index}/{$record->repeat_occurrence}"
                        : null
                )
                ->searchable()
                ->sortable(),
            Tables\Columns\TextColumn::make('contact.name')
                ->label(__('Contato'))
                ->description(
                    fn(Transaction $record): ?string =>
                    $record->contact->contactable->cpf ?? $record->contact->contactable->cnpj,
                )
                ->searchable()
                ->sortable()
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('display_final_price')
                ->label(__('Valor (R$)'))
                // ->searchable()
                ->sortable()
                ->toggleable(isToggledHiddenByDefault: false),
            Tables\Columns\TextColumn::make('bankAccount.name')
                ->label(__('Conta'))
                ->badge()
                ->searchable()
                ->sortable()
                ->toggleable(isToggledHiddenByDefault: true),
            Tables\Columns\TextColumn::make('bankAccount.agency.name')
                ->label(__('Agência'))
                ->badge()
                ->searchable()
                ->sortable()
                ->toggleable(isToggledHiddenByDefault: true),
            Tables\Columns\TextColumn::make('categories.name')
                ->label(__('Categoria(s)'))
                ->badge()
                ->searchable()
                // ->sortable()
                ->toggleable(isToggledHiddenByDefault: false),

            Tables\Columns\TextColumn::make('display_status')
                ->label(__('Status'))
                ->description(
                    fn(Transaction $record, mixed $state): ?string =>
                    $state === 'Pago' ? ConvertEnToPtBrDate(date: $record->paid_at) : null
                )
                ->badge()
                ->color(
                    fn(mixed $state): string =>
                    match ($state) {
                        'Em aberto' => 'warning',
                        'Pago'      => 'success',
                        'Em atraso' => 'danger',
                    }
                )
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
            Tables\Filters\Filter::make('by_default_date')
                ->label(__('Intervalo'))
                ->form([
                    Forms\Components\Grid::make(['default' => 2])
                        ->schema([
                            Forms\Components\Hidden::make('year')
                                ->default(
                                    fn(Pages\ListTransactions $livewire): string =>
                                    $livewire->activeYear,
                                ),
                            Forms\Components\Select::make('interval')
                                ->label(__('Selecione o mês ou customize'))
                                ->options([
                                    1        => __('Janeiro'),
                                    2        => __('Fevereiro'),
                                    3        => __('Março'),
                                    4        => __('Abril'),
                                    5        => __('Maio'),
                                    6        => __('Junho'),
                                    7        => __('Julho'),
                                    8        => __('Agosto'),
                                    9        => __('Setembro'),
                                    10       => __('Outubro'),
                                    11       => __('Novembro'),
                                    12       => __('Dezembro'),
                                    'custom' => __('Customizar'),
                                ])
                                ->default(now()->month)
                                // ->multiple()
                                // ->selectablePlaceholder(false)
                                ->native(false)
                                ->searchable()
                                ->preload(),
                            Forms\Components\Select::make('custom_interval')
                                ->label(__('Selecione o intervalo'))
                                ->options([
                                    'today'          => __('Hoje'),
                                    'this_week'      => __('Esta semana'),
                                    'this_month'     => __('Este mês'),
                                    'this_year'      => __('Este ano'),
                                    'last_30_days'   => __('Últimos 30 dias'),
                                    'last_12_months' => __('Últimos 12 meses'),
                                ])
                                // ->multiple()
                                // ->selectablePlaceholder(false)
                                ->native(false)
                                ->searchable()
                                ->preload()
                                ->hidden(
                                    fn(Get $get) =>
                                    $get('interval') !== 'custom'
                                ),
                        ]),
                ])
                ->query(
                    fn(TransactionService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByDefaultDate(query: $query, data: $data),
                )
                ->indicateUsing(
                    fn(TransactionService $service, array $state): ?string =>
                    $service->tableFilterIndicateUsingByDefaultDate(data: $state),
                )
                ->columnSpanFull(),
            Tables\Filters\SelectFilter::make('contacts')
                ->label(__('Contato(s)'))
                ->relationship(
                    name: 'contact',
                    titleAttribute: 'name',
                    modifyQueryUsing: fn(Builder $query): Builder =>
                    $query->whereHas('financialTransactions'),
                )
                ->multiple()
                ->preload(),
            Tables\Filters\Filter::make('final_price')
                ->label(__('Valor (R$)'))
                ->form([
                    Forms\Components\Grid::make(['default' => 2])
                        ->schema([
                            Forms\Components\TextInput::make('min_final_price')
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
                                    function (Set $set, Get $get, mixed $state): void {
                                        if (!empty($get('max_final_price')) && $state > $get('max_final_price')) {
                                            $set('max_final_price', $state);
                                        }
                                    }
                                ),
                            Forms\Components\TextInput::make('max_final_price')
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
                                    function (Set $set, Get $get, mixed $state): void {
                                        if (!empty($get('min_final_price')) && $state < $get('min_final_price')) {
                                            $set('min_final_price', $state);
                                        }
                                    }
                                ),
                        ]),
                ])
                ->query(
                    fn(TransactionService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByFinalPrice(query: $query, data: $data),
                )
                ->indicateUsing(
                    fn(TransactionService $service, array $state): ?string =>
                    $service->tableFilterIndicateUsingByFinalPrice(data: $state),
                ),
            Tables\Filters\SelectFilter::make('categories')
                ->label(__('Categoria(s)'))
                ->relationship(
                    name: 'categories',
                    titleAttribute: 'name',
                    modifyQueryUsing: fn(Builder $query): Builder =>
                    $query->whereHas('financialTransactions'),
                )
                ->multiple()
                ->preload(),
            Tables\Filters\SelectFilter::make('bank_accounts')
                ->label(__('Conta(s) bancária(s)'))
                ->relationship(
                    name: 'bankAccount',
                    titleAttribute: 'name',
                    // modifyQueryUsing: fn(Builder $query): Builder =>
                    // $query->whereHas('financialTransactions'),
                )
                ->multiple()
                ->preload(),
            Tables\Filters\SelectFilter::make('agencies')
                ->label(__('Agências'))
                ->options(
                    fn(TransactionService $service): array =>
                    $service->getOptionsByAgenciesWhereHasTransaction(),
                )
                ->multiple()
                ->query(
                    fn(TransactionService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByAgencies(query: $query, data: $data),
                ),
            Tables\Filters\SelectFilter::make('statuses')
                ->label(__('Status'))
                ->options([
                    0 => 'Em aberto',
                    1 => 'Pago',
                    2 => 'Em atraso',
                ])
                ->multiple()
                ->query(
                    fn(TransactionService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByStatuses(query: $query, data: $data),
                ),
            Tables\Filters\Filter::make('due_at')
                ->label(__('Vencimento'))
                ->form([
                    Forms\Components\Grid::make([
                        'default' => 1,
                        'md'      => 2,
                    ])
                        ->schema([
                            Forms\Components\DatePicker::make('due_from')
                                ->label(__('Vencimento de'))
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (mixed $state, Set $set, Get $get): void {
                                        if (!empty($get('due_until')) && $state > $get('due_until')) {
                                            $set('due_until', $state);
                                        }
                                    }
                                ),
                            Forms\Components\DatePicker::make('due_until')
                                ->label(__('Vencimento até'))
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (mixed $state, Set $set, Get $get): void {
                                        if (!empty($get('due_from')) && $state < $get('due_from')) {
                                            $set('due_from', $state);
                                        }
                                    }
                                ),
                        ]),
                ])
                ->query(
                    fn(TransactionService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByDueAt(query: $query, data: $data)
                )
                ->indicateUsing(
                    fn(TransactionService $service, array $state): ?string =>
                    $service->indicateUsingByDates(from: $state['due_from'], until: $state['due_until'], display: 'Vencimento'),
                ),
            Tables\Filters\Filter::make('paid_at')
                ->label(__('Pago'))
                ->form([
                    Forms\Components\Grid::make([
                        'default' => 1,
                        'md'      => 2,
                    ])
                        ->schema([
                            Forms\Components\DatePicker::make('paid_from')
                                ->label(__('Pago de'))
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (mixed $state, Set $set, Get $get): void {
                                        if (!empty($get('paid_until')) && $state > $get('paid_until')) {
                                            $set('paid_until', $state);
                                        }
                                    }
                                ),
                            Forms\Components\DatePicker::make('paid_until')
                                ->label(__('Pago até'))
                                ->live(debounce: 500)
                                ->afterStateUpdated(
                                    function (mixed $state, Set $set, Get $get): void {
                                        if (!empty($get('paid_from')) && $state < $get('paid_from')) {
                                            $set('paid_from', $state);
                                        }
                                    }
                                ),
                        ]),
                ])
                ->query(
                    fn(TransactionService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByPaidAt(query: $query, data: $data)
                )
                ->indicateUsing(
                    fn(TransactionService $service, array $state): ?string =>
                    $service->indicateUsingByDates(from: $state['paid_from'], until: $state['paid_until'], display: 'Pago'),
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
                    fn(TransactionService $service, Builder $query, array $data): Builder =>
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
                    fn(TransactionService $service, Builder $query, array $data): Builder =>
                    $service->tableFilterByUpdatedAt(query: $query, data: $data)
                ),
        ];
    }

    protected static function getTableActions(): array
    {
        return [
            Tables\Actions\ActionGroup::make([
                Tables\Actions\ActionGroup::make([
                    Tables\Actions\ViewAction::make(),
                    Tables\Actions\EditAction::make()
                        ->mutateRecordDataUsing(
                            fn(TransactionService $service, Transaction $record, array $data): array =>
                            $service->mutateRecordDataToEdit(transaction: $record, data: $data)
                        )
                        ->mutateFormDataUsing(
                            fn(TransactionService $service, Transaction $record, array $data): array =>
                            $service->mutateFormDataToEdit(transaction: $record, data: $data)
                        )
                        ->after(
                            fn(TransactionService $service, Transaction $record, array $data) =>
                            $service->afterEditAction(transaction: $record, data: $data),
                        ),
                ])
                    ->dropdown(false),
                // Tables\Actions\DeleteAction::make()
                //     ->before(
                //         fn(TransactionService $service, Tables\Actions\DeleteAction $action, Transaction $record) =>
                //         $service->preventDeleteIf(action: $action, transaction: $record)
                //     ),
                Tables\Actions\DeleteAction::make('custom-delete')
                    ->label(__('Excluir'))
                    ->icon('heroicon-s-trash')
                    ->color('danger')
                    ->form([
                        Forms\Components\Select::make('change_scope')
                            ->label(__('As alterações nesta transação devem ser refletidas:'))
                            ->options([
                                1 => 'Somente a transação atual',
                                2 => 'A transação atual e anteriores que não possuem baixas',
                                3 => 'A transação atual e posteriores que não possuem baixas',
                                4 => 'A transação atual e todas outras que não possuem baixas',
                                5 => 'Todas as transações',
                            ])
                            ->default(1)
                            ->selectablePlaceholder(false)
                            ->native(false)
                            ->required()
                            ->visible(
                                fn(Transaction $record): bool =>
                                $record->mainTransaction()->exists(),
                            )
                            ->columnSpanFull(),
                    ])
                    ->before(
                        fn(TransactionService $service, Tables\Actions\Action $action, Transaction $record) =>
                        $service->preventDeleteIf(action: $action, transaction: $record)
                    )
                    ->after(
                        fn(TransactionService $service, Transaction $record, array $data) =>
                        $service->afterDeleteAction(transaction: $record, data: $data),
                    ),
            ])
                ->label(__('Ações'))
                ->icon('heroicon-m-chevron-down')
                ->size(Support\Enums\ActionSize::ExtraSmall)
                ->color('gray')
                ->button(),
        ];
    }

    protected static function getTableBulkActions(): array
    {
        return [
            Tables\Actions\BulkActionGroup::make([
                Tables\Actions\DeleteBulkAction::make()
                    ->action(
                        fn(TransactionService $service, Collection $records) =>
                        $service->deleteBulkAction(records: $records)
                    )
                    ->hidden(
                        fn(): bool =>
                        !auth()->user()->can('Deletar [Financeiro] Transações Financeiras'),
                    ),
            ]),
        ];
    }

    public static function infolist(Infolist $infolist): Infolist
    {
        return $infolist
            ->schema(static::getInfolistSchema())
            ->columns(3);
    }

    protected static function getInfolistSchema(): array
    {
        return [
            Infolists\Components\Tabs::make('Label')
                ->tabs([
                    Infolists\Components\Tabs\Tab::make(__('Infos. Gerais'))
                        ->schema([
                            Infolists\Components\TextEntry::make('id')
                                ->label(__('#ID')),
                            Infolists\Components\TextEntry::make('name')
                                ->label(__('Transação'))
                                ->helperText(
                                    fn(Transaction $record): ?string =>
                                    $record->mainTransaction()->exists()
                                        ? "{$record->repeat_index}/{$record->repeat_occurrence}"
                                        : null
                                ),
                            Infolists\Components\TextEntry::make('due_at')
                                ->label(__('Vencimento'))
                                ->date('d/m/Y'),
                            Infolists\Components\TextEntry::make('display_price')
                                ->label(__('Valor (R$)'))
                                ->visible(
                                    fn(Transaction $record, mixed $state): bool =>
                                    $record->price !== $record->final_price && !empty($state),
                                ),
                            Infolists\Components\TextEntry::make('display_interest')
                                ->label(__('Juros (R$)'))
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                ),
                            Infolists\Components\TextEntry::make('display_discount')
                                ->label(__('Desconto (R$)'))
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                ),
                            Infolists\Components\TextEntry::make('display_final_price')
                                ->label(__('Valor total (R$)'))
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                ),
                            Infolists\Components\TextEntry::make('bankAccount.name')
                                ->label(__('Conta bancária'))
                                ->badge()
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                ),
                            Infolists\Components\TextEntry::make('bankAccount.agency.name')
                                ->label(__('Agência'))
                                ->badge()
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                ),
                            Infolists\Components\TextEntry::make('categories.name')
                                ->label(__('Categoria(s)'))
                                ->badge()
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                ),
                            Infolists\Components\TextEntry::make('owner.name')
                                ->label(__('Responsável')),
                            Infolists\Components\TextEntry::make('description')
                                ->label(__('Descrição'))
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                )
                                ->columnSpanFull(),
                            Infolists\Components\Grid::make(['default' => 3])
                                ->schema([
                                    Infolists\Components\TextEntry::make('display_status')
                                        ->label(__('Status'))
                                        ->helperText(
                                            fn(Transaction $record, mixed $state): ?string =>
                                            $state === 'Pago' ? ConvertEnToPtBrDate(date: $record->paid_at) : null
                                        )
                                        ->badge()
                                        ->color(
                                            fn(mixed $state): string =>
                                            match ($state) {
                                                'Em aberto' => 'warning',
                                                'Pago'      => 'success',
                                                'Em atraso' => 'danger',
                                            }
                                        ),
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
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                ),
                            Infolists\Components\TextEntry::make('contact.name')
                                ->label(__('Contato')),
                            Infolists\Components\TextEntry::make('contact.roles.name')
                                ->label(__('Tipo(s)'))
                                ->badge()
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                ),
                            Infolists\Components\TextEntry::make('contact.email')
                                ->label(__('Email'))
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                ),
                            Infolists\Components\TextEntry::make('contact.display_additional_emails')
                                ->label(__('Emails adicionais'))
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                ),
                            Infolists\Components\TextEntry::make('contact.display_main_phone_with_name')
                                ->label(__('Telefone'))
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                ),
                            Infolists\Components\TextEntry::make('contact.display_additional_phones')
                                ->label(__('Telefones adicionais'))
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                ),
                            Infolists\Components\TextEntry::make('contact.contactable.cpf')
                                ->label(__('CPF'))
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                ),
                            Infolists\Components\TextEntry::make('contact.contactable.rg')
                                ->label(__('RG'))
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                ),
                            Infolists\Components\TextEntry::make('contact.contactable.gender')
                                ->label(__('Sexo'))
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                ),
                            Infolists\Components\TextEntry::make('contact.contactable.display_birth_date')
                                ->label(__('Dt. nascimento'))
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                ),
                            Infolists\Components\TextEntry::make('contact.contactable.occupation')
                                ->label(__('Cargo'))
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                ),
                            Infolists\Components\TextEntry::make('contact.contactable.cnpj')
                                ->label(__('CNPJ'))
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                ),
                            Infolists\Components\TextEntry::make('contact.contactable.municipal_registration')
                                ->label(__('Inscrição municipal'))
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                ),
                            Infolists\Components\TextEntry::make('contact.contactable.state_registration')
                                ->label(__('Inscrição estadual'))
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                ),
                            Infolists\Components\TextEntry::make('contact.contactable.url')
                                ->label(__('URL do site'))
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                ),
                            Infolists\Components\TextEntry::make('contact.contactable.sector')
                                ->label(__('Setor'))
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                ),
                            Infolists\Components\TextEntry::make('contact.contactable.monthly_income')
                                ->label(__('Faturamento mensal'))
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                ),
                            Infolists\Components\TextEntry::make('contact.source.name')
                                ->label(__('Origem'))
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                ),
                            Infolists\Components\TextEntry::make('contact.owner.name')
                                ->label(__('Captador'))
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                ),
                            Infolists\Components\TextEntry::make('contact.complement')
                                ->label(__('Sobre'))
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                )
                                ->columnSpanFull(),
                            Infolists\Components\TextEntry::make('contact.contactable.main_address.display_full_address')
                                ->label(__('Endereço'))
                                ->visible(
                                    fn(mixed $state): bool =>
                                    !empty($state),
                                )
                                ->columnSpanFull(),
                        ]),
                    Infolists\Components\Tabs\Tab::make(__('Histórico de Interações'))
                        ->schema([
                            Infolists\Components\RepeatableEntry::make('systemInteractions')
                                ->label('Interação(ões)')
                                ->hiddenLabel()
                                ->schema([
                                    Infolists\Components\TextEntry::make('description')
                                        ->hiddenLabel()
                                        ->columnSpan(3),
                                    Infolists\Components\TextEntry::make('owner.name')
                                        ->label(__('Por:')),
                                    Infolists\Components\TextEntry::make('created_at')
                                        ->label(__('Cadastro'))
                                        ->dateTime('d/m/Y H:i'),
                                ])
                                ->columns(5)
                                ->columnSpanFull(),
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
                            fn(Transaction $record): bool =>
                            $record->attachments?->count() > 0
                        ),
                ])
                ->columns(3)
                ->columnSpanFull(),
        ];
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    protected static function getFinalPriceCallback(): Closure
    {
        return function (
            TransactionService $service,
            Set $set,
            Get $get
        ): void {
            $result = $service->getFinalPrice(
                price: $get('price'),
                interest: $get('interest'),
                fine: $get('fine'),
                discount: $get('discount'),
            );

            $set('final_price', $result);
        };
    }

    protected static function getInstallmentsDataCallback(): Closure
    {
        return function (TransactionService $service, Set $set, Get $get): void {
            $installments = $service->getInstallmentsData(
                numInstallments: $get('repeat_occurrence') ?? 1,
                price: $get('price'),
                dueDate: $get('due_at'),
                bankAccount: $get('bank_account_id'),
                paymentMethod: $get('payment_method'),
                name: $get('name'),
            );

            $set('installments', $installments);
        };
    }

    protected static function updateInstallmentsDataBySpecificFieldCallback(string $field): Closure
    {
        return function (TransactionService $service, mixed $state, Set $set, Get $get) use ($field) {
            // 2 - Parcelado
            if ((int) $get('repeat_payment') === 2) {
                $installments = $service->updateInstallmentsDataBySpecificField(
                    field: $field,
                    state: $state,
                    installments: $get('installments')
                );

                $set('installments', $installments);
            }
        };
    }
}
