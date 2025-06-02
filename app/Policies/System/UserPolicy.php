<?php

namespace App\Policies\System;

use App\Models\System\User;
use Illuminate\Auth\Access\Response;

class UserPolicy
{
    /**
     * Determine whether the user can view any models.
     */
    public function viewAny(User $user): bool
    {
        return $user->hasPermissionTo(permission: 'Visualizar Usuários');
    }

    /**
     * Determine whether the user can view the model.
     */
    public function view(User $user, User $model): bool
    {
        return $user->hasPermissionTo(permission: 'Visualizar Usuários');
    }

    /**
     * Determine whether the user can create models.
     */
    public function create(User $user): bool
    {
        return $user->hasPermissionTo(permission: 'Cadastrar Usuários');
    }

    /**
     * Determine whether the user can update the model.
     */
    public function update(User $user, User $model): bool
    {
        $hasPermission = $user->hasPermissionTo(permission: 'Editar Usuários');

        if ($user->hasAnyRole(['Superadministrador', 'Administrador'])) {
            return $hasPermission;
        }

        return $hasPermission && !$model->hasAnyRole(['Superadministrador', 'Administrador']);
    }

    /**
     * Determine whether the user can delete the model.
     */
    public function delete(User $user, User $model): bool
    {
        if ($user->id === $model->id) {
            return false;
        }

        $hasPermission = $user->hasPermissionTo(permission: 'Deletar Usuários');

        if ($user->hasAnyRole(['Superadministrador', 'Administrador'])) {
            return $hasPermission;
        }

        return $hasPermission && !$model->hasAnyRole(['Superadministrador', 'Administrador']);
    }

    /**
     * Determine whether the user can restore the model.
     */
    public function restore(User $user, User $model): bool
    {
        return false;
    }

    /**
     * Determine whether the user can permanently delete the model.
     */
    public function forceDelete(User $user, User $model): bool
    {
        return false;
    }
}
