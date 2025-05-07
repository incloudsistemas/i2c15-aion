<?php

namespace Database\Seeders;

use Database\Seeders\Crm\Contacts\ContactsSeeder;
use Database\Seeders\Crm\Contacts\RolesSeeder as ContactRolesSeeder;
use Database\Seeders\Crm\SourcesSeeder;
use Database\Seeders\System\RolesAndPermissionsSeeder;
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

            ContactRolesSeeder::class,
            SourcesSeeder::class,
            ContactsSeeder::class,
        ]);
    }
}
