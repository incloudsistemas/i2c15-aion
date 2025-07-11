<?php

namespace App\Models\System;

// use Illuminate\Contracts\Auth\MustVerifyEmail;

use App\Casts\DateCast;
use App\Enums\ProfileInfos\EducationalLevelEnum;
use App\Enums\ProfileInfos\GenderEnum;
use App\Enums\ProfileInfos\MaritalStatusEnum;
use App\Enums\ProfileInfos\UserStatusEnum;
use App\Models\Crm\Business\Business;
use App\Models\Crm\Contacts\Contact;
use App\Models\Polymorphics\Activities\Activity;
use App\Models\Polymorphics\Address;
use App\Models\Polymorphics\SystemInteraction;
use App\Observers\System\UserObserver;
use App\Services\System\RoleService;
use Filament\Models\Contracts\FilamentUser;
use Filament\Panel;
use Illuminate\Contracts\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\MorphOne;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Spatie\Image\Enums\Fit;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;
use Spatie\MediaLibrary\MediaCollections\Models\Media;
use Spatie\Permission\Traits\HasRoles;

class User extends Authenticatable implements FilamentUser, HasMedia
{
    use HasFactory, Notifiable, HasRoles, InteractsWithMedia, SoftDeletes;

    protected $fillable = [
        'name',
        'email',
        'password',
        'additional_emails',
        'phones',
        'cpf',
        'rg',
        'gender',
        'birth_date',
        'marital_status',
        'educational_level',
        'nationality',
        'citizenship',
        'complement',
        'status',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
        'password'          => 'hashed',
        'additional_emails' => 'array',
        'phones'            => 'array',
        'gender'            => GenderEnum::class,
        'birth_date'        => DateCast::class,
        'marital_status'    => MaritalStatusEnum::class,
        'educational_level' => EducationalLevelEnum::class,
        'status'            => UserStatusEnum::class,
    ];

    protected static function booted(): void
    {
        static::observe(UserObserver::class);
    }

    public function registerMediaConversions(?Media $media = null): void
    {
        $this->addMediaConversion('thumb')
            ->fit(Fit::Crop, 150, 150)
            ->nonQueued();
    }

    public function canAccessPanel(Panel $panel): bool
    {
        if ((int) $this->status->value !== 1) {
            // auth()->logout();
            return false;
        }

        return true;
    }

    /**
     * RELATIONSHIPS.
     *
     */

    public function ownSystemInteractions(): HasMany
    {
        return $this->hasMany(related: SystemInteraction::class, foreignKey: 'user_id');
    }

    public function activities(): BelongsToMany
    {
        return $this->belongsToMany(
            related: Activity::class,
            table: 'activity_user',
            foreignPivotKey: 'user_id',
            relatedPivotKey: 'activity_id'
        );
    }

    public function ownActivities(): HasMany
    {
        return $this->hasMany(related: Activity::class, foreignKey: 'user_id');
    }

    public function business(): BelongsToMany
    {
        return $this->belongsToMany(
            related: Business::class,
            table: 'crm_business_user',
            foreignPivotKey: 'user_id',
            relatedPivotKey: 'business_id'
        )
            ->withPivot(columns: 'business_at');
    }

    public function ownBusiness(): HasMany
    {
        return $this->hasMany(related: Business::class, foreignKey: 'user_id');
    }

    public function contacts(): HasMany
    {
        return $this->hasMany(related: Contact::class);
    }

    public function collaboratorTeams(): BelongsToMany
    {
        return $this->belongsToMany(related: Team::class)
            ->withPivot(columns: 'role')
            ->wherePivot(column: 'role', operator: 2); // 2 - 'Colaborador/Collaborator'
    }

    public function coordinatorTeams(): BelongsToMany
    {
        return $this->belongsToMany(related: Team::class)
            ->withPivot(columns: 'role')
            ->wherePivot(column: 'role', operator: 1); // 1 - 'Líder/Leader ou Coordenador/Coordinator'
    }

    public function teams(): BelongsToMany
    {
        return $this->belongsToMany(related: Team::class)
            ->withPivot(columns: 'role');
    }

    public function agencies(): BelongsToMany
    {
        return $this->belongsToMany(related: Agency::class);
    }

    public function address(): MorphOne
    {
        return $this->morphOne(related: Address::class, name: 'addressable');
    }

    /**
     * SCOPES.
     *
     */

    public function scopeByAuthUserRoles(Builder $query, User $user): Builder
    {
        $rolesToAvoid = RoleService::getArrayOfRolesToAvoidByAuthUserRoles(user: $user);

        return $query->whereHas(
            'roles',
            fn(Builder $query): Builder =>
            $query->whereNotIn('id', $rolesToAvoid)
        );
    }

    public function scopeWhereHasRolesAvoidingClients(Builder $query): Builder
    {
        $rolesToAvoid = [2]; // 2 - Cliente

        return $query->whereHas(
            'roles',
            fn(Builder $query): Builder =>
            $query->whereNotIn('id', $rolesToAvoid)
        );
    }

    public function scopeByStatuses(Builder $query, array $statuses = [1]): Builder
    {
        return $query->whereHasRolesAvoidingClients()
            ->whereIn('status', $statuses);
    }

    /**
     * CUSTOMS.
     *
     */

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

    protected function displayBirthDate(): Attribute
    {
        return Attribute::get(
            fn(): ?string =>
            $this->birth_date ? ConvertEnToPtBrDate(date: $this->birth_date) : null
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
