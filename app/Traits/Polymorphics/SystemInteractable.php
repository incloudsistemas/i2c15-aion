<?php

namespace App\Traits\Polymorphics;

use App\Models\Polymorphics\SystemInteraction;
use Illuminate\Database\Eloquent\Relations\MorphMany;

trait SystemInteractable
{
    public function systemInteractions(): MorphMany
    {
        return $this->morphMany(related: SystemInteraction::class, name: 'interactable');
    }
}
