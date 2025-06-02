<?php

namespace Database\Seeders\Crm\Business;

use App\Models\Crm\Business\Business;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class BusinessSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $this->truncateTable();

        Business::factory(20)
            ->create();
    }

    protected function truncateTable()
    {
        $this->command->info('Truncating CRM Business table');
        Schema::disableForeignKeyConstraints();

        DB::table('crm_business')
            ->truncate();

        Schema::enableForeignKeyConstraints();
    }
}
