<?php

namespace Database\Seeders;

use Database\Seeders\Crm\Business\BusinessSeeder;
use Database\Seeders\Crm\Contacts\ContactsSeeder;
use Database\Seeders\Crm\Contacts\RolesSeeder as ContactRolesSeeder;
use Database\Seeders\Crm\Funnels\DefaultFunnelsSeeder;
use Database\Seeders\Crm\Funnels\FunnelsSeeder;
use Database\Seeders\Crm\Funnels\FunnelStagesSeeder;
use Database\Seeders\Crm\Funnels\FunnelSubstagesSeeder;
use Database\Seeders\Crm\SourcesSeeder;
use Database\Seeders\Financial\BankAccountsSeeder;
use Database\Seeders\Financial\BankInstitutionsSeeder;
use Database\Seeders\Financial\CategoriesSeeder as FinancialCategoriesSeeder;
use Database\Seeders\System\AgenciesSeeder;
use Database\Seeders\System\RolesAndPermissionsSeeder;
use Database\Seeders\System\TeamsSeeder;
use Database\Seeders\System\UsersSeeder;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $this->call([
            RolesAndPermissionsSeeder::class,
            UsersSeeder::class,
            // AgenciesSeeder::class,
            // TeamsSeeder::class,

            ContactRolesSeeder::class,
            SourcesSeeder::class,
            // ContactsSeeder::class,
            // FunnelsSeeder::class,
            // FunnelStagesSeeder::class,
            // FunnelSubstagesSeeder::class,
            DefaultFunnelsSeeder::class,
            // BusinessSeeder::class,

            FinancialCategoriesSeeder::class,
            BankInstitutionsSeeder::class,
            // BankAccountsSeeder::class,
        ]);
    }
}
