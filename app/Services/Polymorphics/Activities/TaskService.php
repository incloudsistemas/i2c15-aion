<?php

namespace App\Services\Polymorphics\Activities;

use App\Enums\Activities\TaskPriorityEnum;
use App\Enums\Activities\TaskRoleEnum;
use App\Models\Crm\Business\Business;
use App\Models\Polymorphics\Activities\Activity;
use App\Models\Polymorphics\Activities\Task;
use Carbon\Carbon;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class TaskService extends ActivityService
{
    public function __construct(protected Activity $activity, protected Task $task)
    {
        parent::__construct(activity: $activity);
    }

    public function getQueryByTasksRole(Builder $query, int $role): Builder
    {
        return $query->with('activityable')
            ->whereHasMorph(
                'activityable',
                [$this->task::class],
                fn(Builder $query): Builder =>
                $query->where('role', $role),
            );
    }

    public function getQueryWhereHasTasks(Builder $query): Builder
    {
        return $query->whereHas('activities', function (Builder $query): Builder {
            return $query->where('activityable_type', MorphMapByClass(model: $this->task::class));
        });
    }

    public function getQueryByOwnersWhereHasTasks(Builder $query): Builder
    {
        return $query->whereHas('ownActivities', function (Builder $query): Builder {
            return $query->where('activityable_type', MorphMapByClass(model: $this->task::class));
        });
    }

    public function tableSortByStartDate(Builder $query, string $direction): Builder
    {
        return $query->orderBy(
            $this->task->select('start_date')
                ->whereColumn('id', 'activities.activityable_id')
                ->limit(1),
            $direction
        )
            ->orderBy(
                $this->task->select('start_time')
                    ->whereColumn('id', 'activities.activityable_id')
                    ->limit(1),
                $direction
            );
    }

    public function tableSearchByPriority(Builder $query, string $search): Builder
    {
        $priorities = TaskPriorityEnum::getAssociativeArray();

        $matchingStatuses = [];
        foreach ($priorities as $index => $priority) {
            if (stripos($priority, $search) !== false) {
                $matchingStatuses[] = $index;
            }
        }

        if ($matchingStatuses) {
            return $query->whereIn('priority', $matchingStatuses);
        }

        return $query;
    }

    public function tableSortByPriority(Builder $query, string $direction): Builder
    {
        $priorities = TaskPriorityEnum::getAssociativeArray();

        $caseParts = [];
        $bindings = [];

        foreach ($priorities as $key => $priority) {
            $caseParts[] = "WHEN ? THEN ?";
            $bindings[] = $key;
            $bindings[] = $priority;
        }

        $orderByCase = "CASE priority " . implode(' ', $caseParts) . " END";

        return $query->orderByRaw("$orderByCase $direction", $bindings);
    }

    public function tableDefaultSort(Builder $query): Builder
    {
        return $query->orderBy(
            $this->task->select('start_date')
                ->whereColumn('id', 'activities.activityable_id')
                ->limit(1),
            'desc'
        )
            ->orderBy(
                $this->task->select('start_time')
                    ->whereColumn('id', 'activities.activityable_id')
                    ->limit(1),
                'desc'
            )
            ->orderBy('created_at', 'desc');
    }

    public function tableFilterByStartDate(Builder $query, array $data): Builder
    {
        if (!$data['start_from'] && !$data['start_until']) {
            return $query;
        }

        return $query->whereHasMorph(
            'activityable',
            [$this->task::class],
            function (Builder $query) use ($data): Builder {
                return $query->when(
                    $data['start_from'],
                    function (Builder $query, $date) use ($data) {
                        if (empty($data['start_until'])) {
                            return $query->whereDate('start_date', '=', $date);
                        }

                        return $query->whereDate('start_date', '>=', $date);
                    }
                )
                    ->when(
                        $data['start_until'],
                        fn(Builder $query, $date): Builder =>
                        $query->whereDate('start_date', '<=', $date)
                    );
            }
        );
    }

    public function tableFilterByPriorities(Builder $query, array $data): Builder
    {
        if (!$data['values'] || empty($data['values'])) {
            return $query;
        }

        return $query->whereHasMorph(
            'activityable',
            [$this->task::class],
            fn(Builder $query): Builder =>
            $query->whereIn('priority', $data['values']),
        );
    }

    public function mutateRecordDataToCreate(Model $ownerRecord, int $role): array
    {
        return [
            'contacts' => isset($ownerRecord->contact) ? [$ownerRecord->contact->id] : null,
            'users'    => isset($ownerRecord->owner) ? [$ownerRecord->owner->id] : null,
            'task'     => [
                'role'              => $role,
                'start_date'        => now(),
                'start_time'        => now()->roundMinutes(5),
                'end_date'          => now(),
                'end_time'          => now()->roundMinutes(5)->addMinutes(45),
                'repeat_occurrence' => 1,
                'repeat_frequency'  => 1,
            ]
        ];
    }

    public function mutateFormDataToCreate(Model $ownerRecord, array $data): array
    {
        // dd($ownerRecord);
        return $data;
    }

    public function mutateRecordDataToEdit(Model $ownerRecord, Activity $activity, array $data): array
    {
        // dd($ownerRecord);
        $data['task']['role'] = $activity->activityable->role->value;
        $data['task']['start_date'] = ConvertEnToPtBrDate(date: $activity->activityable->start_date);
        $data['task']['start_time'] = $activity->activityable->start_time->format('H:i');
        $data['task']['end_date'] = ConvertEnToPtBrDate(date: $activity->activityable->end_date);
        $data['task']['end_time'] = $activity->activityable->end_time?->format('H:i');
        $data['task']['location'] = $activity->activityable->location;
        $data['task']['priority'] = $activity->activityable->priority;

        $data['contacts'] = $activity->contacts->pluck('id')
            ->toArray();

        $data['users'] = $activity->users->pluck('id')
            ->toArray();

        foreach ($activity->activityable->reminders as $key => $reminder) {
            $data['task']['reminders'][$key]['frequency'] = $reminder['frequency'];
            $data['task']['reminders'][$key]['custom_date'] = $reminder['custom_date'];
            $data['task']['reminders'][$key]['custom_time'] = $reminder['custom_time'];
        }

        return $data;
    }

    public function mutateFormDataToEdit(Model $ownerRecord, Activity $activity, array $data): array
    {
        // dd($ownerRecord);
        return $data;
    }

    public function createAction(Model $ownerRecord, array $data): Model
    {
        return DB::transaction(function () use ($ownerRecord, $data): Model {
            $taskData = $data['task'];

            $data['user_id'] = auth()->id();

            $data['business_id'] = $ownerRecord instanceof Business ? $ownerRecord->id : null;

            $taskData['end_date'] = $taskData['end_date'] ?? $taskData['start_date'];
            $taskData['repeat_occurrence'] = $taskData['repeat_occurrence'] ?? 1;
            $taskData['repeat_index'] = 1;

            $task = $this->task->create($taskData);

            $activity = $task->activity()
                ->create($data);

            $this->attachContacts(activity: $activity, contacts: $data['contacts'] ?? null);

            $this->attachUsers(activity: $activity, users: $data['users']);

            if ($data['repeat']) {
                $this->createRecurringTasks(parentTask: $task, data: $data);
            }

            $this->createAttachments(activity: $activity, attachments: $data['attachments']);

            // is business
            if ($activity->business_id) {
                $this->logBusinessSystemInteractions(
                    business: $ownerRecord,
                    activity: $activity,
                    description: $this->getSystemInteractionDescription(role: $activity->activityable->role->value, sentence: $activity->subject, action: 'cadastrado'),
                    currentData: $this->getSystemInteractionData(activity: $activity),
                );
            }

            return $ownerRecord;
        });
    }

    protected function createRecurringTasks(Task $parentTask, array $data): void
    {
        $taskData = $data['task'];
        $taskData['repeat_index'] = $parentTask->repeat_index;

        $parentTask->update([
            'task_id' => $parentTask->id,
        ]);

        $startDate = Carbon::parse($parentTask->start_date);
        $endDate = $parentTask->end_date ? Carbon::parse($parentTask->end_date) : $startDate;

        for ($key = 0; $key < $taskData['repeat_occurrence']; $key++) {
            [$startDate, $endDate] = $this->calculateNextDates(
                frequency: (int) $taskData['repeat_frequency'],
                startDate: $startDate,
                endDate: $endDate
            );

            $taskData['start_date'] = $startDate->copy();
            $taskData['end_date'] = $endDate->copy();
            $taskData['repeat_index'] = $taskData['repeat_index'] + 1;

            $childTask = $parentTask->subtasks()
                ->create($taskData);

            $activity = $childTask->activity()
                ->create($data);

            $this->attachContacts(activity: $activity, contacts: $data['contacts'] ?? null);

            $this->attachUsers(activity: $activity, users: $data['users']);
        }
    }

    protected function calculateNextDates(int $frequency, Carbon $startDate, Carbon $endDate): array
    {
        switch ($frequency) {
            case 1: // Diário
                $startDate->addDay();
                $endDate->addDay();
                break;
            case 2: // Semanal
                $startDate->addWeek();
                $endDate->addWeek();
                break;
            case 3: // Mensal
                $startDate->addMonth();
                $endDate->addMonth();
                break;
            case 4: // Bimestral
                $startDate->addMonths(2);
                $endDate->addMonths(2);
                break;
            case 5: // Trimestral
                $startDate->addMonths(3);
                $endDate->addMonths(3);
                break;
            case 6: // Semestral
                $startDate->addMonths(6);
                $endDate->addMonths(6);
                break;
            case 7: // Anual
                $startDate->addYear();
                $endDate->addYear();
                break;
            case 8: // Dias da semana
                do {
                    $startDate->addDay();
                } while ($startDate->isWeekend());
                do {
                    $endDate->addDay();
                } while ($endDate->isWeekend());
                break;
        }

        return [$startDate, $endDate];
    }

    public function editAction(Model $ownerRecord, Activity $activity, array $data): Model
    {
        return DB::transaction(function () use ($ownerRecord, $activity, $data): Model {
            $oldData = $this->getSystemInteractionData(activity: $activity);

            $activity->update($data);

            $activity->activityable->update($data['task']);

            $this->syncContacts(activity: $activity, contacts: $data['contacts'] ?? null);

            $this->syncUsers(activity: $activity, users: $data['users']);

            $this->createAttachments(activity: $activity, attachments: $data['attachments']);

            // is business
            if ($activity->business_id) {
                $this->logBusinessSystemInteractions(
                    business: $ownerRecord,
                    activity: $activity,
                    description: $this->getSystemInteractionDescription(role: $activity->activityable->role->value, sentence: $activity->subject, action: 'editado'),
                    currentData: $this->getSystemInteractionData(activity: $activity),
                    oldData: $oldData,
                );
            }

            return $ownerRecord;
        });
    }

    public function deleteAction(Model $ownerRecord, Activity $activity): bool
    {
        return DB::transaction(function () use ($ownerRecord, $activity): bool {
            $deleted = $activity->activityable->delete();

            if ($deleted && $activity->business_id) {
                $this->logBusinessSystemInteractions(
                    business: $ownerRecord,
                    activity: $activity,
                    description: $this->getSystemInteractionDescription(role: $activity->activityable->role->value, sentence: $activity->subject, action: 'deletado'),
                    currentData: $this->getSystemInteractionData(activity: $activity),
                );
            }

            return $deleted;
        });
    }

    protected function getSystemInteractionDescription(int $role, string $sentence, string $action): string
    {
        $taskRole = TaskRoleEnum::from($role)
            ->getLabel();

        $userName = auth()->user()->name;

        return "{$taskRole}: {$sentence}, {$action} por: {$userName}";
    }

    protected function getSystemInteractionData(Activity $activity): array
    {
        $users = $activity->users()
            ->pluck('name')
            ->implode(', ');

        $contacts = $activity->contacts()
            ->pluck('name')
            ->implode(', ');

        return [
            'subject'    => $activity->subject,
            'start_date' => $activity->activityable->start_date,
            'start_time' => $activity->activityable->start_time,
            'end_date'   => $activity->activityable->end_date,
            'end_time'   => $activity->activityable->end_time,
            'users'      => $users,
            'contacts'   => $contacts,
            'location'   => $activity->activityable->location,
            'body'       => $activity->body,
            'priority'   => $activity->activityable->priority,
        ];
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
}
