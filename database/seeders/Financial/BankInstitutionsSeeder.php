<?php

namespace Database\Seeders\Financial;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class BankInstitutionsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $this->truncateTable();

        Artisan::call('app:sync-financial-bank-institutions');
    }

    protected function truncateTable()
    {
        $this->command->info('Truncating Financial Bank Institutions table');
        Schema::disableForeignKeyConstraints();

        DB::table('financial_bank_institutions')->truncate();

        Schema::enableForeignKeyConstraints();
    }
}
