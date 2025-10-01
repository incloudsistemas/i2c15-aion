<?php

namespace App\Models\Cms;

use App\Enums\DefaultStatusEnum;
use App\Observers\Cms\PostCategoryObserver;
use Cviebrock\EloquentSluggable\Sluggable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class PostCategory extends Model
{
    use HasFactory, Sluggable, SoftDeletes;

    protected $table = 'cms_post_categories';

    protected $fillable = [
        'name',
        'slug',
        'order',
        'status'
    ];

    protected $casts = [
        'status' => DefaultStatusEnum::class,
    ];

    protected static function booted(): void
    {
        static::observe(PostCategoryObserver::class);
    }

    public function sluggable(): array
    {
        if (!empty($this->slug)) {
            return [];
        }

        return [
            'slug' => [
                'source'         => 'name',
                'unique'         => true,
                'onUpdate'       => true,
                'includeTrashed' => true,
            ],
        ];
    }

    /**
     * RELATIONSHIPS.
     *
     */

    public function cmsPosts(): BelongsToMany
    {
        return $this->belongsToMany(
            related: Post::class,
            table: 'cms_post_cms_post_category',
            foreignPivotKey: 'category_id',
            relatedPivotKey: 'post_id'
        );
    }

    /**
     * SCOPES.
     *
     */

    public function scopeByStatuses(Builder $query, array $statuses = [1]): Builder
    {
        return $query->whereIn('status', $statuses);
    }

    /**
     * CUSTOMS.
     *
     */

    /**
     * WEBSITE EXCLUSIVE.
     *
     */

    public function getWebPostCategoriesByTypes(
        array $postableTypes,
        array $statuses = [1],
        string $orderBy = 'name',
        string $direction = 'asc'
    ): Builder {
        return $this->newQuery()
            ->whereHas(
                'cmsPosts',
                fn(Builder $query): Builder =>
                $query->whereIn('postable_type', $postableTypes)
                    ->where('status', 1) // 1 - Ativo
            )
            ->whereIn('status', $statuses)
            ->orderBy($orderBy, $direction);
    }
}
