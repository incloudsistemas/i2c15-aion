<?php

namespace App\Models\Polymorphics\Activities;

use App\Casts\DateTimeCast;
use App\Enums\Activities\EmailStatusEnum;
use App\Observers\Polymorphics\Activities\EmailObserver;
use App\Traits\Polymorphics\Activityable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Email extends Model
{
    use HasFactory, Activityable, SoftDeletes;

    protected $table = 'activity_emails';

    public $timestamps = false;

    protected $fillable = [
        'sender_mail',
        'recipient_mails',
        'status',
        'send_at'
    ];

    protected $casts = [
        'recipient_mails' => 'array',
        'status'          => EmailStatusEnum::class,
        'send_at'         => DateTimeCast::class,
    ];

    protected static function booted(): void
    {
        static::observe(EmailObserver::class);
    }

    /**
     * SCOPES.
     *
     */

    public function scopeByStatuses(Builder $query, array $statuses = [1]): Builder
    {
        return $query->whereIn('status', $statuses);
    }
}
