<?php

namespace App\Models\Crm\Contacts;

use App\Enums\DefaultStatusEnum;
use App\Models\Crm\Source;
use App\Models\System\User;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\MorphTo;
use Illuminate\Database\Eloquent\SoftDeletes;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;
use Spatie\Image\Enums\Fit;
use Spatie\MediaLibrary\MediaCollections\Models\Media;

class Contact extends Model implements HasMedia
{
    use HasFactory, InteractsWithMedia, SoftDeletes;

    protected $table = 'crm_contacts';

    protected $fillable = [
        'contactable_type',
        'contactable_id',
        'user_id',
        'source_id',
        'name',
        'email',
        'additional_emails',
        'phones',
        'complement',
        'status',
        'custom',
    ];

    protected function casts(): array
    {
        return [
            'additional_emails' => 'array',
            'phones'            => 'array',
            'status'            => DefaultStatusEnum::class,
            'custom'            => 'array',
        ];
    }

    // public function financialTransactions(): HasMany
    // {
    //     return $this->hasMany(related: Transaction::class, foreignKey: 'contact_id');
    // }

    // public function activities(): BelongsToMany
    // {
    //     return $this->belongsToMany(
    //         related: Activity::class,
    //         table: 'activity_crm_contact',
    //         foreignPivotKey: 'contact_id',
    //         relatedPivotKey: 'activity_id'
    //     );
    // }

    // public function business(): HasMany
    // {
    //     return $this->hasMany(related: Business::class, foreignKey: 'contact_id');
    // }

    public function source(): BelongsTo
    {
        return $this->belongsTo(related: Source::class, foreignKey: 'source_id');
    }

    public function roles()
    {
        return $this->belongsToMany(
            related: Role::class,
            table: 'crm_contact_crm_contact_role',
            foreignPivotKey: 'contact_id',
            relatedPivotKey: 'role_id'
        );
    }

    public function owner(): BelongsTo
    {
        return $this->belongsTo(related: User::class, foreignKey: 'user_id');
    }

    public function contactable(): MorphTo
    {
        return $this->morphTo();
    }

    public function registerMediaConversions(?Media $media = null): void
    {
        $this->addMediaConversion('thumb')
            ->fit(Fit::Crop, 150, 150)
            ->nonQueued();
    }

    /**
     * EVENT LISTENERS.
     *
     */

    /**
     * SCOPES.
     *
     */

    public function scopeByStatuses(Builder $query, array $statuses = [1]): Builder
    {
        return $query->whereIn('status', $statuses);
    }

    /**
     * MUTATORS.
     *
     */

    /**
     * CUSTOMS.
     *
     */

    public function getDisplayContactableTypeAttribute(): string
    {
        if ($this->contactable_type === MorphMapByClass(model: LegalEntity::class)) {
            return 'P. Jurídica';
        }

        return 'P. Física';
    }

    public function getDisplayAdditionalEmailsAttribute(): ?array
    {
        $additionalEmails = [];

        if (isset($this->additional_emails[0])) {
            foreach ($this->additional_emails as $email) {
                $additionalEmail = $email['email'];

                if (!empty($email['name'])) {
                    $additionalEmail .= " ({$email['name']})";
                }

                $additionalEmails[] = $additionalEmail;
            }
        }

        return !empty($additionalEmails) ? $additionalEmails : null;
    }

    public function getDisplayMainPhoneAttribute(): ?string
    {
        return $this->phones[0]['number'] ?? null;
    }

    public function getDisplayMainPhoneWithNameAttribute(): ?string
    {
        if (isset($this->phones[0]['number'])) {
            $mainPhone = $this->phones[0]['number'];
            $phoneName = $this->phones[0]['name'] ?? null;

            if (!empty($phoneName)) {
                $mainPhone .= " ({$phoneName})";
            }

            return $mainPhone;
        }

        return null;
    }

    public function getDisplayAdditionalPhonesAttribute(): ?array
    {
        $additionalPhones = [];

        if (isset($this->phones[1]['number'])) {
            foreach (array_slice($this->phones, 1) as $phone) {
                $additionalPhone = $phone['number'];

                if (!empty($phone['name'])) {
                    $additionalPhone .= " ({$phone['name']})";
                }

                $additionalPhones[] = $additionalPhone;
            }
        }

        return !empty($additionalPhones) ? $additionalPhones : null;
    }

    public function getFeaturedImageAttribute(): ?Media
    {
        $featuredImage = $this->getFirstMedia('avatar');

        if (!$featuredImage) {
            $featuredImage = $this->getFirstMedia('images');
        }

        return $featuredImage ?? null;
    }

    public function getAttachmentsAttribute()
    {
        $attachments = $this->getMedia('attachments')
            ->sortBy('order_column');

        return $attachments->isEmpty() ? null : $attachments;
    }
}
