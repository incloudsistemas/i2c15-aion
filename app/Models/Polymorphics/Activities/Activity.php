<?php

namespace App\Models\Polymorphics\Activities;

use App\Models\Crm\Business\Business;
use App\Models\Crm\Contacts\Contact;
use App\Models\System\User;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\MorphTo;
use Illuminate\Database\Eloquent\SoftDeletes;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;

class Activity extends Model implements HasMedia
{
    use HasFactory, InteractsWithMedia, SoftDeletes;

    protected $fillable = [
        'activityable_type',
        'activityable_id',
        'user_id',
        'business_id',
        'subject',
        'body',
        'custom'
    ];

    protected $casts = [
        'custom' => 'array',
    ];

    /**
     * RELATIONSHIPS.
     *
     */

    public function business(): BelongsTo
    {
        return $this->belongsTo(related: Business::class, foreignKey: 'business_id');
    }

    public function contacts(): BelongsToMany
    {
        return $this->belongsToMany(
            related: Contact::class,
            table: 'activity_crm_contact',
            foreignPivotKey: 'activity_id',
            relatedPivotKey: 'contact_id'
        );
    }

    public function users(): BelongsToMany
    {
        return $this->belongsToMany(
            related: User::class,
            table: 'activity_user',
            foreignPivotKey: 'activity_id',
            relatedPivotKey: 'user_id'
        );
    }

    public function owner(): BelongsTo
    {
        return $this->belongsTo(related: User::class, foreignKey: 'user_id');
    }

    public function activityable(): MorphTo
    {
        return $this->morphTo();
    }

    /**
     * CUSTOMS.
     *
     */

    protected function attachments(): Attribute
    {
        return Attribute::get(
            fn(): ?Collection =>
            $this->getMedia('attachments')
                ->sortBy('order_column')
                ->whenEmpty(fn() => null)
        );
    }
}
