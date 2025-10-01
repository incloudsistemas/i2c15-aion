<?php

namespace App\Services\Cms;

use App\Models\Cms\Page;
use App\Models\Cms\Post;
use App\Services\BaseService;
use Filament\Notifications\Notification;
use Illuminate\Contracts\Database\Eloquent\Builder;

class PageService extends BaseService
{
    public function __construct(protected Post $post, protected Page $page)
    {
        parent::__construct();
    }

    public function getOptionsByMainPages(?Page $page): array
    {
        return $this->page->with('cmsPost')
            ->whereHas('cmsPost')
            ->whereNull('page_id')
            ->when($page, function (Builder $query) use ($page): Builder {
                return $query->where('id', '<>', $page->id);
            })
            ->get()
            ->mapWithKeys(function ($item): array {
                return [$item->id => $item->cmsPost->title];
            })
            ->toArray();
    }

    public function getQueryByMainPages(Builder $query, ?Page $page): Builder
    {
        return $query->with('cmsPost')
            ->whereHas('cmsPost')
            ->whereNull('page_id')
            ->when($page, function (Builder $query) use ($page): Builder {
                return $query->where('id', '<>', $page->id);
            });
    }

    /**
     * $action can be:
     * Filament\Tables\Actions\DeleteAction;
     * Filament\Actions\DeleteAction;
     */
    public function preventDeleteIf($action, Page $page): void
    {
        //
    }
}
