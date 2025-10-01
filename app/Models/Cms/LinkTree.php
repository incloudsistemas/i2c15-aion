<?php

namespace App\Models\Cms;

use App\Enums\Cms\LinkTreeRoleEnum;
use App\Observers\Cms\LinkTreeObserver;
use App\Traits\Cms\Postable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\HasMedia;

class LinkTree extends Model implements HasMedia
{
    use Postable;

    protected $table = 'cms_link_trees';

    public $timestamps = false;

    protected $fillable = [
        'role',
        'target',
        'icon',
        'button_settings',
    ];

    protected $casts = [
        'role'            => LinkTreeRoleEnum::class,
        'button_settings' => 'array',
    ];

    protected static function booted(): void
    {
        static::observe(LinkTreeObserver::class);
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
