<?php

namespace App\Models\Crm\Contacts;

use App\Enums\DefaultStatusEnum;
use App\Models\Crm\Business\Business;
use App\Models\Crm\Business\Interaction;
use App\Models\Crm\Source;
use App\Models\System\User;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
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

    protected $casts = [
        'additional_emails' => 'array',
        'phones'            => 'array',
        'status'            => DefaultStatusEnum::class,
        'custom'            => 'array',
    ];

    public function registerMediaConversions(?Media $media = null): void
    {
        $this->addMediaConversion('thumb')
            ->fit(Fit::Crop, 150, 150)
            ->nonQueued();
    }

    /**
     * RELATIONSHIPS.
     *
     */

    public function businessInteractions(): HasMany
    {
        return $this->hasMany(related: Interaction::class, foreignKey: 'contact_id');
    }

    public function business(): HasMany
    {
        return $this->hasMany(related: Business::class, foreignKey: 'contact_id');
    }

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

    /**
     * SCOPES.
     *
     */

    public function scopeByStatuses(Builder $query, array $statuses = [1]): Builder
    {
        return $query->whereIn('status', $statuses);
    }

    /**
     * CUSTOMS.
     *
     */

    protected function displayContactableType(): Attribute
    {
        return Attribute::get(
            fn(): string =>
            $this->contactable_type === MorphMapByClass(model: LegalEntity::class)
                ? 'P. Jurídica'
                : 'P. Física'
        );
    }

    protected function displayAdditionalEmails(): Attribute
    {
        return Attribute::get(
            fn(): ?array =>
            collect($this->additional_emails ?? [])
                ->filter(
                    fn(array $email): bool =>
                    !empty($email['email'])
                )
                ->map(
                    fn(array $email): string =>
                    $email['email'] . (!empty($email['name']) ? " ({$email['name']})" : '')
                )
                ->values()
                ->all() ?: null
        );
    }

    protected function displayMainPhone(): Attribute
    {
        return Attribute::get(
            fn(): ?string =>
            $this->phones[0]['number'] ?? null
        );
    }

    protected function displayMainPhoneWithName(): Attribute
    {
        return Attribute::get(
            fn(): ?string =>
            isset($this->phones[0]['number'])
                ? $this->phones[0]['number'] . (!empty($this->phones[0]['name']) ? " ({$this->phones[0]['name']})" : '')
                : null
        );
    }

    protected function displayAdditionalPhones(): Attribute
    {
        return Attribute::get(
            fn(): ?array =>
            collect($this->phones ?? [])
                ->slice(1)
                ->map(
                    fn(array $phone): string =>
                    $phone['number'] . (!empty($phone['name']) ? " ({$phone['name']})" : '')
                )
                ->values()
                ->all() ?: null
        );
    }

    protected function featuredImage(): Attribute
    {
        return Attribute::get(
            fn(): ?Media =>
            $this->getFirstMedia('avatar') ?: $this->getFirstMedia('images')
        );
    }

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
