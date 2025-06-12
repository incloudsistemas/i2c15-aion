<?php

namespace App\Policies\Crm\Business;

use App\Models\Crm\Business\Business;
use App\Models\System\User;
use App\Services\Crm\Business\BusinessService;
use Illuminate\Auth\Access\Response;

class BusinessPolicy
{
    public function __construct(protected BusinessService $service)
    {
        //
    }

    /**
     * Determine whether the user can view any models.
     */
    public function viewAny(User $user): bool
    {
        return $user->hasPermissionTo(permission: 'Visualizar [CRM] Negócios');
    }

    /**
     * Determine whether the user can view the model.
     */
    public function view(User $user, Business $business): bool
    {
        if (!$user->hasPermissionTo(permission: 'Visualizar [CRM] Negócios')) {
            return false;
        }

        return $this->service->checkOwnerAccess(user: $user, business: $business);
    }

    /**
     * Determine whether the user can create models.
     */
    public function create(User $user): bool
    {
        return $user->hasPermissionTo(permission: 'Cadastrar [CRM] Negócios');
    }

    /**
     * Determine whether the user can update the model.
     */
    public function update(User $user, Business $business): bool
    {
        if (!$user->hasPermissionTo(permission: 'Editar [CRM] Negócios')) {
            return false;
        }

        return $this->service->checkOwnerAccess(user: $user, business: $business);
    }

    /**
     * Determine whether the user can delete the model.
     */
    public function delete(User $user, Business $business): bool
    {
        if (!$user->hasPermissionTo(permission: 'Deletar [CRM] Negócios')) {
            return false;
        }

        return $this->service->checkOwnerAccess(user: $user, business: $business);
    }

    /**
     * Determine whether the user can restore the model.
     */
    public function restore(User $user, Business $business): bool
    {
        return false;
    }

    /**
     * Determine whether the user can permanently delete the model.
     */
    public function forceDelete(User $user, Business $business): bool
    {
        return false;
    }
}
