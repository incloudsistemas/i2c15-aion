<?php

namespace App\Traits\Activities;

use App\Models\Polymorphics\Activity;
use Illuminate\Database\Eloquent\Relations\MorphOne;

trait Activityable
{
    public function activity(): MorphOne
    {
        return $this->morphOne(related: Activity::class, name: 'activityable');
    }
}
