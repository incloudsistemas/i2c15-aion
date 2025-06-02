<?php

namespace App\Models\Crm\Business;

use App\Casts\DateCast;
use App\Enums\Crm\Business\InteractionRoleEnum;
use Illuminate\Database\Eloquent\Model;
use App\Models\Crm\Business\Activity as BusinessActivity;
use App\Models\Crm\Contacts\Contact;
use App\Models\System\User;
use App\Observers\Crm\Business\InteractionObserver;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Spatie\MediaLibrary\InteractsWithMedia;

class Interaction extends Model
{
    use HasFactory, InteractsWithMedia, SoftDeletes;

    protected $table = 'crm_business_interactions';

    protected $fillable = [
        'business_id',
        'user_id',
        'contact_id',
        'role',
        'subject',
        'body',
        'scheduled_at',
        'finished_at',
        'custom',
    ];

    protected $casts = [
        'role'         => InteractionRoleEnum::class,
        'scheduled_at' => DateCast::class,
        'finished_at'  => DateCast::class,
        'custom'       => 'array',
    ];

    protected static function booted(): void
    {
        static::observe(InteractionObserver::class);
    }

    /**
     * RELATIONSHIPS.
     *
     */

    public function businessActivity(): HasMany
    {
        return $this->hasMany(related: BusinessActivity::class, foreignKey: 'interaction_id');
    }

    public function contact(): BelongsTo
    {
        return $this->belongsTo(related: Contact::class, foreignKey: 'contact_id');
    }

    public function owner(): BelongsTo
    {
        return $this->belongsTo(related: User::class, foreignKey: 'user_id');
    }

    public function business(): BelongsTo
    {
        return $this->belongsTo(related: Business::class, foreignKey: 'business_id');
    }
}
