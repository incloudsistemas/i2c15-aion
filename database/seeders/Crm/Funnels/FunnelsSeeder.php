<?php

namespace Database\Seeders\Crm\Funnels;

use App\Models\Crm\Funnels\Funnel;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class FunnelsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $this->truncateTable();

        Funnel::factory(5)
            ->create();
    }

    protected function truncateTable()
    {
        $this->command->info('Truncating CRM Funnel table');
        Schema::disableForeignKeyConstraints();

        DB::table('crm_funnels')
            ->truncate();

        Schema::enableForeignKeyConstraints();
    }
}
