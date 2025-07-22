<?php

namespace App\Models\Financial;

use App\Casts\DateCast;
use App\Casts\FloatCast;
use App\Enums\DefaultStatusEnum;
use App\Enums\Financial\BankAccountRoleEnum;
use App\Enums\Financial\BankAccountTypePersonEnum;
use App\Models\System\Agency;
use App\Observers\Financial\BankAccountObserver;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;

class BankAccount extends Model implements HasMedia
{
    use HasFactory, InteractsWithMedia, SoftDeletes;

    protected $table = 'financial_bank_accounts';

    protected $fillable = [
        'bank_institution_id',
        'agency_id',
        'role',
        'type_person',
        'name',
        'is_main',
        'balance_date',
        'balance',
        'complement',
        'status',
    ];

    protected $casts = [
        'role'         => BankAccountRoleEnum::class,
        'type_person'  => BankAccountTypePersonEnum::class,
        'is_main'      => 'boolean',
        'balance_date' => DateCast::class,
        'balance'      => FloatCast::class,
        'status'       => DefaultStatusEnum::class,
    ];

    protected static function booted(): void
    {
        static::observe(BankAccountObserver::class);
    }

    /**
     * RELATIONSHIPS.
     *
     */

    public function financialTransactions(): HasMany
    {
        return $this->hasMany(related: Transaction::class, foreignKey: 'bank_account_id');
    }

    public function agency(): BelongsTo
    {
        return $this->belongsTo(related: Agency::class, foreignKey: 'agency_id');
    }

    public function bankInstitution(): BelongsTo
    {
        return $this->belongsTo(related: BankInstitution::class, foreignKey: 'bank_institution_id');
    }

    /**
     * SCOPES.
     *
     */

    public function scopeByRoles(Builder $query, array $roles): Builder
    {
        return $query->whereIn('role', $roles);
    }

    public function scopeByStatuses(Builder $query, array $statuses = [1]): Builder
    {
        return $query->whereIn('status', $statuses);
    }

    /**
     * CUSTOMS.
     *
     */

    protected function displayBalance(): Attribute
    {
        return Attribute::get(
            fn(): ?string =>
            $this->balance !== null
                ? number_format($this->balance, 2, ',', '.')
                : '0,00',
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
