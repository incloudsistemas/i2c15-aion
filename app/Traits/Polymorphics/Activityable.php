<?php

namespace App\Traits\Polymorphics;

use App\Models\Polymorphics\Activities\Activity;
use Illuminate\Database\Eloquent\Relations\MorphOne;

trait Activityable
{
    public function activity(): MorphOne
    {
        return $this->morphOne(related: Activity::class, name: 'activityable');
    }
}
