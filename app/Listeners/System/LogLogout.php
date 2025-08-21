<?php

namespace App\Listeners\System;

use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Auth\Events\Logout;

class LogLogout
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
    public function handle(Logout $event): void
    {
        /** @var \App\Models\System\User $user */
        $user = $event->user;

        activity()->useLog('auth')
            ->performedOn($user)
            ->causedBy($user)
            ->event('logout')
            ->withProperties([
                'ip'         => request()->ip(),
                'user_agent' => substr((string) request()->userAgent(), 0, 512),
                'guard'      => $event->guard,
                'logout_at'  => now()->toIso8601String(),
            ])
            ->log('Usuário desconectado');
    }
}
