<?php

namespace Database\Seeders\Financial;

use App\Models\Financial\BankAccount;
use App\Models\Financial\BankInstitution;
use App\Models\System\Agency;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class BankAccountsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $this->truncateTable();

        $bankInstitutions = BankInstitution::all();
        $agencies = Agency::all();

        BankAccount::factory(15)
            ->create()
            ->each(function (BankAccount $bankAccount) use ($bankInstitutions, $agencies): void {
                $bankAccount->update([
                    'bank_institution_id' => $bankInstitutions->random()->id,
                    'agency_id'           => fake()->boolean(80) ? $agencies->random()->id : null,
                ]);
            });

        BankAccount::factory()
            ->mainAccount()
            ->create([
                'bank_institution_id' => $bankInstitutions->random()->id,
            ]);
    }

    protected function truncateTable()
    {
        $this->command->info('Truncating Financial Bank Accounts table');
        Schema::disableForeignKeyConstraints();

        DB::table('financial_bank_accounts')->truncate();

        Schema::enableForeignKeyConstraints();
    }
}
