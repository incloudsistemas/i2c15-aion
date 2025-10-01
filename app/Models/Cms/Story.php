<?php

namespace App\Models\Cms;

use App\Enums\Cms\StoryRoleEnum;
use App\Observers\Cms\StoryObserver;
use App\Traits\Cms\Postable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\HasMedia;

class Story extends Model implements HasMedia
{
    use Postable;

    protected $table = 'cms_stories';

    public $timestamps = false;

    protected $fillable = [
        'role',
        'cta',
    ];

    protected $casts = [
        'role' => StoryRoleEnum::class,
        'cta'  => 'array'
    ];

    protected static function booted(): void
    {
        static::observe(StoryObserver::class);
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
