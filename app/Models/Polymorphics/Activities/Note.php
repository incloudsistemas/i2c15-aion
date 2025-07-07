<?php

namespace App\Models\Polymorphics\Activities;

use App\Casts\DateTimeCast;
use App\Enums\Activities\NoteRoleEnum;
use App\Observers\Polymorphics\Activities\NoteObserver;
use App\Traits\Polymorphics\Activityable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;

class Note extends Model
{
    use HasFactory, Activityable, SoftDeletes;

    protected $table = 'activity_notes';

    public $timestamps = false;

    protected $fillable = [
        'role',
        'register_at'
    ];

    protected $casts = [
        'role'        => NoteRoleEnum::class,
        'register_at' => DateTimeCast::class,
    ];

    protected static function booted(): void
    {
        static::observe(NoteObserver::class);
    }

    /**
     * SCOPES.
     *
     */

    public function scopeByRoles(Builder $query, array $roles): Builder
    {
        return $query->whereIn('role', $roles);
    }
}
