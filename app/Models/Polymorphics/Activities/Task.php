<?php

namespace App\Models\Polymorphics\Activities;

use App\Casts\DateCast;
use App\Enums\Activities\TaskPriorityEnum;
use App\Enums\Activities\TaskRoleEnum;
use App\Observers\Polymorphics\Activities\TaskObserver;
use App\Traits\Polymorphics\Activityable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class Task extends Model
{
    use HasFactory, Activityable, SoftDeletes;

    protected $table = 'activity_tasks';

    public $timestamps = false;

    protected $fillable = [
        'task_id',
        'role',
        'start_date',
        'start_time',
        'end_date',
        'end_time',
        'repeat_occurrence',
        'repeat_frequency',
        'repeat_index',
        'location',
        'priority',
        'reminders'
    ];

    protected $casts = [
        'role'       => TaskRoleEnum::class,
        'start_date' => DateCast::class,
        'start_time' => 'datetime:H:i:s',
        'end_date'   => DateCast::class,
        'end_time'   => 'datetime:H:i:s',
        'priority'   => TaskPriorityEnum::class,
        'reminders'  => 'array'
    ];

    protected static function booted(): void
    {
        static::observe(TaskObserver::class);
    }

    /**
     * RELATIONSHIPS.
     *
     */

    public function mainTask(): BelongsTo
    {
        return $this->belongsTo(related: Self::class, foreignKey: 'task_id');
    }

    public function subtasks(): HasMany
    {
        return $this->hasMany(related: Self::class, foreignKey: 'task_id');
    }

    /**
     * SCOPES.
     *
     */

    public function scopeByRoles(Builder $query, array $roles): Builder
    {
        return $query->whereIn('role', $roles);
    }

    public function getStartAtAttribute()
    {
        return $this->start_date && $this->start_time
            ? now()->parse($this->start_date->format('Y-m-d'))
                ->setTimeFrom($this->start_time)
            : null;
    }

    public function getEndAtAttribute()
    {
        return $this->end_date && $this->end_time
            ? now()->parse($this->end_date->format('Y-m-d'))
                ->setTimeFrom($this->end_time)
            : null;
    }
}
