<?php

namespace App\Models\Crm\Business;

use App\Casts\DateTimeCast;
use App\Enums\Crm\Business\LossReasonEnum;
use App\Models\Crm\Funnels\Funnel;
use App\Models\Crm\Funnels\FunnelStage as FunnelsFunnelStage;
use App\Models\Crm\Funnels\FunnelSubstage;
use App\Observers\Crm\Business\FunnelStageObserver;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;

class FunnelStage extends Model
{
    use HasFactory, SoftDeletes;

    protected $table = 'crm_business_funnel_stages';

    protected $fillable = [
        'business_id',
        'funnel_id',
        'funnel_stage_id',
        'funnel_substage_id',
        'business_at',
        'loss_reason',
    ];

    protected $casts = [
        'business_at' => DateTimeCast::class,
        'loss_reason' => LossReasonEnum::class,
    ];

    protected static function booted(): void
    {
        static::observe(FunnelStageObserver::class);
    }

    /**
     * RELATIONSHIPS.
     *
     */

    public function substage(): BelongsTo
    {
        return $this->belongsTo(related: FunnelSubstage::class, foreignKey: 'funnel_substage_id');
    }

    public function stage(): BelongsTo
    {
        return $this->belongsTo(related: FunnelsFunnelStage::class, foreignKey: 'funnel_stage_id');
    }

    public function funnel(): BelongsTo
    {
        return $this->belongsTo(related: Funnel::class, foreignKey: 'funnel_id');
    }

    public function business(): BelongsTo
    {
        return $this->belongsTo(related: Business::class, foreignKey: 'business_id');
    }
}
