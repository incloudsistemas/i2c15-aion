<?php

namespace App\Providers;

use App\Listeners\System\LogFailedLogin;
use App\Listeners\System\LogLogout;
use App\Listeners\System\LogSuccessfulLogin;
use Illuminate\Foundation\Support\Providers\EventServiceProvider as ServiceProvider;
use Illuminate\Auth\Events\Login;
use Illuminate\Auth\Events\Logout;
use Illuminate\Auth\Events\Failed;

class EventServiceProvider extends ServiceProvider
{
    protected $listen = [
        Login::class  => [LogSuccessfulLogin::class],
        Logout::class => [LogLogout::class],
        Failed::class => [LogFailedLogin::class],
    ];
}
