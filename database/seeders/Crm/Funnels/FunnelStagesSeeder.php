<?php

namespace Database\Seeders\Crm\Funnels;

use App\Models\Crm\Funnels\Funnel;
use App\Models\Crm\Funnels\FunnelStage;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class FunnelStagesSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $this->truncateTable();

        $probabilities = [30, 50, 80, 100, 0];

        Funnel::all()
            ->each(function (Funnel $funnel) use ($probabilities): void {
                foreach ($probabilities as $index => $probability) {
                    FunnelStage::factory()
                        ->create([
                            'funnel_id'            => $funnel->id,
                            'business_probability' => $probability,
                            'order'                => $index + 1,
                        ]);
                }
            });
    }

    protected function truncateTable()
    {
        $this->command->info('Truncating CRM Funnel Stage table');
        Schema::disableForeignKeyConstraints();

        DB::table('crm_funnel_stages')
            ->truncate();

        Schema::enableForeignKeyConstraints();
    }
}
