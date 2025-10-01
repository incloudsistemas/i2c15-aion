<?php

namespace App\Models\Cms;

use App\Enums\Cms\PortfolioPostRoleEnum;
use App\Observers\Cms\PortfolioPostObserver;
use App\Traits\Cms\Postable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\HasMedia;

class PortfolioPost extends Model implements HasMedia
{
    use Postable;

    protected $table = 'cms_portfolio_posts';

    public $timestamps = false;

    protected $fillable = [
        'role',
        'embed_videos',
    ];

    protected $casts = [
        'role'         => PortfolioPostRoleEnum::class,
        'embed_videos' => 'array',
    ];

    protected static function booted(): void
    {
        static::observe(PortfolioPostObserver::class);
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
