<?php

namespace App\Models\Cms;

use App\Casts\DateTimeCast;
use App\Enums\Cms\PostStatusEnum;
use App\Models\System\User;
use Cviebrock\EloquentSluggable\Sluggable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\MorphTo;
use Illuminate\Database\Eloquent\SoftDeletes;
use Spatie\Image\Enums\Fit;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;
use Spatie\MediaLibrary\MediaCollections\Models\Media;

class Post extends Model implements HasMedia
{
    use HasFactory, InteractsWithMedia, Sluggable, SoftDeletes;

    protected $table = 'cms_posts';

    protected $fillable = [
        'postable_type',
        'postable_id',
        'user_id',
        'title',
        'slug',
        'subtitle',
        'excerpt',
        'body',
        'url',
        'embed_video',
        'tags',
        'order',
        'featured',
        'comment',
        'meta_title',
        'meta_description',
        'meta_keywords',
        'publish_at',
        'expiration_at',
        'status',
        'custom',
    ];

    protected $casts = [
        'tags'          => 'array',
        'featured'      => 'boolean',
        'comment'       => 'boolean',
        'meta_keywords' => 'array',
        'publish_at'    => DateTimeCast::class,
        'expiration_at' => DateTimeCast::class,
        'status'        => PostStatusEnum::class,
        'custom'        => 'array',
    ];

    public function registerMediaConversions(?Media $media = null): void
    {
        $this->addMediaConversion('thumb')
            ->fit(Fit::Crop, 150, 150)
            ->nonQueued();
    }

    public function sluggable(): array
    {
        if (!empty($this->slug)) {
            return [];
        }

        return [
            'slug' => [
                'source'         => 'title',
                'unique'         => function ($slug, $separator) {
                    return ! static::query()
                        ->where('slug', $slug)
                        ->where('postable_type', $this->postable_type)
                        ->exists();
                },
                'onUpdate'       => true,
                'includeTrashed' => true,
            ],
        ];
    }

    /**
     * RELATIONSHIPS.
     *
     */

    public function postCategories(): BelongsToMany
    {
        return $this->belongsToMany(
            related: PostCategory::class,
            table: 'cms_post_cms_post_category',
            foreignPivotKey: 'post_id',
            relatedPivotKey: 'category_id'
        );
    }

    public function owner(): BelongsTo
    {
        return $this->belongsTo(related: User::class, foreignKey: 'user_id');
    }

    public function postable(): MorphTo
    {
        return $this->morphTo();
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
}
