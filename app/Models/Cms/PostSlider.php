<?php

namespace App\Models\Cms;

use App\Casts\DateTimeCast;
use App\Enums\Cms\PostSliderRoleEnum;
use App\Enums\Cms\PostStatusEnum;
use App\Observers\Cms\PostSliderObserver;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\MorphTo;
use Illuminate\Database\Eloquent\SoftDeletes;
use Spatie\Image\Enums\Fit;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;
use Spatie\MediaLibrary\MediaCollections\Models\Media;

class PostSlider extends Model implements HasMedia
{
    use HasFactory, InteractsWithMedia, SoftDeletes;

    protected $table = 'cms_post_sliders';

    protected $fillable = [
        'slideable_type',
        'slideable_id',
        'role',
        'title',
        'subtitle',
        'body',
        'cta',
        'embed_video',
        'order',
        'status',
        'settings',
        'publish_at',
        'expiration_at'
    ];

    protected $casts = [
        'role'          => PostSliderRoleEnum::class,
        'cta'           => 'array',
        'status'        => PostStatusEnum::class,
        'settings'      => 'array',
        'publish_at'    => DateTimeCast::class,
        'expiration_at' => DateTimeCast::class,
    ];

    protected static function booted(): void
    {
        static::observe(PostSliderObserver::class);
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

    public function slideable(): MorphTo
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
            $this->getFirstMedia('image'),
        );
    }

    protected function featuredVideo(): Attribute
    {
        return Attribute::make(
            get: fn(): ?Media =>
            $this->getFirstMedia('video'),
        );
    }

    protected function featuredWebmVideo(): Attribute
    {
        return Attribute::make(
            get: fn(): ?Media =>
            $this->getFirstMedia('webm_video'),
        );
    }
}
