<?php

namespace App\Models\Cms;

use App\Enums\Cms\BlogPostRoleEnum;
use App\Observers\Cms\BlogPostObserver;
use App\Traits\Cms\Postable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\HasMedia;

class BlogPost extends Model implements HasMedia
{
    use Postable;

    protected $table = 'cms_blog_posts';

    public $timestamps = false;

    protected $fillable = [
        'role',
        'embed_videos',
    ];

    protected $casts = [
        'role'         => BlogPostRoleEnum::class,
        'embed_videos' => 'array',
    ];

    protected static function booted(): void
    {
        static::observe(BlogPostObserver::class);
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
