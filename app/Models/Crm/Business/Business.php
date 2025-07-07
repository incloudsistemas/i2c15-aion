<?php

namespace App\Models\Crm\Business;

use App\Casts\DateTimeCast;
use App\Casts\FloatCast;
use App\Enums\Crm\Business\PriorityEnum;
use App\Models\Crm\Source;
use App\Models\Crm\Business\Activity as BusinessActivity;
use App\Models\Crm\Business\FunnelStage as BusinessFunnelStage;
use App\Models\Crm\Contacts\Contact;
use App\Models\Crm\Funnels\Funnel;
use App\Models\Crm\Funnels\FunnelStage;
use App\Models\Crm\Funnels\FunnelSubstage;
use App\Models\Polymorphics\Activities\Activity;
use App\Models\System\User;
use App\Observers\Crm\Business\BusinessObserver;
use App\Traits\Polymorphics\Activityable;
use App\Traits\Polymorphics\SystemInteractable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\DB;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;

class Business extends Model implements HasMedia
{
    use HasFactory, SystemInteractable, InteractsWithMedia, SoftDeletes;

    protected $table = 'crm_business';

    protected $fillable = [
        'user_id',
        'contact_id',
        'funnel_id',
        'funnel_stage_id',
        'funnel_substage_id',
        'source_id',
        'name',
        'description',
        'price',
        'commission_percentage',
        'commission_price',
        'priority',
        'order',
        'business_at',
    ];

    protected $casts = [
        'price'                 => FloatCast::class,
        'commission_percentage' => FloatCast::class,
        'commission_price'      => FloatCast::class,
        'priority'              => PriorityEnum::class,
        'business_at'           => DateTimeCast::class,
    ];

    protected static function booted(): void
    {
        static::observe(BusinessObserver::class);
    }

    /**
     * RELATIONSHIPS.
     *
     */

    public function activities(): HasMany
    {
        return $this->hasMany(related: Activity::class, foreignKey: 'business_id');
    }

    public function source(): BelongsTo
    {
        return $this->belongsTo(related: Source::class, foreignKey: 'source_id');
    }

    public function currentBusinessFunnelStageRelation(): HasOne
    {
        return $this->hasOne(related: BusinessFunnelStage::class)
            ->latestOfMany(column: 'business_at');
    }

    public function businessFunnelStages(): HasMany
    {
        return $this->hasMany(related: BusinessFunnelStage::class, foreignKey: 'business_id');
    }

    public function substage(): BelongsTo
    {
        return $this->belongsTo(related: FunnelSubstage::class, foreignKey: 'funnel_substage_id');
    }

    public function stage(): BelongsTo
    {
        return $this->belongsTo(related: FunnelStage::class, foreignKey: 'funnel_stage_id');
    }

    public function funnel(): BelongsTo
    {
        return $this->belongsTo(related: Funnel::class, foreignKey: 'funnel_id');
    }

    public function contact(): BelongsTo
    {
        return $this->belongsTo(related: Contact::class, foreignKey: 'contact_id');
    }

    public function currentUserRelation(): BelongsToMany
    {
        return $this->users()
            ->withPivot(columns: 'business_at')
            ->orderByPivot(column: 'business_at', direction: 'desc')
            ->limit(1);
    }

    public function users(): BelongsToMany
    {
        return $this->belongsToMany(
            related: User::class,
            table: 'crm_business_user',
            foreignPivotKey: 'business_id',
            relatedPivotKey: 'user_id'
        )
            ->withPivot(columns: 'business_at');
    }

    public function owner(): BelongsTo
    {
        return $this->belongsTo(related: User::class, foreignKey: 'user_id');
    }

    /**
     * SCOPES.
     *
     */

    public function scopeWhereHasCurrentUser(Builder $query, array|int $userIds): Builder
    {
        $userIds = is_array($userIds) ? $userIds : [$userIds];

        return $query->whereExists(function ($query) use ($userIds) {
            $query->select(DB::raw(1))
                ->from('crm_business_user as bu')
                ->whereColumn('bu.business_id', 'crm_business.id')
                ->whereIn('bu.user_id', $userIds)
                ->whereRaw('bu.business_at = (
                    select max(inner_bu.business_at)
                    from crm_business_user as inner_bu
                    where inner_bu.business_id = bu.business_id
                )');
        });
    }

    /**
     * CUSTOMS.
     *
     */

    public function getCurrentUserAttribute(): User
    {
        return $this->currentUserRelation()
            ->firstOrFail();
    }

    public function getCurrentBusinessFunnelStageAttribute(): BusinessFunnelStage
    {
        return $this->currentBusinessFunnelStageRelation()
            ->firstOrFail();
    }

    public function getCurrentFunnelAttribute(): Funnel
    {
        return $this->currentBusinessFunnelStage->funnel;
    }

    public function getCurrentStageAttribute(): FunnelStage
    {
        return $this->currentBusinessFunnelStage->stage;
    }

    public function getCurrentSubstageAttribute(): ?FunnelSubstage
    {
        return $this->currentBusinessFunnelStage->substage ?? null;
    }

    protected function displayCurrentUser(): Attribute
    {
        return Attribute::get(
            fn(): ?string =>
            $this->currentUser->name,
        );
    }

    protected function displayPrice(): Attribute
    {
        return Attribute::get(
            fn(): ?string =>
            $this->price !== null
                ? number_format($this->price, 2, ',', '.')
                : null,
        );
    }

    protected function displayCommissionPercentage(): Attribute
    {
        return Attribute::get(
            fn(): ?string =>
            $this->commission_percentage !== null
                ? number_format($this->commission_percentage, 2, ',', '.')
                : null,
        );
    }

    protected function displayCommissionPrice(): Attribute
    {
        return Attribute::get(
            fn(): ?string =>
            $this->commission_price !== null
                ? number_format($this->commission_price, 2, ',', '.')
                : null,
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
