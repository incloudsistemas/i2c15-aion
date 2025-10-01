<?php

namespace App\Filament\Resources\Cms\RelationManagers;

use App\Filament\Resources\Cms\MainPostSliderResource;
use App\Models\Cms\Page;
use App\Models\Cms\PostSlider;
use App\Services\Cms\PostSliderService;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Infolists;
use Filament\Infolists\Infolist;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class PostSlidersRelationManager extends RelationManager
{
    protected static bool $shouldSkipAuthorization = true;

    protected static string $relationship = 'sliders';

    protected static ?string $modelLabel = 'Sliders';

    public function form(Form $form): Form
    {
        return $form
            ->schema(MainPostSliderResource::getFormFields());
    }

    public function table(Table $table): Table
    {
        $idxPg = false;
        if (
            MorphMapByClass(model: $this->ownerRecord::class) === MorphMapByClass(model: Page::class)
            && $this->ownerRecord->cmsPost->slug === 'index'
        ) {
            $idxPg = true;
        }

        return $table
            ->striped()
            ->recordTitleAttribute('title')
            ->columns(MainPostSliderResource::getTableColumns())
            ->defaultSort(column: 'order', direction: 'asc')
            ->reorderable(column: 'order')
            ->filters(MainPostSliderResource::getTableFilters(), layout: Tables\Enums\FiltersLayout::AboveContentCollapsible)
            ->filtersFormColumns(2)
            ->headerActions([
                Tables\Actions\CreateAction::make()
                    ->hidden(
                        fn(): bool =>
                        $idxPg && !auth()->user()->can('Cadastrar [CMS] Sliders')
                    ),
            ])
            ->actions([
                Tables\Actions\ActionGroup::make([
                    Tables\Actions\ActionGroup::make([
                        Tables\Actions\ViewAction::make(),
                        Tables\Actions\EditAction::make()
                            ->hidden(
                                fn(): bool =>
                                $idxPg && !auth()->user()->can('Editar [CMS] Sliders')
                            ),
                    ])
                        ->dropdown(false),
                    Tables\Actions\DeleteAction::make()
                        ->before(
                            fn(PostSliderService $service, Tables\Actions\DeleteAction $action, PostSlider $record) =>
                            $service->preventDeleteIf(action: $action, postSlider: $record)
                        )
                        ->hidden(
                            fn(): bool =>
                            $idxPg && !auth()->user()->can('Editar [CMS] Sliders')
                        ),
                ])
                    ->label(__('Ações')),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DeleteBulkAction::make(),
                ]),
            ])
            ->emptyStateActions([
                Tables\Actions\CreateAction::make()
                    ->hidden(
                        fn(): bool =>
                        $idxPg && !auth()->user()->can('Cadastrar [CMS] Sliders')
                    ),
            ]);
    }

    public function infolist(Infolist $infolist): Infolist
    {
        return $infolist
            ->schema(MainPostSliderResource::getInfolist())
            ->columns(3);
    }

    public static function canViewForRecord(Model $ownerRecord, string $pageClass): bool
    {
        if (MorphMapByClass(model: $ownerRecord::class) === MorphMapByClass(model: Page::class)) {
            // Index page
            if ($ownerRecord->cmsPost->slug === 'index' && !auth()->user()->can('Visualizar [CMS] Sliders')) {
                return false;
            }

            return !in_array('sliders', $ownerRecord->settings) ? false : true;
        }

        return true;
    }
}
