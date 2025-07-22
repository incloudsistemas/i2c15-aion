<?php

namespace App\Policies\Financial;

use App\Models\Financial\BankAccount;
use App\Models\System\User;
use Illuminate\Auth\Access\Response;

class BankAccountPolicy
{
    /**
     * Determine whether the user can view any models.
     */
    public function viewAny(User $user): bool
    {
        return $user->hasPermissionTo(permission: 'Visualizar [Financeiro] Contas Bancárias');
    }

    /**
     * Determine whether the user can view the model.
     */
    public function view(User $user, BankAccount $bankAccount): bool
    {
        return $user->hasPermissionTo(permission: 'Visualizar [Financeiro] Contas Bancárias');
    }

    /**
     * Determine whether the user can create models.
     */
    public function create(User $user): bool
    {
        return $user->hasPermissionTo(permission: 'Cadastrar [Financeiro] Contas Bancárias');
    }

    /**
     * Determine whether the user can update the model.
     */
    public function update(User $user, BankAccount $bankAccount): bool
    {
        return $user->hasPermissionTo(permission: 'Editar [Financeiro] Contas Bancárias');
    }

    /**
     * Determine whether the user can delete the model.
     */
    public function delete(User $user, BankAccount $bankAccount): bool
    {
        return $user->hasPermissionTo(permission: 'Deletar [Financeiro] Contas Bancárias');
    }

    /**
     * Determine whether the user can restore the model.
     */
    public function restore(User $user, BankAccount $bankAccount): bool
    {
        return false;
    }

    /**
     * Determine whether the user can permanently delete the model.
     */
    public function forceDelete(User $user, BankAccount $bankAccount): bool
    {
        return false;
    }
}
