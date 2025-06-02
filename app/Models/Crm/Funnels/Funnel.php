<?php

namespace App\Models\Crm\Funnels;

use App\Enums\DefaultStatusEnum;
use App\Models\Crm\Business\Business;
use App\Models\Crm\Business\FunnelStage as BusinessFunnelStage;
use App\Observers\Crm\Funnels\FunnelObserver;
use Cviebrock\EloquentSluggable\Sluggable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class Funnel extends Model
{
    use HasFactory, Sluggable, SoftDeletes;

    protected $table = 'crm_funnels';

    protected $fillable = [
        'name',
        'slug',
        'description',
        'order',
        'status',
    ];

    protected $casts = [
        'status' => DefaultStatusEnum::class,
    ];

    public function business(): HasMany
    {
        return $this->hasMany(related: Business::class, foreignKey: 'funnel_id');
    }

    public function businessFunnelStages(): HasMany
    {
        return $this->hasMany(related: BusinessFunnelStage::class, foreignKey: 'funnel_id');
    }

    public function stages(): HasMany
    {
        return $this->hasMany(related: FunnelStage::class, foreignKey: 'funnel_id');
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
     * EVENT LISTENERS.
     *
     */

    protected static function boot()
    {
        parent::boot();
        self::observe(FunnelObserver::class);
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
     * MUTATORS.
     *
     */

    /**
     * CUSTOMS.
     *
     */
}
