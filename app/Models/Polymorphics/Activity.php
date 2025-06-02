<?php

namespace App\Models\Polymorphics;

use App\Models\System\User;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\MorphTo;

class Activity extends Model
{
    use HasFactory;

    protected $fillable = [
        'activityable_type',
        'activityable_id',
        'user_id',
        'description',
        'custom'
    ];

    protected function casts(): array
    {
        return [
            'custom' => 'array',
        ];
    }

    /**
     * RELATIONSHIPS.
     *
     */

    public function owner(): BelongsTo
    {
        return $this->belongsTo(related: User::class, foreignKey: 'user_id');
    }

    public function activityable(): MorphTo
    {
        return $this->morphTo();
    }
}
