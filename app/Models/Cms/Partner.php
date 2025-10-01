<?php

namespace App\Models\Cms;

use App\Observers\Cms\PartnerObserver;
use App\Traits\Cms\Postable;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\HasMedia;

class Partner extends Model implements HasMedia
{
    use Postable;

    protected $table = 'cms_partners';

    public $timestamps = false;

    protected $fillable = [
        'customer_name',
    ];

    protected static function booted(): void
    {
        static::observe(PartnerObserver::class);
    }
}
