<?php

namespace App\Models\Financial;

use App\Casts\DateCast;
use App\Casts\FloatCast;
use App\Enums\Financial\TransactionPaymentMethodEnum;
use App\Enums\Financial\TransactionRepeatFrequencyEnum;
use App\Enums\Financial\TransactionRepeatPaymentEnum;
use App\Models\Crm\Business\Business;
use App\Models\Crm\Contacts\Contact;
use App\Models\System\User;
use App\Observers\Financial\TransactionObserver;
use App\Traits\Polymorphics\SystemInteractable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;

class Transaction extends Model implements HasMedia
{
    use HasFactory, SystemInteractable, InteractsWithMedia, SoftDeletes;

    protected $table = 'financial_transactions';

    protected $fillable = [
        'user_id',
        'bank_account_id',
        'contact_id',
        'business_id',
        'transaction_id',
        'role',
        'name',
        'payment_method',
        'repeat_payment',
        'repeat_frequency',
        'repeat_occurrence',
        'repeat_index',
        'price',
        'interest',
        'fine',
        'discount',
        'taxes',
        'final_price',
        'complement',
        'due_at',
        'paid_at',
    ];

    protected $casts = [
        'payment_method'   => TransactionPaymentMethodEnum::class,
        'repeat_payment'   => TransactionRepeatPaymentEnum::class,
        'repeat_frequency' => TransactionRepeatFrequencyEnum::class,
        'price'            => FloatCast::class,
        'interest'         => FloatCast::class,
        'fine'             => FloatCast::class,
        'discount'         => FloatCast::class,
        'taxes'            => FloatCast::class,
        'final_price'      => FloatCast::class,
        'due_at'           => DateCast::class,
        'paid_at'          => DateCast::class,
    ];

    protected static function booted(): void
    {
        static::observe(TransactionObserver::class);
    }

    /**
     * RELATIONSHIPS.
     *
     */

    public function categories(): BelongsToMany
    {
        return $this->belongsToMany(
            related: Category::class,
            table: 'financial_category_financial_transaction',
            foreignPivotKey: 'transaction_id',
            relatedPivotKey: 'category_id'
        );
    }

    public function mainTransaction(): BelongsTo
    {
        return $this->belongsTo(related: Self::class, foreignKey: 'transaction_id')
            ->withTrashed();
    }

    public function subtransactions(): HasMany
    {
        return $this->hasMany(related: Self::class, foreignKey: 'transaction_id')
            ->withTrashed();
    }

    public function business(): BelongsTo
    {
        return $this->belongsTo(Business::class, 'business_id');
    }

    public function contact(): BelongsTo
    {
        return $this->belongsTo(Contact::class, 'contact_id');
    }

    public function bankAccount(): BelongsTo
    {
        return $this->belongsTo(related: BankAccount::class, foreignKey: 'bank_account_id');
    }

    public function owner(): BelongsTo
    {
        return $this->belongsTo(related: User::class, foreignKey: 'user_id');
    }

    /**
     * SCOPES.
     *
     */

    public function scopeByRoles(Builder $query, array $roles): Builder
    {
        return $query->whereIn('role', $roles);
    }

    /**
     * CUSTOMS.
     *
     */

    protected function displayPrice(): Attribute
    {
        return Attribute::get(
            fn(): ?string =>
            $this->price !== null
                ? number_format($this->price, 2, ',', '.')
                : null,
        );
    }

    protected function displayInterest(): Attribute
    {
        return Attribute::get(
            fn(): ?string =>
            $this->interest !== null
                ? number_format($this->interest, 2, ',', '.')
                : null,
        );
    }

    protected function displayFine(): Attribute
    {
        return Attribute::get(
            fn(): ?string =>
            $this->fine !== null
                ? number_format($this->fine, 2, ',', '.')
                : null,
        );
    }

    protected function displayDiscount(): Attribute
    {
        return Attribute::get(
            fn(): ?string =>
            $this->discount !== null
                ? number_format($this->discount, 2, ',', '.')
                : null,
        );
    }

    protected function displayTaxes(): Attribute
    {
        return Attribute::get(
            fn(): ?string =>
            $this->taxes !== null
                ? number_format($this->taxes, 2, ',', '.')
                : null,
        );
    }

    protected function displayFinalPrice(): Attribute
    {
        return Attribute::get(
            fn(): ?string =>
            $this->final_price !== null
                ? number_format($this->final_price, 2, ',', '.')
                : null,
        );
    }

    protected function displayStatus(): Attribute
    {
        return Attribute::get(
            fn(): ?string =>
            !empty($this->paid_at)
                ? 'Pago'
                : (now()->format('Y-m-d') > $this->due_at
                    ? 'Em atraso'
                    : 'Em aberto')
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
