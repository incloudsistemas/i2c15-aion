<?php

namespace App\Traits\Crm\Contacts;

use App\Models\Crm\Contacts\Contact;
use App\Models\Polymorphics\Address;
use App\Traits\Polymorphics\Addressable;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\MorphOne;
use Illuminate\Database\Eloquent\SoftDeletes;
use Spatie\MediaLibrary\InteractsWithMedia;
use Spatie\Image\Enums\Fit;
use Spatie\MediaLibrary\MediaCollections\Models\Media;

trait Contactable
{
    use HasFactory, Addressable, InteractsWithMedia, SoftDeletes;

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

    public function contact(): MorphOne
    {
        return $this->morphOne(related: Contact::class, name: 'contactable');
    }

    /**
     * CUSTOMS.
     *
     */

    public function getMainAddressAttribute(): ?Address
    {
        return $this->addresses()
            ->orderByDesc('is_main')
            ->first();
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
