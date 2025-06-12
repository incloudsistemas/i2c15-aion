<?php

namespace App\Providers;

use Illuminate\Database\Eloquent\Relations\Relation;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        // Morph map for polymorphic relations.
        Relation::morphMap([
            'users'       => 'App\Models\System\User',
            'permissions' => 'App\Models\System\Permission',
            'roles'       => 'App\Models\System\Role',
            'agencies'    => 'App\Models\System\Agency',
            'teams'       => 'App\Models\System\Team',

            'crm_sources'                => 'App\Models\Crm\Source',
            'crm_contact_roles'          => 'App\Models\Crm\Contacts\Role',
            'crm_contacts'               => 'App\Models\Crm\Contacts\Contact',
            'crm_contact_individuals'    => 'App\Models\Crm\Contacts\Individual',
            'crm_contact_legal_entities' => 'App\Models\Crm\Contacts\LegalEntity',

            'crm_funnels'                => 'App\Models\Crm\Funnels\Funnel',
            'crm_funnel_stages'          => 'App\Models\Crm\Funnels\FunnelStage',
            'crm_funnel_substages'       => 'App\Models\Crm\Funnels\FunnelSubstage',
            'crm_business'               => 'App\Models\Crm\Business\Business',
            'crm_business_funnel_stages' => 'App\Models\Crm\Business\FunnelStage',
            'crm_business_interactions'  => 'App\Models\Crm\Business\Interaction',
            'crm_business_activities'    => 'App\Models\Crm\Business\Activity',

            // 'financial_bank_accounts'     => 'App\Models\Financial\BankAccount',
            // 'financial_transactions'      => 'App\Models\Financial\Transaction',
            // 'financial_categories'        => 'App\Models\Financial\Category',

            // 'cms_posts'                 => 'App\Models\Cms\Post',
            // 'cms_pages'                 => 'App\Models\Cms\Page',
            // 'cms_blog_posts'            => 'App\Models\Cms\BlogPost',
            // 'cms_testimonials'          => 'App\Models\Cms\Testimonial',
            // 'cms_partners'              => 'App\Models\Cms\Partner',
            // 'cms_external_useful_links' => 'App\Models\Cms\ExternalUsefulLink',
            // 'cms_stories'               => 'App\Models\Cms\Story',
            // 'cms_link_trees'            => 'App\Models\Cms\LinkTree',
            // 'cms_post_categories'       => 'App\Models\Cms\PostCategory',
            // 'cms_post_sliders'          => 'App\Models\Cms\PostSlider',

            'addresses'  => 'App\Models\Polymorphics\Address',
            'activities' => 'App\Models\Polymorphics\Activity',
        ]);
    }
}
