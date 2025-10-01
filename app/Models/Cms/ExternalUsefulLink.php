<?php

namespace App\Models\Cms;

use App\Enums\Cms\ExternalUsefulLinkRoleEnum;
use App\Observers\Cms\ExternalUsefulLinkObserver;
use App\Traits\Cms\Postable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\HasMedia;

class ExternalUsefulLink extends Model implements HasMedia
{
    use Postable;

    protected $table = 'cms_external_useful_links';

    public $timestamps = false;

    protected $fillable = [
        'role',
        'target',
        'icon'
    ];

    protected $casts = [
        'role' => ExternalUsefulLinkRoleEnum::class,
    ];

    protected static function booted(): void
    {
        static::observe(ExternalUsefulLinkObserver::class);
    }

    /**
     * SCOPES.
     *
     */

    public function scopeByRoles(Builder $query, array $roles): Builder
    {
        return $query->whereIn('role', $roles);
    }
}
