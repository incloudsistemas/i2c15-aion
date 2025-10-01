<?php

namespace App\Models\Cms;

use App\Enums\Cms\ServiceRoleEnum;
use App\Observers\Cms\ServiceObserver;
use App\Traits\Cms\Postable;
use Attribute;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\HasMedia;

class Service extends Model implements HasMedia
{
    use Postable;

    protected $table = 'cms_services';

    public $timestamps = false;

    protected $fillable = [
        'role',
        'icon',
        'cta',
        'embed_videos',
    ];

    protected $casts = [
        'role'         => ServiceRoleEnum::class,
        'cta'          => 'array',
        'embed_videos' => 'array',
    ];

    protected static function booted(): void
    {
        static::observe(ServiceObserver::class);
    }

    /**
     * SCOPES.
     *
     */

    public function scopeByRoles(Builder $query, array $roles): Builder
    {
        return $query->whereIn('role', $roles);
    }

    /**
     * CUSTOMS.
     *
     */

    protected function displayRole(): Attribute
    {
        return Attribute::make(
            get: fn(): ?string => $this->role?->getLabel(),
        );
    }

    protected function displayRoleSlug(): Attribute
    {
        return Attribute::make(
            get: fn(): ?string => $this->role?->getSlug(),
        );
    }
}
