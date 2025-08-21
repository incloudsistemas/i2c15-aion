<?php

namespace App\View\Components;

use App\Services\Polymorphics\ActivityLogService;
use Closure;
use Illuminate\Contracts\View\View;
use Illuminate\View\Component;
use Spatie\Activitylog\Models\Activity as ActivityLog;

class ActivityLogDataAudit extends Component
{
    /**
     * Create a new component instance.
     */
    public function __construct(public ActivityLog $record)
    {
        //
    }

    /**
     * Get the view / contents that represent the component.
     */
    public function render(): View|Closure|string
    {
        $data = app(ActivityLogService::class)
            ->transform($this->record);

        if (!$data) {
            return view('filament.infolists.polymorphics.activity-log-data-audit-empty');
        }

        // Renderiza a ÚNICA view genérica com os dados padronizados
        return view('filament.infolists.polymorphics.activity-log-data-audit', $data);
    }
}
