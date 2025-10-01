<?php

namespace App\Filament\Resources\Cms\PageResource\RelationManagers;

use App\Filament\Resources\Cms\PageResource;
use App\Models\Cms\Page;
use App\Services\Cms\PostService;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Infolists;
use Filament\Infolists\Infolist;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Support;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class SubpagesRelationManager extends RelationManager
{
    protected static string $relationship = 'subpages';

    protected static ?string $title = 'Sub-páginas';

    protected static ?string $modelLabel = 'Sub-página';

    public function table(Table $table): Table
    {
        return $table
            ->striped()
            ->recordTitleAttribute('cmsPost.title')
            ->columns(PageResource::getTableColumns())
            ->defaultSort(
                fn(PostService $service, Builder $query): Builder =>
                $service->tableDefaultSort(query: $query, publishAtDirection: 'asc')
            )
            ->filters(PageResource::getTableFilters(), layout: Tables\Enums\FiltersLayout::AboveContentCollapsible)
            ->filtersFormColumns(2)
            ->headerActions([
                Tables\Actions\Action::make('create')
                    ->label(__('Novo Sub-página'))
                    ->url(
                        fn(): string =>
                        PageResource::getUrl('create', ['main-page' => $this->ownerRecord->id]),
                    )
                    ->hidden(
                        fn(): bool =>
                        !auth()->user()->can('Cadastrar [CMS] Páginas')
                    ),
            ])
            ->actions([
                Tables\Actions\ActionGroup::make([
                    Tables\Actions\ActionGroup::make([
                        Tables\Actions\ViewAction::make()
                            ->extraModalFooterActions([
                                Tables\Actions\Action::make('edit')
                                    ->label(__('Editar'))
                                    ->button()
                                    ->url(
                                        fn(Page $record): string =>
                                        self::getUrl('edit', ['record' => $record]),
                                    )
                                    ->hidden(
                                        fn(): bool =>
                                        !auth()->user()->can('Editar [CMS] Páginas'),
                                    ),
                            ]),
                        Tables\Actions\EditAction::make(),
                    ])
                        ->dropdown(false),
                    Tables\Actions\DeleteAction::make()
                        ->label(__('Excluir')),
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
                            !auth()->user()->can('Deletar [CMS] Páginas'),
                        ),
                ]),
            ])
            ->emptyStateActions([
                Tables\Actions\Action::make('create')
                    ->label(__('Novo Sub-página'))
                    ->url(
                        fn(): string =>
                        PageResource::getUrl('create', ['main-page' => $this->ownerRecord->id]),
                    ),
            ])
            ->recordAction(Tables\Actions\ViewAction::class)
            ->recordUrl(null);
    }

    public function infolist(Infolist $infolist): Infolist
    {
        return PageResource::infolist(infolist: $infolist);
    }

    public static function canViewForRecord(Model $ownerRecord, string $pageClass): bool
    {
        return (!$ownerRecord->subpages->count() > 0 && !auth()->user()->can('Cadastrar [CMS] Páginas'))
            || $ownerRecord->mainPage
            ? false
            : true;
    }
}
