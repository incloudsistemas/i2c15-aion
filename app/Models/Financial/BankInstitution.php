<?php

namespace App\Models\Financial;

use App\Enums\DefaultStatusEnum;
use App\Observers\Financial\BankInstitutionObserver;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class BankInstitution extends Model
{
    use HasFactory, SoftDeletes;

    protected $table = 'financial_bank_institutions';

    protected $fillable = [
        'code',
        'ispb',
        'name',
        'short_name',
        'status'
    ];

    protected $casts = [
        'status' => DefaultStatusEnum::class,
    ];

    protected static function booted(): void
    {
        static::observe(BankInstitutionObserver::class);
    }

    /**
     * RELATIONSHIPS.
     *
     */

    public function bankAccounts(): HasMany
    {
        return $this->hasMany(related: BankAccount::class, foreignKey: 'bank_institution_id');
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
