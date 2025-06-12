<?php

namespace App\Services\System;

use App\Models\System\Team;
use App\Services\BaseService;
use Filament\Notifications\Notification;
use Illuminate\Database\Eloquent\Collection;

class TeamService extends BaseService
{
    public function __construct(protected Team $team)
    {
        parent::__construct();
    }

    /**
     * $action can be:
     * Filament\Tables\Actions\DeleteAction;
     * Filament\Actions\DeleteAction;
     */
    public function preventDeleteIf($action, Team $team): void
    {
        $title = __('Ação proibida: Exclusão de equipe');

        // if ($this->isAssignedToAgencies(team: $team)) {
        //     Notification::make()
        //         ->title($title)
        //         ->warning()
        //         ->body(__('Esta equipe possui uma agência associada. Para excluir, você deve primeiro desvincular a agência que está associada a ela.'))
        //         ->send();

        //     $action->halt();
        // }
    }

    public function deleteBulkAction(Collection $records): void
    {
        $blocked = [];
        $allowed = [];

        foreach ($records as $team) {
            // if ($this->isAssignedToAgencies(team: $team)) {
            //     $blocked[] = $team->name;
            //     continue;
            // }

            $allowed[] = $team;
        }

        if (!empty($blocked)) {
            $displayBlocked = array_slice($blocked, 0, 5);
            $extraCount = count($blocked) - 5;

            $message = __('As seguintes equipes não podem ser excluídas: ') . implode(', ', $displayBlocked);

            if ($extraCount > 0) {
                $message .= " ... (+$extraCount " . __('outros') . ")";
            }

            Notification::make()
                ->title(__('Algumas equipes não puderam ser excluídas'))
                ->warning()
                ->body($message)
                ->send();
        }

        collect($allowed)->each->delete();

        if (!empty($allowed)) {
            Notification::make()
                ->title(__('Excluído'))
                ->success()
                ->send();
        }
    }
}
