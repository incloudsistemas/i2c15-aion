<?php

namespace App\Traits\Cms;

use App\Models\Cms\Post;
use App\Models\Cms\PostSlider;
use App\Models\Cms\PostSubcontent;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\MorphMany;
use Illuminate\Database\Eloquent\Relations\MorphOne;
use Illuminate\Database\Eloquent\SoftDeletes;
use Spatie\Activitylog\LogOptions;
use Spatie\Activitylog\Traits\LogsActivity;
use Spatie\MediaLibrary\InteractsWithMedia;
use Spatie\Image\Enums\Fit;
use Spatie\MediaLibrary\MediaCollections\Models\Media;

trait Postable
{
    use HasFactory, InteractsWithMedia, SoftDeletes;

    use LogsActivity {
        activities as logActivities;
    }

    public function getActivitylogOptions(): LogOptions
    {
        $logName = MorphMapByClass(model: self::class);

        return LogOptions::defaults()
            ->logOnly([])
            ->dontSubmitEmptyLogs()
            ->useLogName($logName);
    }

    public function registerMediaConversions(?Media $media = null): void
    {
        $this->addMediaConversion('thumb')
            ->fit(Fit::Crop, 150, 150)
            ->nonQueued();
    }

    /**
     * RELATIONSHIPS.
     *
     */

    public function subcontents(): MorphMany
    {
        return $this->morphMany(PostSubcontent::class, 'contentable');
    }

    public function sliders(): MorphMany
    {
        return $this->morphMany(PostSlider::class, 'slideable');
    }

    public function cmsPost(): MorphOne
    {
        return $this->morphOne(related: Post::class, name: 'postable');
    }

    /**
     * CUSTOMS.
     *
     */

    protected function featuredImage(): Attribute
    {
        return Attribute::make(
            get: fn(): ?Media =>
            $this->getFirstMedia('image') ?: $this->getFirstMedia('images'),
        );
    }

    protected function galleryImages(): Attribute
    {
        return Attribute::make(
            get: function (): ?Collection {
                $items = $this->getMedia('images')
                    ->sortBy('order_column');

                return $items->isEmpty() ? null : $items->values();
            },
        );
    }

    protected function featuredVideo(): Attribute
    {
        return Attribute::make(
            get: fn(): ?Media =>
            $this->getFirstMedia('video') ?: $this->getFirstMedia('videos'),
        );
    }

    protected function galleryVideos(): Attribute
    {
        return Attribute::make(
            get: function (): ?Collection {
                $items = $this->getMedia('videos')
                    ->sortBy('order_column');

                return $items->isEmpty() ? null : $items->values();
            },
        );
    }

    protected function attachments(): Attribute
    {
        return Attribute::make(
            get: function (): ?Collection {
                $media = $this->getMedia('attachments')
                    ->sortBy('order_column');

                return $media->isEmpty() ? null : $media;
            },
        );
    }

    /**
     * WEBSITE EXCLUSIVE.
     *
     */

    protected function baseWebQuery(
        array $statuses = [1],
        bool $featured = false,
        string $orderBy = 'cms_posts.order',
        string $direction = 'desc',
        string $publishAtDirection = 'desc'
    ): Builder {
        $postableTable = $this->getTable();
        $morphClass = MorphMapByClass(model: get_class($this));

        $query = $this->newQuery()
            ->with([
                'cmsPost',
                'cmsPost.owner:id,name,email',
                'media'
            ])
            ->join('cms_posts', function ($join) use ($postableTable, $morphClass) {
                return $join->on("{$postableTable}.id", '=', 'cms_posts.postable_id')
                    ->where('cms_posts.postable_type', '=', $morphClass);
            })
            ->select("{$postableTable}.*")
            ->whereIn('cms_posts.status', $statuses)
            ->where('cms_posts.publish_at', '<=', now())
            ->where(function ($query): Builder {
                return $query->where('cms_posts.expiration_at', '>', now())
                    ->orWhereNull('cms_posts.expiration_at');
            });

        if ($featured) {
            $query->where('cms_posts.featured', true);
        }

        return $query
            ->orderBy($orderBy, $direction)
            ->orderBy('cms_posts.publish_at', $publishAtDirection);
    }

    public function getWeb(
        array $statuses = [1],
        string $orderBy = 'cms_posts.order',
        string $direction = 'desc',
        string $publishAtDirection = 'desc'
    ): Builder {
        return $this->baseWebQuery(
            statuses: $statuses,
            featured: false,
            orderBy: $orderBy,
            direction: $direction,
            publishAtDirection: $publishAtDirection
        );
    }

    public function getWebFeatured(
        array $statuses = [1],
        string $orderBy = 'cms_posts.order',
        string $direction = 'desc',
        string $publishAtDirection = 'desc'
    ): Builder {
        return $this->baseWebQuery(
            statuses: $statuses,
            featured: true,
            orderBy: $orderBy,
            direction: $direction,
            publishAtDirection: $publishAtDirection
        );
    }

    public function getWebByRoles(
        array $roles,
        array $statuses = [1],
        string $orderBy = 'cms_posts.order',
        string $direction = 'desc',
        string $publishAtDirection = 'desc'
    ): Builder {
        return $this->getWeb(
            statuses: $statuses,
            orderBy: $orderBy,
            direction: $direction,
            publishAtDirection: $publishAtDirection
        )
            ->whereIn('role', $roles);
    }

    public function getWebFeaturedByRoles(
        array $roles,
        array $statuses = [1],
        string $orderBy = 'cms_posts.order',
        string $direction = 'desc',
        string $publishAtDirection = 'desc'
    ): Builder {
        return $this->getWebFeatured(
            statuses: $statuses,
            orderBy: $orderBy,
            direction: $direction,
            publishAtDirection: $publishAtDirection
        )
            ->whereIn('role', $roles);
    }

    public function findWebBySlug(
        string $slug,
        array $statuses = [1],
        string $orderBy = 'cms_posts.order',
        string $direction = 'desc',
        string $publishAtDirection = 'desc'
    ): Builder {
        return $this->getWeb(
            statuses: $statuses,
            orderBy: $orderBy,
            direction: $direction,
            publishAtDirection: $publishAtDirection
        )
            ->where('slug', $slug);
    }

    public function searchWeb(
        string $keyword,
        array $statuses = [1],
        string $orderBy = 'cms_posts.order',
        string $direction = 'desc',
        string $publishAtDirection = 'desc'
    ): Builder {
        return $this->getWeb(
            statuses: $statuses,
            orderBy: $orderBy,
            direction: $direction,
            publishAtDirection: $publishAtDirection
        )
            ->where('title', 'like', '%' . $keyword . '%');
    }

    public function searchWebByRoles(
        string $keyword,
        array $roles,
        array $statuses = [1],
        string $orderBy = 'cms_posts.order',
        string $direction = 'desc',
        string $publishAtDirection = 'desc'
    ): Builder {
        return $this->searchWeb(
            keyword: $keyword,
            statuses: $statuses,
            orderBy: $orderBy,
            direction: $direction,
            publishAtDirection: $publishAtDirection
        )
            ->whereIn('role', $roles);
    }

    public function getWebByCategory(
        string $categorySlug,
        array $statuses = [1,],
        string $orderBy = 'cms_posts.order',
        string $direction = 'desc',
        string $publishAtDirection = 'desc'
    ): Builder {
        return $this->getWeb(
            statuses: $statuses,
            orderBy: $orderBy,
            direction: $direction,
            publishAtDirection: $publishAtDirection
        )
            ->whereHas('cmsPost.postCategories', function (Builder $query) use ($categorySlug): Builder {
                return $query->where('slug', $categorySlug);
            });
    }

    public function getWebByCategoryAndRoles(
        string $categorySlug,
        array $roles,
        array $statuses = [1],
        string $orderBy = 'cms_posts.order',
        string $direction = 'desc',
        string $publishAtDirection = 'desc'
    ): Builder {
        return $this->getWebByCategory(
            categorySlug: $categorySlug,
            statuses: $statuses,
            orderBy: $orderBy,
            direction: $direction,
            publishAtDirection: $publishAtDirection
        )
            ->whereIn('role', $roles);
    }

    public function getWebByRelatedCategories(
        array $categoryIds,
        array $statuses = [1],
        ?int $idToAvoid = null,
        string $orderBy = 'cms_posts.order',
        string $direction = 'desc',
        string $publishAtDirection = 'desc'
    ): Builder {
        $postableTable = $this->getTable();

        $query = $this->getWeb(
            statuses: $statuses,
            orderBy: $orderBy,
            direction: $direction,
            publishAtDirection: $publishAtDirection
        )
            ->whereHas('cmsPost.postCategories', function (Builder $query) use ($categoryIds): Builder {
                return $query->whereIn('id', $categoryIds);
            });

        if ($idToAvoid) {
            $query->where("{$postableTable}.id", '<>', $idToAvoid);
        }

        return $query;
    }

    public function getWebByRelatedCategoriesAndRoles(
        array $categoryIds,
        array $roles,
        array $statuses = [1],
        string $orderBy = 'cms_posts.order',
        string $direction = 'desc',
        string $publishAtDirection = 'desc'
    ): Builder {
        return $this->getWebByRelatedCategories(
            categoryIds: $categoryIds,
            statuses: $statuses,
            orderBy: $orderBy,
            direction: $direction,
            publishAtDirection: $publishAtDirection
        )
            ->whereIn('role', $roles);
    }

    public function getWebSliders(
        array $statuses = [1],
        string $orderBy = 'order',
        string $direction = 'asc'
    ): MorphMany {
        return $this->sliders()
            ->whereIn('status', $statuses)
            ->where('publish_at', '<=', now())
            ->where(function (Builder $query): Builder {
                return $query->where('expiration_at', '>', now())
                    ->orWhereNull('expiration_at');
            })
            ->orderBy($orderBy, $direction)
            ->orderBy('publish_at', 'desc');
    }

    public function getWebSubcontentsByRoles(
        array $roles,
        array $statuses = [1],
        string $orderBy = 'order',
        string $direction = 'asc'
    ): MorphMany {
        return $this->subcontents()
            ->whereIn('roles', $roles)
            ->whereIn('status', $statuses)
            ->where('publish_at', '<=', now())
            ->where(function (Builder $query): Builder {
                return $query->where('expiration_at', '>', now())
                    ->orWhereNull('expiration_at');
            })
            ->orderBy($orderBy, $direction)
            ->orderBy('publish_at', 'desc');
    }
}
