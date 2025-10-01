<?php

namespace App\Policies\Cms;

use App\Models\Cms\PortfolioPost;
use App\Models\System\User;
use Illuminate\Auth\Access\Response;

class PortfolioPostPolicy
{
    /**
     * Determine whether the user can view any models.
     */
    public function viewAny(User $user): bool
    {
        return $user->hasPermissionTo(permission: 'Visualizar [CMS] Portfólio');
    }

    /**
     * Determine whether the user can view the model.
     */
    public function view(User $user, PortfolioPost $portfolioPost): bool
    {
        return $user->hasPermissionTo(permission: 'Visualizar [CMS] Portfólio');
    }

    /**
     * Determine whether the user can create models.
     */
    public function create(User $user): bool
    {
        return $user->hasPermissionTo(permission: 'Cadastrar [CMS] Portfólio');
    }

    /**
     * Determine whether the user can update the model.
     */
    public function update(User $user, PortfolioPost $portfolioPost): bool
    {
        return $user->hasPermissionTo(permission: 'Editar [CMS] Portfólio');
    }

    /**
     * Determine whether the user can delete the model.
     */
    public function delete(User $user, PortfolioPost $portfolioPost): bool
    {
        return $user->hasPermissionTo(permission: 'Deletar [CMS] Portfólio');
    }

    /**
     * Determine whether the user can restore the model.
     */
    public function restore(User $user, PortfolioPost $portfolioPost): bool
    {
        return false;
    }

    /**
     * Determine whether the user can permanently delete the model.
     */
    public function forceDelete(User $user, PortfolioPost $portfolioPost): bool
    {
        return false;
    }
}
