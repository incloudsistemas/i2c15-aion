<?php

namespace App\Models\System;

use App\Enums\DefaultStatusEnum;
use App\Observers\System\AgencyObserver;
use Cviebrock\EloquentSluggable\Sluggable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Spatie\Image\Enums\Fit;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;
use Spatie\MediaLibrary\MediaCollections\Models\Media;

class Agency extends Model implements HasMedia
{
    use HasFactory, InteractsWithMedia, Sluggable, SoftDeletes;

    protected $fillable = [
        'name',
        'slug',
        'complement',
        'status',
        'custom',
    ];

    protected $casts = [
        'status' => DefaultStatusEnum::class,
        'custom' => 'array',
    ];

    protected static function booted(): void
    {
        static::observe(AgencyObserver::class);
    }

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
                'source'   => 'name',
                'onUpdate' => true,
            ],
        ];
    }

    /**
     * RELATIONSHIPS.
     *
     */

    public function users(): BelongsToMany
    {
        return $this->belongsToMany(related: User::class);
    }

    public function teams(): HasMany
    {
        return $this->hasMany(related: Team::class);
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
        return Attribute::get(
            fn(): ?Media =>
            $this->getFirstMedia('avatar') ?: $this->getFirstMedia('images')
        );
    }

    protected function attachments(): Attribute
    {
        return Attribute::get(
            fn(): ?Collection =>
            $this->getMedia('attachments')
                ->sortBy('order_column')
                ->whenEmpty(fn() => null)
        );
    }
}
