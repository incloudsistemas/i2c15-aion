<?php

namespace App\Models\Crm\Funnels;

use App\Models\Crm\Business\Business;
use App\Models\Crm\Business\FunnelStage as BusinessFunnelStage;
use App\Observers\Crm\Funnels\FunnelStageObserver;
use Cviebrock\EloquentSluggable\Sluggable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class FunnelStage extends Model
{
    use HasFactory, Sluggable, SoftDeletes;

    protected $table = 'crm_funnel_stages';

    protected $fillable = [
        'funnel_id',
        'name',
        'slug',
        'description',
        'business_probability',
        'order',
    ];

    public function business(): HasMany
    {
        return $this->hasMany(related: Business::class, foreignKey: 'funnel_stage_id');
    }

    public function businessFunnelStages(): HasMany
    {
        return $this->hasMany(related: BusinessFunnelStage::class, foreignKey: 'funnel_stage_id');
    }

    public function substages(): HasMany
    {
        return $this->hasMany(related: FunnelSubstage::class);
    }

    public function funnel(): BelongsTo
    {
        return $this->belongsTo(related: Funnel::class, foreignKey: 'funnel_id');
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
        self::observe(FunnelStageObserver::class);
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
