<?php

namespace App\Policies\Crm\Business;

use App\Models\Crm\Business\Business;
use App\Models\System\User;
use Illuminate\Auth\Access\Response;

class BusinessPolicy
{
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

        return $this->checkOwnerAccess(user: $user, business: $business);
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

        return $this->checkOwnerAccess(user: $user, business: $business);
    }

    /**
     * Determine whether the user can delete the model.
     */
    public function delete(User $user, Business $business): bool
    {
        if (!$user->hasPermissionTo(permission: 'Deletar [CRM] Negócios')) {
            return false;
        }

        return $this->checkOwnerAccess(user: $user, business: $business);
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

    protected function checkOwnerAccess(User $user, Business $business): ?bool
    {
        if ($user->hasAnyRole(['Superadministrador', 'Administrador'])) {
            return true;
        }

        if ($business->currentUser->id === $user->id) {
            return true;
        }

        return false;
    }
}
