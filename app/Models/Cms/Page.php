<?php

namespace App\Models\Cms;

use App\Observers\Cms\PageObserver;
use App\Traits\Cms\Postable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Spatie\MediaLibrary\HasMedia;

class Page extends Model implements HasMedia
{
    use Postable;

    protected $table = 'cms_pages';

    public $timestamps = false;

    protected $fillable = [
        'page_id',
        'icon',
        'cta',
        'embed_videos',
        'settings'
    ];

    protected $casts = [
        'cta'          => 'array',
        'embed_videos' => 'array',
        'settings'     => 'array',
    ];

    protected static function booted(): void
    {
        static::observe(PageObserver::class);
    }

    /**
     * RELATIONSHIPS.
     *
     */

    public function mainPage(): BelongsTo
    {
        return $this->belongsTo(related: self::class, foreignKey: 'page_id');
    }

    public function subpages(): HasMany
    {
        return $this->hasMany(related: self::class, foreignKey: 'page_id');
    }
}
