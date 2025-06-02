<?php

namespace Database\Seeders\Crm\Funnels;

use App\Models\Crm\Funnels\FunnelStage;
use App\Models\Crm\Funnels\FunnelSubstage;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class FunnelSubstagesSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $this->truncateTable();

        FunnelStage::all()
            ->each(function (FunnelStage $stage): void {
                $count = rand(0, 5);

                if ($count === 0) {
                    return;
                }

                for ($i = 1; $i <= $count; $i++) {
                    FunnelSubstage::factory()
                        ->create([
                            'funnel_stage_id' => $stage->id,
                            'order'           => $i,
                        ]);
                }
            });
    }

    protected function truncateTable()
    {
        $this->command->info('Truncating CRM Funnel Substage table');
        Schema::disableForeignKeyConstraints();

        DB::table('crm_funnel_substages')
            ->truncate();

        Schema::enableForeignKeyConstraints();
    }
}
