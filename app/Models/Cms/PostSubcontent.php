<?php

namespace App\Models\Cms;

use App\Casts\DateTimeCast;
use App\Enums\Cms\PostStatusEnum;
use App\Enums\Cms\PostSubcontentRoleEnum;
use App\Observers\Cms\PostSubcontentObserver;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\MorphTo;
use Illuminate\Database\Eloquent\SoftDeletes;
use Spatie\Image\Enums\Fit;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;
use Spatie\MediaLibrary\MediaCollections\Models\Media;

class PostSubcontent extends Model implements HasMedia
{
    use HasFactory, InteractsWithMedia, SoftDeletes;

    protected $table = 'cms_post_subcontents';

    protected $fillable = [
        'contentable_type',
        'contentable_id',
        'role',
        'title',
        'subtitle',
        'excerpt',
        'body',
        'url',
        'icon',
        'cta',
        'embed_video',
        'embed_videos',
        'tags',
        'order',
        'status',
        'publish_at',
        'expiration_at'
    ];

    protected $casts = [
        'role'          => PostSubcontentRoleEnum::class,
        'cta'           => 'array',
        'embed_videos'  => 'array',
        'tags'          => 'array',
        'status'        => PostStatusEnum::class,
        'publish_at'    => DateTimeCast::class,
        'expiration_at' => DateTimeCast::class,
    ];

    protected static function booted(): void
    {
        static::observe(PostSubcontentObserver::class);
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

    public function contentable(): MorphTo
    {
        return $this->morphTo();
    }

    /**
     * SCOPES.
     *
     */

    public function scopeByRoles(Builder $query, array $roles): Builder
    {
        return $query->whereIn('role', $roles);
    }

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
