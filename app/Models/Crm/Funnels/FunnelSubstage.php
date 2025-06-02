<?php

namespace App\Models\Crm\Funnels;

use App\Models\Crm\Business\Business;
use App\Models\Crm\Business\FunnelStage as BusinessFunnelStage;
use App\Observers\Crm\Funnels\FunnelSubstageObserver;
use Cviebrock\EloquentSluggable\Sluggable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class FunnelSubstage extends Model
{
    use HasFactory, Sluggable, SoftDeletes;

    protected $table = 'crm_funnel_substages';

    protected $fillable = [
        'funnel_stage_id',
        'name',
        'slug',
        'description',
        'order',
    ];

    public function business(): HasMany
    {
        return $this->hasMany(related: Business::class, foreignKey: 'funnel_substage_id');
    }

    public function businessFunnelStages(): HasMany
    {
        return $this->hasMany(related: BusinessFunnelStage::class, foreignKey: 'funnel_substage_id');
    }

    public function stage(): BelongsTo
    {
        return $this->belongsTo(related: FunnelStage::class, foreignKey: 'funnel_stage_id');
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
        self::observe(FunnelSubstageObserver::class);
    }

    /**
     * SCOPES.
     *
     */

    /**
     * MUTATORS.
     *
     */

    /**
     * CUSTOMS.
     *
     */
}
