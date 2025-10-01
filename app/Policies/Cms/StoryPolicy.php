<?php

namespace App\Policies\Cms;

use App\Models\Cms\Story;
use App\Models\System\User;
use Illuminate\Auth\Access\Response;

class StoryPolicy
{
    /**
     * Determine whether the user can view any models.
     */
    public function viewAny(User $user): bool
    {
        return $user->hasPermissionTo(permission: 'Visualizar [CMS] Histórias');
    }

    /**
     * Determine whether the user can view the model.
     */
    public function view(User $user, Story $story): bool
    {
        return $user->hasPermissionTo(permission: 'Visualizar [CMS] Histórias');
    }

    /**
     * Determine whether the user can create models.
     */
    public function create(User $user): bool
    {
        return $user->hasPermissionTo(permission: 'Cadastrar [CMS] Histórias');
    }

    /**
     * Determine whether the user can update the model.
     */
    public function update(User $user, Story $story): bool
    {
        return $user->hasPermissionTo(permission: 'Editar [CMS] Histórias');
    }

    /**
     * Determine whether the user can delete the model.
     */
    public function delete(User $user, Story $story): bool
    {
        return $user->hasPermissionTo(permission: 'Deletar [CMS] Histórias');
    }

    /**
     * Determine whether the user can restore the model.
     */
    public function restore(User $user, Story $story): bool
    {
        return false;
    }

    /**
     * Determine whether the user can permanently delete the model.
     */
    public function forceDelete(User $user, Story $story): bool
    {
        return false;
    }
}
