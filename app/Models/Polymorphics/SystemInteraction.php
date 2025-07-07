<?php

namespace App\Models\Polymorphics;

use App\Models\Polymorphics\Activities\Activity;
use App\Models\System\User;
use App\Observers\Polymorphics\SystemInteractionObserver;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;

class SystemInteraction extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'interactable_type',
        'interactable_id',
        'user_id',
        'description',
        'data',
        'custom'
    ];

    protected $casts = [
        'data'   => 'array',
        'custom' => 'array',
    ];

    protected static function booted(): void
    {
        static::observe(SystemInteractionObserver::class);
    }

    /**
     * RELATIONSHIPS.
     *
     */

    public function owner(): BelongsTo
    {
        return $this->belongsTo(related: User::class, foreignKey: 'user_id');
    }
}
