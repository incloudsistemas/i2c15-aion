<?php

namespace App\Models\Polymorphics;

use App\Enums\ProfileInfos\UfEnum;
use App\Observers\Polymorphics\AddressObserver;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\MorphTo;
use Cviebrock\EloquentSluggable\Sluggable;
use Illuminate\Database\Eloquent\Casts\Attribute;

class Address extends Model
{
    use HasFactory, Sluggable;

    protected $fillable = [
        'addressable_type',
        'addressable_id',
        'name',
        'slug',
        'is_main',
        'zipcode',
        'state',
        'uf',
        'city',
        'country',
        'district',
        'address_line',
        'number',
        'complement',
        'custom_street',
        'custom_block',
        'custom_lot',
        'reference',
        'gmap_coordinates',
    ];

    protected $casts = [
        'is_main' => 'boolean',
        'uf'      => UfEnum::class
    ];

    protected static function booted(): void
    {
        static::observe(AddressObserver::class);
    }

    public function sluggable(): array
    {
        return [
            'slug' => [
                'source'   => ['city', 'uf.name'],
                'unique'   => false,
                'onUpdate' => true,
            ],
        ];
    }

    /**
     * RELATIONSHIPS.
     *
     */

    public function addressable(): MorphTo
    {
        return $this->morphTo();
    }

    /**
     * CUSTOMS.
     *
     */

    protected function displayFullAddress(): Attribute
    {
        return Attribute::get(
            function (): ?string {
                $components = [];

                if (!empty(trim($this->address_line))) {
                    $components[] = trim($this->address_line);
                }

                if (!empty(trim($this->number))) {
                    $components[] = trim($this->number);
                }

                if (!empty(trim($this->complement))) {
                    $components[] = trim($this->complement);
                }

                if (!empty(trim($this->district))) {
                    $components[] = trim($this->district);
                }

                if (!empty(trim($this->city))) {
                    $components[] = trim($this->city);

                    if (!empty($this->uf)) {
                        $components[] = trim($this->uf->name);
                    }
                }

                if (!empty(trim($this->zipcode))) {
                    $components[] = trim($this->zipcode);
                }

                $address = implode(', ', $components);

                return $address !== '' ? $address : null;
            }
        );
    }

    protected function displayShortAddress(): Attribute
    {
        return Attribute::get(
            function (): ?string {
                $components = [];

                if (!empty(trim($this->address_line))) {
                    $components[] = trim($this->address_line);
                }

                if (!empty(trim($this->number))) {
                    $components[] = trim($this->number);
                }

                if (!empty(trim($this->district))) {
                    $components[] = trim($this->district);
                }

                $short = implode(', ', $components);

                return $short !== '' ? $short : null;
            }
        );
    }
}
