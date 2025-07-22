<?php

namespace App\Policies\Financial;

use App\Models\Financial\BankInstitution;
use App\Models\System\User;
use Illuminate\Auth\Access\Response;

class BankInstitutionPolicy
{
    /**
     * Determine whether the user can view any models.
     */
    public function viewAny(User $user): bool
    {
        return $user->hasPermissionTo(permission: 'Visualizar [Financeiro] Instituições Bancárias');
    }

    /**
     * Determine whether the user can view the model.
     */
    public function view(User $user, BankInstitution $bankInstitution): bool
    {
        return $user->hasPermissionTo(permission: 'Visualizar [Financeiro] Instituições Bancárias');
    }

    /**
     * Determine whether the user can create models.
     */
    public function create(User $user): bool
    {
        return $user->hasPermissionTo(permission: 'Cadastrar [Financeiro] Instituições Bancárias');
    }

    /**
     * Determine whether the user can update the model.
     */
    public function update(User $user, BankInstitution $bankInstitution): bool
    {
        return $user->hasPermissionTo(permission: 'Editar [Financeiro] Instituições Bancárias');
    }

    /**
     * Determine whether the user can delete the model.
     */
    public function delete(User $user, BankInstitution $bankInstitution): bool
    {
        return $user->hasPermissionTo(permission: 'Deletar [Financeiro] Instituições Bancárias');
    }

    /**
     * Determine whether the user can restore the model.
     */
    public function restore(User $user, BankInstitution $bankInstitution): bool
    {
        return false;
    }

    /**
     * Determine whether the user can permanently delete the model.
     */
    public function forceDelete(User $user, BankInstitution $bankInstitution): bool
    {
        return false;
    }
}
