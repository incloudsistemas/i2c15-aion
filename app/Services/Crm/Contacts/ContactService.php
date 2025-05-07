<?php

namespace App\Services\Crm\Contacts;

use App\Enums\ProfileInfos\UserStatusEnum;
use App\Models\Crm\Contacts\Contact;
use App\Models\Crm\Contacts\Individual;
use App\Models\Crm\Contacts\LegalEntity;
use App\Services\BaseService;
use Closure;
use Illuminate\Database\Eloquent\Builder;
use Filament\Notifications\Notification;
use Illuminate\Database\Eloquent\Collection;

class ContactService extends BaseService
{
    protected string $contactTable;

    public function __construct(protected Contact $contact)
    {
        parent::__construct();

        $this->contactTable = $contact->getTable();
    }

    public function tableSearchByNameAndContactableCpfOrCnpj(Builder $query, string $search): Builder
    {
        return $query->whereHas('contactable', function (Builder $query) use ($search): Builder {
            return $query->when(
                $query->getModel()->getTable() === 'crm_contact_individuals',
                function (Builder $query) use ($search): Builder {
                    return $query->where('cpf', 'like', "%{$search}%")
                        ->orWhereRaw("REPLACE(REPLACE(REPLACE(cpf, '.', ''), '-', ''), '/', '') LIKE ?", ["%{$search}%"]);
                }
            )
                ->when(
                    $query->getModel()->getTable() === 'crm_contact_legal_entities',
                    function (Builder $query) use ($search): Builder {
                        return $query->where('cnpj', 'like', "%{$search}%")
                            ->orWhereRaw("REPLACE(REPLACE(REPLACE(cnpj, '.', ''), '-', ''), '/', '') LIKE ?", ["%{$search}%"]);
                    }
                );
        })
            ->orWhere('name', 'like', "%{$search}%");
    }

    public function tableSearchByContactNameAndCpfOrCnpj(Builder $query, string $search): Builder
    {
        return $query->whereHas('contact', function (Builder $query) use ($search): Builder {
            return $query->where('name', 'like', "%{$search}%");
        })
            ->orWhere(function (Builder $query) use ($search): Builder {
                return $query->when(
                    $query->getModel()->getTable() === 'crm_contact_individuals',
                    function ($query) use ($search): Builder {
                        return $query->where('cpf', 'like', "%{$search}%")
                            ->orWhereRaw("REPLACE(REPLACE(REPLACE(cpf, '.', ''), '-', ''), '/', '') LIKE ?", ["%{$search}%"]);
                    }
                )
                    ->when(
                        $query->getModel()->getTable() === 'crm_contact_legal_entities',
                        function ($query) use ($search): Builder {
                            return $query->where('cnpj', 'like', "%{$search}%")
                                ->orWhereRaw("REPLACE(REPLACE(REPLACE(cnpj, '.', ''), '-', ''), '/', '') LIKE ?", ["%{$search}%"]);
                        }
                    );
            });
    }

    public function tableSearchByMainPhone(Builder $query, string $search): Builder
    {
        return $query->whereRaw("JSON_EXTRACT(phones, '$[0].number') LIKE ?", ["%$search%"]);
    }

    public function tableSearchByContactMainPhone(Builder $query, string $search): Builder
    {
        return $query->whereHas('contact', function (Builder $query) use ($search): Builder {
            return $query->whereRaw("JSON_EXTRACT(phones, '$[0].number') LIKE ?", ["%$search%"]);
        });
    }

    public function tableSearchByStatus(Builder $query, string $search): Builder
    {
        $statuses = UserStatusEnum::getAssociativeArray();

        $matchingStatuses = [];
        foreach ($statuses as $index => $status) {
            if (stripos($status, $search) !== false) {
                $matchingStatuses[] = $index;
            }
        }

        if ($matchingStatuses) {
            return $query->whereIn('status', $matchingStatuses);
        }

        return $query;
    }

    public function tableSortByStatus(Builder $query, string $direction): Builder
    {
        $statuses = UserStatusEnum::getAssociativeArray();

        $caseParts = [];
        $bindings = [];

        foreach ($statuses as $key => $status) {
            $caseParts[] = "WHEN ? THEN ?";
            $bindings[] = $key;
            $bindings[] = $status;
        }

        $orderByCase = "CASE status " . implode(' ', $caseParts) . " END";

        return $query->orderByRaw("$orderByCase $direction", $bindings);
    }

    public function tableSearchByContactStatus(Builder $query, string $search): Builder
    {
        $statuses = UserStatusEnum::getAssociativeArray();

        $matchingStatuses = [];
        foreach ($statuses as $index => $status) {
            if (stripos($status, $search) !== false) {
                $matchingStatuses[] = $index;
            }
        }

        if ($matchingStatuses) {
            return $query->whereHas('contact', function (Builder $query) use ($matchingStatuses): Builder {
                return $query->whereIn('status', $matchingStatuses);
            });
        }

        return $query;
    }

    public function tableSortByContactStatus(Builder $query, string $direction): Builder
    {
        $contactableType = MorphMapByClass(model: $query->getModel()::class);
        $statuses = UserStatusEnum::getAssociativeArray();

        $caseParts = [];
        $bindings = [];

        foreach ($statuses as $key => $status) {
            $caseParts[] = "WHEN (SELECT status FROM {$this->contactTable} WHERE {$this->contactTable}.contactable_type = '{$contactableType}' AND {$this->contactTable}.contactable_id = {$contactableType}.id) = ? THEN ?";
            $bindings[] = $key;
            $bindings[] = $status;
        }

        $orderByCase = "CASE " . implode(' ', $caseParts) . " END";

        return $query->selectRaw("*, ({$orderByCase}) as display_status", $bindings)
            ->orderBy('display_status', $direction);
    }

    public function getQueryByRolesWhereHasContacts(Builder $query): Builder
    {
        return $query->whereHas('contacts')
            ->orderBy('id', 'asc');
    }

    public function getQueryBySourcesWhereHasContacts(Builder $query): Builder
    {
        return $query->whereHas('contacts')
            ->orderBy('id', 'asc');
    }

    public function getQueryByOwnersWhereHasContacts(Builder $query): Builder
    {
        return $query->whereHas('contacts')
            ->orderBy('id', 'asc');
    }

    public function validateEmail(?Contact $contact, string $contactableType, string $attribute, string $state, Closure $fail): void
    {
        $userId = auth()->user()->id;

        if ($contact) {
            $userId = $contact->user_id;
        }

        $exists = $this->contact->where('email', $state)
            ->where('user_id', $userId)
            ->where('contactable_type', $contactableType)
            ->when($contact, function (Builder $query) use ($contact): Builder {
                return $query->where('contactable_id', '<>', $contact->contactable_id);
            })
            ->first();

        if ($exists) {
            $fail(__('O valor informado para o campo email já está em uso.', ['attribute' => $attribute]));
        }
    }

    public function validatePhone(?Contact $contact, string $contactableType, string $attribute, string $state, Closure $fail): void
    {
        $userId = auth()->user()->id;

        if ($contact) {
            $userId = $contact->user_id;
        }

        $exists = $this->contact->whereRaw("JSON_EXTRACT(phones, '$[0].number') = ?", ["$state"])
            ->where('user_id', $userId)
            ->where('contactable_type', $contactableType)
            ->when($contact, function ($query) use ($contact): Builder {
                return $query->where('contactable_id', '<>', $contact->contactable_id);
            })
            ->first();

        if ($exists) {
            $fail(__('O valor informado para o campo telefone já está em uso.', ['attribute' => $attribute]));
        }
    }

    public function tableFilterByContactStatuses(Builder $query, array $data): Builder
    {
        if (!$data['values'] || empty($data['values'])) {
            return $query;
        }

        return $query->whereHas('contact', function (Builder $query) use ($data): Builder {
            return $query->whereIn('status', $data['values']);
        });
    }

    public function tableFilterByContactCreatedAt(Builder $query, array $data): Builder
    {
        return $query
            ->when(
                $data['created_from'],
                fn(Builder $query, $date): Builder =>
                $query->whereHas('contact', function (Builder $query) use ($date): Builder {
                    return $query->whereDate('created_at', '>=', $date);
                }),
            )
            ->when(
                $data['created_until'],
                fn(Builder $query, $date): Builder =>
                $query->whereHas('contact', function (Builder $query) use ($date): Builder {
                    return $query->whereDate('created_at', '<=', $date);
                }),
            );
    }

    public function tableFilterByContactUpdatedAt(Builder $query, array $data): Builder
    {
        return $query
            ->when(
                $data['updated_from'],
                fn(Builder $query, $date): Builder =>
                $query->whereHas('contact', function (Builder $query) use ($date): Builder {
                    return $query->whereDate('updated_at', '>=', $date);
                }),
            )
            ->when(
                $data['updated_until'],
                fn(Builder $query, $date): Builder =>
                $query->whereHas('contact', function (Builder $query) use ($date): Builder {
                    return $query->whereDate('updated_at', '<=', $date);
                }),
            );
    }

    /**
     * $action can be:
     * Filament\Tables\Actions\DeleteAction;
     * Filament\Actions\DeleteAction;
     */
    public function preventDeleteIf($action, Contact $contact): void
    {
        $title = __('Ação proibida: Exclusão de contato');

        if ($this->isAssignedToBusiness(contact: $contact)) {
            Notification::make()
                ->title($title)
                ->warning()
                ->body(__('Este contato possui negócios associados. Para excluir, você deve primeiro desvincular todos os negócios que estão associados a ele.'))
                ->send();

            $action->halt();
        }
    }

    public function deleteBulkAction(Collection $records): void
    {
        $blocked = [];
        $allowed = [];

        foreach ($records as $record) {
            $contact = $record instanceof Contact ? $record : $record->contact;

            if ($this->isAssignedToBusiness(contact: $contact)) {
                $blocked[] = $contact->name;
                continue;
            }

            $allowed[] = $contact;
        }

        if (!empty($blocked)) {
            $displayBlocked = array_slice($blocked, 0, 5);
            $extraCount = count($blocked) - 5;

            $message = __('Os seguintes contatos não podem ser excluídos: ') . implode(', ', $displayBlocked);

            if ($extraCount > 0) {
                $message .= " ... (+$extraCount " . __('outros') . ")";
            }

            Notification::make()
                ->title(__('Alguns contatos não puderam ser excluídos'))
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

    protected function isAssignedToBusiness(Contact $contact): bool
    {
        // return $contact->business()
        //     ->exists();

        return false;
    }
}
