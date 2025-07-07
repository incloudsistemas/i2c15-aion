<?php

namespace App\Services\Polymorphics;

use App\Models\Polymorphics\SystemInteraction;
use App\Services\BaseService;

class SystemInteractionService extends BaseService
{
    public function __construct(protected SystemInteraction $systemInteraction)
    {
        parent::__construct();
    }
}
