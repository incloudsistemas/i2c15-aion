<?php

namespace App\Models\Crm\Business;

use App\Observers\Crm\Business\ActivityObserver;
use App\Traits\Activities\Activityable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Activity extends Model
{
    use HasFactory, Activityable;

    protected $table = 'crm_business_activities';

    public $timestamps = false;

    protected $fillable = [
        'business_id',
        'interaction_id'
    ];

    protected static function booted(): void
    {
        static::observe(ActivityObserver::class);
    }

    /**
     * RELATIONSHIPS.
     *
     */

    public function interaction(): BelongsTo
    {
        return $this->belongsTo(related: Interaction::class, foreignKey: 'interaction_id');
    }

    public function business(): BelongsTo
    {
        return $this->belongsTo(related: Business::class, foreignKey: 'business_id');
    }
}
