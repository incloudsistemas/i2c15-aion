<?php

namespace App\Services\Polymorphics\Activities;

use App\Models\Crm\Business\Business;
use App\Models\Crm\Contacts\Contact;
use App\Models\Polymorphics\Activities\Activity;
use App\Models\Polymorphics\Activities\Email;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class EmailService extends ActivityService
{
    public function __construct(protected Activity $activity, protected Email $email)
    {
        parent::__construct(activity: $activity);
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

    public function createAction(Model $ownerRecord, array $data): Model
    {
        return DB::transaction(function () use ($ownerRecord, $data): Model {
            $data['user_id'] = auth()->id();
            $data['business_id'] = $ownerRecord instanceof Business ? $ownerRecord->id : null;

            $data['email']['sender_mail'] = auth()->user()->email;
            $data['email']['recipient_mails'] = $this->getRecipientMails(contacts: $data['contacts']);

            $email = $this->email->create($data['email']);

            $activity = $email->activity()
                ->create($data);

            $this->attachContacts(activity: $activity, contacts: $data['contacts']);

            $this->attachUsers(activity: $activity, users: $data['users']);

            $this->createAttachments(activity: $activity, attachments: $data['attachments']);

            // is business
            if ($activity->business_id) {
                $this->logBusinessSystemInteractions(
                    business: $ownerRecord,
                    activity: $activity,
                    description: $this->getSystemInteractionDescription(sentence: $activity->subject, action: 'cadastrado'),
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

            $data['email']['recipient_mails'] = $this->getRecipientMails(contacts: $data['contacts']);

            $activity->activityable->update($data['email']);

            $this->syncContacts(activity: $activity, contacts: $data['contacts']);

            $this->syncUsers(activity: $activity, users: $data['users']);

            $this->createAttachments(activity: $activity, attachments: $data['attachments']);

            // is business
            if ($activity->business_id) {
                $this->logBusinessSystemInteractions(
                    business: $ownerRecord,
                    activity: $activity,
                    description: $this->getSystemInteractionDescription(sentence: $activity->subject, action: 'editado'),
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
                    description: $this->getSystemInteractionDescription(sentence: $activity->subject, action: 'deletado'),
                    currentData: $this->getSystemInteractionData(activity: $activity),
                );
            }

            return $deleted;
        });
    }

    protected function getRecipientMails(array $contacts): ?array
    {
        $recipientMails = Contact::whereIn('id', $contacts)
            ->pluck('email')
            ->toArray();

        if (empty($recipientMails)) {
            $recipientMails = null;
        }

        return $recipientMails;
    }

    protected function getSystemInteractionDescription(string $sentence, string $action): string
    {
        $userName = auth()->user()->name;

        return "Email: {$sentence}, {$action} por: {$userName}";
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
            'subject'  => $activity->subject,
            'users'    => $users,
            'contacts' => $contacts,
            'body'     => $activity->body,
            'send_at'  => $activity->activityable->send_at,
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
