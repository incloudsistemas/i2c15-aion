<?php

namespace App\Policies\Cms;

use App\Models\Cms\LinkTree;
use App\Models\System\User;
use Illuminate\Auth\Access\Response;

class LinkTreePolicy
{
    /**
     * Determine whether the user can view any models.
     */
    public function viewAny(User $user): bool
    {
        return $user->hasPermissionTo(permission: 'Visualizar [CMS] Árvore de Links');
    }

    /**
     * Determine whether the user can view the model.
     */
    public function view(User $user, LinkTree $linkTree): bool
    {
        return $user->hasPermissionTo(permission: 'Visualizar [CMS] Árvore de Links');
    }

    /**
     * Determine whether the user can create models.
     */
    public function create(User $user): bool
    {
        return $user->hasPermissionTo(permission: 'Cadastrar [CMS] Árvore de Links');
    }

    /**
     * Determine whether the user can update the model.
     */
    public function update(User $user, LinkTree $linkTree): bool
    {
        return $user->hasPermissionTo(permission: 'Editar [CMS] Árvore de Links');
    }

    /**
     * Determine whether the user can delete the model.
     */
    public function delete(User $user, LinkTree $linkTree): bool
    {
        return $user->hasPermissionTo(permission: 'Deletar [CMS] Árvore de Links');
    }

    /**
     * Determine whether the user can restore the model.
     */
    public function restore(User $user, LinkTree $linkTree): bool
    {
        return false;
    }

    /**
     * Determine whether the user can permanently delete the model.
     */
    public function forceDelete(User $user, LinkTree $linkTree): bool
    {
        return false;
    }
}
