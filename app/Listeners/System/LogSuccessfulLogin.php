<?php

namespace App\Listeners\System;

use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Auth\Events\Failed;

class LogSuccessfulLogin
{
    /**
     * Create the event listener.
     */
    public function __construct()
    {
        //
    }

    /**
     * Handle the event.
     */
    public function handle(Failed $event): void
    {
        activity()->useLog('auth')
            // without performOn/causedBy because user can be null
            ->event('login_failed')
            ->withProperties([
                'ip'         => request()->ip(),
                'user_agent' => substr((string) request()->userAgent(), 0, 512),
                'guard'      => $event->guard,
                'email'      => $event->credentials['email'] ?? null,
                'failed_at'  => now()->toIso8601String(),
            ])
            ->log('Falha no login do usuário');
    }
}
