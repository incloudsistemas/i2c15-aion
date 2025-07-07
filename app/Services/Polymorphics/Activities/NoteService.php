<?php

namespace App\Services\Polymorphics\Activities;

use App\Enums\Activities\NoteRoleEnum;
use App\Models\Crm\Business\Business;
use App\Models\Polymorphics\Activities\Activity;
use App\Models\Polymorphics\Activities\Note;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class NoteService extends ActivityService
{
    public function __construct(protected Activity $activity, protected Note $note)
    {
        parent::__construct(activity: $activity);
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

    public function createAction(Model $ownerRecord, array $data): Model
    {
        return DB::transaction(function () use ($ownerRecord, $data): Model {
            $data['user_id'] = auth()->id();
            $data['business_id'] = $ownerRecord instanceof Business ? $ownerRecord->id : null;

            $note = $this->note->create($data['note']);

            $activity = $note->activity()
                ->create($data);

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

    public function editAction(Model $ownerRecord, Activity $activity, array $data): Model
    {
        return DB::transaction(function () use ($ownerRecord, $activity, $data): Model {
            $oldData = $this->getSystemInteractionData(activity: $activity);

            $activity->update($data);

            $activity->activityable->update($data['note']);

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
        $noteRole = NoteRoleEnum::from($role)
            ->getLabel();

        $userName = auth()->user()->name;

        return "{$noteRole}: {$sentence}, {$action} por: {$userName}";
    }

    protected function getSystemInteractionData(Activity $activity): array
    {
        return [
            'subject'     => $activity->subject,
            'body'        => $activity->body,
            'register_at' => $activity->activityable->register_at,
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
