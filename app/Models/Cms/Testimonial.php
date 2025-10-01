<?php

namespace App\Models\Cms;

use App\Enums\Cms\TestimonialRoleEnum;
use App\Observers\Cms\TestimonialObserver;
use App\Traits\Cms\Postable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\HasMedia;

class Testimonial extends Model implements HasMedia
{
    use Postable;

    protected $table = 'cms_testimonials';

    public $timestamps = false;

    protected $fillable = [
        'role',
        'customer_name',
        'occupation',
        'company'
    ];

    protected $casts = [
        'role' => TestimonialRoleEnum::class,
    ];

    protected static function booted(): void
    {
        static::observe(TestimonialObserver::class);
    }

    /**
     * SCOPES.
     *
     */

    public function scopeByRoles(Builder $query, array $roles): Builder
    {
        return $query->whereIn('role', $roles);
    }
}
