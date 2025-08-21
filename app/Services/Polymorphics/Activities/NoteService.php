<?php

namespace App\Services\Polymorphics\Activities;

use App\Enums\Activities\NoteRoleEnum;
use App\Models\Crm\Business\Business;
use App\Models\Polymorphics\Activities\Activity;
use App\Models\Polymorphics\Activities\Note;
use App\Services\Polymorphics\ActivityLogService;
use Filament\Notifications\Notification;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class NoteService extends ActivityService
{
    public function __construct(
        protected Activity $activity,
        protected Note $note,
        protected ActivityLogService $logService
    ) {
        parent::__construct(activity: $activity, logService: $logService);
    }

    public function tableFilterByRoles(Builder $query, array $data): Builder
    {
        if (!$data['values'] || empty($data['values'])) {
            return $query;
        }

        return $query->whereHas('activityable', function (Builder $query) use ($data): Builder {
            return $query->whereIn('role', $data['values']);
        });
    }

    public function getQueryByOwnersWhereHasNotes(Builder $query): Builder
    {
        return $query->whereHas('ownActivities', function (Builder $query): Builder {
            return $query->where('activityable_type', MorphMapByClass(model: $this->note::class));
        });
    }

    public function tableFilterByRegisterAt(Builder $query, array $data): Builder
    {
        if (!$data['register_from'] && !$data['register_until']) {
            return $query;
        }

        return $query->whereHas('activityable', function (Builder $query) use ($data): Builder {
            return $query->when(
                $data['register_from'],
                function (Builder $query, $date) use ($data) {
                    if (empty($data['register_until'])) {
                        return $query->whereDate('register_at', '=', $date);
                    }

                    return $query->whereDate('register_at', '>=', $date);
                }
            )
                ->when(
                    $data['register_until'],
                    fn(Builder $query, $date): Builder =>
                    $query->whereDate('register_at', '<=', $date)
                );
        });
    }

    public function mutateFormDataToCreate(Model $ownerRecord, array $data): array
    {
        // dd($ownerRecord);
        return $data;
    }

    public function createAction(Model $ownerRecord, array $data): Model
    {
        return DB::transaction(function () use ($ownerRecord, $data): Model {
            $data['user_id'] = auth()->id();
            $data['business_id'] = $ownerRecord instanceof Business ? $ownerRecord->id : null;

            $note = $this->note->create($data['note']);

            $activity = $note->activity()
                ->create($data);

            $this->createAttachments(activity: $activity, attachments: $data['attachments']);

            // Log
            $activity->load([
                'activityable',
                'owner:id,name',
                'users:id,name',
                'contacts:id,name',
            ]);

            $this->logService->logOwnerRecordRelationCreatedActivity(
                ownerRecord: $ownerRecord,
                currentRecord: $activity,
                description: $this->getActivityLogDescription(
                    activity: $activity,
                    event: 'created'
                ),
                logName: $activity->activityable_type
            );

            return $ownerRecord;
        });
    }

    public function mutateRecordDataToEdit(Model $ownerRecord, Activity $activity, array $data): array
    {
        // dd($ownerRecord);
        $data['note']['role'] = $activity->activityable->role->value;
        $data['note']['register_at'] = $activity->activityable->register_at;

        return $data;
    }

    public function mutateFormDataToEdit(Model $ownerRecord, Activity $activity, array $data): array
    {
        // dd($ownerRecord);
        return $data;
    }

    public function editAction(Model $ownerRecord, Activity $activity, array $data): Model
    {
        return DB::transaction(function () use ($ownerRecord, $activity, $data): Model {
            $activity->load([
                'activityable',
                'owner:id,name',
                'users:id,name',
                'contacts:id,name',
            ]);

            $oldRecord = $activity->replicate()
                ->toArray();

            $activity->update($data);

            $activity->activityable->update($data['note']);

            $this->createAttachments(activity: $activity, attachments: $data['attachments']);

            // Log
            // reload for nxn relationships
            $activity->load([
                'activityable',
                'owner:id,name',
                'users:id,name',
                'contacts:id,name',
            ]);

            $this->logService->logOwnerRecordRelationUpdatedActivity(
                ownerRecord: $ownerRecord,
                currentRecord: $activity,
                oldRecord: $oldRecord,
                description: $this->getActivityLogDescription(
                    activity: $activity,
                    event: 'updated'
                ),
                logName: $activity->activityable_type
            );

            return $ownerRecord;
        });
    }

    /**
     * $action can be:
     * Filament\Tables\Actions\DeleteAction;
     * Filament\Actions\DeleteAction;
     */
    public function preventDeleteIf($action, Activity $activity): void
    {
        $title = __('Ação proibida: Exclusão de nota');

        // if ($this->isAssignedToBusiness(contact: $contact)) {
        //     Notification::make()
        //         ->title($title)
        //         ->warning()
        //         ->body(__('Este contato possui negócios associados. Para excluir, você deve primeiro desvincular todos os negócios que estão associados a ele.'))
        //         ->send();

        //     $action->halt();
        // }
    }

    public function deleteAction(Model $ownerRecord, Activity $activity): bool
    {
        return DB::transaction(function () use ($ownerRecord, $activity): bool {
            $deleted = $activity->activityable->delete();

            if ($deleted) {
                // Log
                $this->logService->logOwnerRecordRelationDeletedActivity(
                    ownerRecord: $ownerRecord,
                    oldRecord: $activity,
                    description: $this->getActivityLogDescription(
                        activity: $activity,
                        event: 'deleted'
                    ),
                    logName: $activity->activityable_type
                );
            }

            return $deleted;
        });
    }

    public function deleteBulkAction(Collection $records, Model $ownerRecord): void
    {
        $blocked = [];
        $allowed = [];

        foreach ($records as $activity) {
            // if ($this->checkOwnerAccess(activity: $activity, ownerRecord: $ownerRecord)) {
            //     $blocked[] = $activity->name;
            //     continue;
            // }

            $allowed[] = $activity;
        }

        if (!empty($blocked)) {
            $displayBlocked = array_slice($blocked, 0, 5);
            $extraCount = count($blocked) - 5;

            $message = __('Os seguintes emails não podem ser excluídos: ') . implode(', ', $displayBlocked);

            if ($extraCount > 0) {
                $message .= " ... (+$extraCount " . __('outros') . ")";
            }

            Notification::make()
                ->title(__('Alguns emails não puderam ser excluídos'))
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

    public function afterDeleteBulkAction(Model $ownerRecord, Collection $records): void
    {
        foreach ($records as $activity) {
            // Log
            $this->logService->logOwnerRecordRelationDeletedActivity(
                ownerRecord: $ownerRecord,
                oldRecord: $activity,
                description: $this->getActivityLogDescription(
                    activity: $activity,
                    event: 'deleted'
                ),
                logName: $activity->activityable_type
            );
        }
    }

    protected function getActivityLogDescription(Activity $activity, string $event): string
    {
        $user = auth()->user();

        $noteRole = NoteRoleEnum::from($activity->activityable->role->value)
            ->getLabel();

        return match ($event) {
            'updated' => "{$noteRole} <b>{$activity->subject}</b> atualizada por <b>{$user->name}</b>",
            'deleted' => "{$noteRole} <b>{$activity->subject}</b> excluída por <b>{$user->name}</b>",
            default   => "Nova " . strtolower($noteRole) . " <b>{$activity->subject}</b> cadastrada por <b>{$user->name}</b>",
        };
    }
}
