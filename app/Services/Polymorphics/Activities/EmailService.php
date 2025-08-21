<?php

namespace App\Services\Polymorphics\Activities;

use App\Models\Crm\Business\Business;
use App\Models\Crm\Contacts\Contact;
use App\Models\Polymorphics\Activities\Activity;
use App\Models\Polymorphics\Activities\Email;
use App\Models\System\User;
use App\Services\Polymorphics\ActivityLogService;
use Filament\Notifications\Notification;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class EmailService extends ActivityService
{
    public function __construct(
        protected Activity $activity,
        protected Email $email,
        protected ActivityLogService $logService
    ) {
        parent::__construct(activity: $activity, logService: $logService);
    }

    public function getQueryWhereHasEmails(Builder $query): Builder
    {
        return $query->whereHas('activities', function (Builder $query): Builder {
            return $query->where('activityable_type', MorphMapByClass(model: $this->email::class));
        });
    }

    public function getQueryByOwnersWhereHasEmails(Builder $query): Builder
    {
        return $query->whereHas('ownActivities', function (Builder $query): Builder {
            return $query->where('activityable_type', MorphMapByClass(model: $this->email::class));
        });
    }

    public function tableFilterBySendAt(Builder $query, array $data): Builder
    {
        if (!$data['send_from'] && !$data['send_until']) {
            return $query;
        }

        return $query->whereHas('activityable', function (Builder $query) use ($data): Builder {
            return $query->when(
                $data['send_from'],
                function (Builder $query, $date) use ($data) {
                    if (empty($data['send_until'])) {
                        return $query->whereDate('send_at', '=', $date);
                    }

                    return $query->whereDate('send_at', '>=', $date);
                }
            )
                ->when(
                    $data['send_until'],
                    fn(Builder $query, $date): Builder =>
                    $query->whereDate('send_at', '<=', $date)
                );
        });
    }

    public function mutateRecordDataToCreate(Model $ownerRecord): array
    {
        return [
            'contacts' => isset($ownerRecord->contact) ? [$ownerRecord->contact->id] : null,
            'email'    => [
                'send_at' => now(),
            ]
        ];
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

            $data['email']['sender_mail'] = auth()->user()->email;
            $data['email']['recipient_mails'] = $this->getRecipientMails(
                contacts: $data['contacts'],
                users: $data['users']
            );

            $email = $this->email->create($data['email']);

            $activity = $email->activity()
                ->create($data);

            $this->attachContacts(activity: $activity, contacts: $data['contacts']);

            $this->attachUsers(activity: $activity, users: $data['users']);

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
        $data['email']['send_at'] = $activity->activityable->send_at;

        $data['contacts'] = $activity->contacts->pluck('id')
            ->toArray();

        $data['users'] = $activity->users->pluck('id')
            ->toArray();

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

            $data['email']['recipient_mails'] = $this->getRecipientMails(
                contacts: $data['contacts'],
                users: $data['users']
            );

            $activity->activityable->update($data['email']);

            $this->syncContacts(activity: $activity, contacts: $data['contacts']);

            $this->syncUsers(activity: $activity, users: $data['users']);

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

    protected function getRecipientMails(array $contacts, array $users): ?array
    {
        $recipientMails = [];

        if (!empty($contacts)) {
            $contactMails = Contact::whereIn('id', $contacts)
                ->pluck('email')
                ->toArray();

            $recipientMails = array_merge($recipientMails, $contactMails);
        }

        if (!empty($users)) {
            $userMails = User::whereIn('id', $users)
                ->pluck('email')
                ->toArray();

            $recipientMails = array_merge($recipientMails, $userMails);
        }

        $recipientMails = array_values(array_unique($recipientMails));

        return empty($recipientMails) ? null : $recipientMails;
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

        return match ($event) {
            'updated' => "Email <b>{$activity->subject}</b> atualizado por <b>{$user->name}</b>",
            'deleted' => "Email <b>{$activity->subject}</b> excluído por <b>{$user->name}</b>",
            default   => "Novo email <b>{$activity->subject}</b> cadastrado por <b>{$user->name}</b>",
        };
    }
}
