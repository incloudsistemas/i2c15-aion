<?php

namespace Database\Seeders\Crm\Funnels;

use App\Models\Crm\Funnels\Funnel;
use App\Models\Crm\Funnels\FunnelStage;
use App\Models\Crm\Funnels\FunnelSubstage;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class DefaultFunnelsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $this->truncateTable();

        // Funnel::factory(5)
        //     ->create();

        // 1) Funil de Vendas Padrão
        $pipeline = Funnel::create([
            'name'        => 'Funil de Vendas Padrão',
            'description' => 'Funil padrão de vendas B2B com ciclo médio de 4–8 semanas.',
            'order'       => 1,
            'status'      => 1,
        ]);

        $pipelineStages = [
            [
                'name'  => 'Prospecção',
                'prob'  => 10,
                'order' => 1,
                'subs'  => [
                    'Aguardando Atendimento',
                    'Tentando Contato',
                    'Contato Realizado',
                    'Descarte Temporário'
                ],
            ],
            [
                'name'  => 'Qualificação',
                'prob'  => 30,
                'order' => 2,
                'subs'  => [
                    'Necessidades Levantadas',
                    'Orçamento Confirmado',
                ],
            ],
            [
                'name'  => 'Proposta',
                'prob'  => 50,
                'order' => 3,
                'subs'  => [
                    'Proposta Elaborada',
                    'Proposta Enviada',
                ],
            ],
            [
                'name'  => 'Negociação',
                'prob'  => 80,
                'order' => 4,
                'subs'  => [
                    'Tratativa de Objeções',
                    'Revisão de Contrato',
                ],
            ],
            [
                'name'  => 'Negócio Fechado – Ganhou',
                'prob'  => 100,
                'order' => 5,
                'subs'  => [],
            ],
            [
                'name'  => 'Negócio Perdido',
                'prob'  => 0,
                'order' => 6,
                'subs'  => [],
            ],
        ];

        $this->seedStagesAndSubstages(funnelId: $pipeline->id, stages: $pipelineStages);

        // 2) Funil de Ganhos Rápidos
        $quick = Funnel::create([
            'name'        => 'Funil de Ganhos Rápidos',
            'description' => 'Funil curto, ideal para vendas simples ou upgrades rápidos.',
            'order'       => 2,
            'status'      => 1,
        ]);

        $quickStages = [
            [
                'name'  => 'Novo',
                'prob'  => 10,
                'order' => 1,
                'subs'  => [],
            ],
            [
                'name'  => 'Contatado',
                'prob'  => 30,
                'order' => 2,
                'subs'  => [],
            ],
            [
                'name'  => 'Demonstração / Proposta',
                'prob'  => 60,
                'order' => 3,
                'subs'  => [
                    'Demonstração Agendada',
                    'Proposta Enviada',
                ],
            ],
            [
                'name'  => 'Decisão',
                'prob'  => 90,
                'order' => 4,
                'subs'  => [],
            ],
            [
                'name'  => 'Negócio Fechado – Ganhou',
                'prob'  => 100,
                'order' => 5,
                'subs'  => [],
            ],
            [
                'name'  => 'Negócio Perdido',
                'prob'  => 0,
                'order' => 6,
                'subs'  => [],
            ],
        ];

        $this->seedStagesAndSubstages(funnelId: $quick->id, stages: $quickStages);

        // 3) Funil de Renovação e Upsell
        $renew = Funnel::create([
            'name'        => 'Funil de Renovação e Upsell',
            'description' => 'Para renovações de contratos ou ofertas de cross-sell.',
            'order'       => 3,
            'status'      => 1,
        ]);

        $renewStages = [
            [
                'name'  => 'Lembrete de Renovação Enviado',
                'prob'  => 20,
                'order' => 1,
                'subs'  => [
                    'Notificação por E-mail ou WhatsApp',
                    'Chamada de Follow-up',
                ],
            ],
            [
                'name'  => 'Negociação (Renovação/Upsell)',
                'prob'  => 50,
                'order' => 2,
                'subs'  => [
                    'Apresentação de Opções',
                    'Ajuste de Termos',
                ],
            ],
            [
                'name'  => 'Aprovado pelo Cliente',
                'prob'  => 80,
                'order' => 3,
                'subs'  => [],
            ],
            [
                'name'  => 'Renovado / Upsell',
                'prob'  => 100,
                'order' => 4,
                'subs'  => [],
            ],
            [
                'name'  => 'Churn',
                'prob'  => 0,
                'order' => 5,
                'subs'  => [],
            ],
        ];

        $this->seedStagesAndSubstages(funnelId: $renew->id, stages: $renewStages);
    }

    protected function seedStagesAndSubstages(int $funnelId, array $stages): void
    {
        foreach ($stages as $stageData) {
            $stage = FunnelStage::create([
                'funnel_id'            => $funnelId,
                'name'                 => $stageData['name'],
                'description'          => null,
                'business_probability' => $stageData['prob'],
                'order'                => $stageData['order'],
            ]);

            foreach ($stageData['subs'] as $key => $subData) {
                FunnelSubstage::create([
                    'funnel_stage_id' => $stage->id,
                    'name'            => $subData,
                    'description'     => null,
                    'order'           => $key+1,
                ]);
            }
        }
    }

    protected function truncateTable()
    {
        $this->command->info('Truncating CRM Funnel table');
        Schema::disableForeignKeyConstraints();

        DB::table('crm_funnel_substages')
            ->truncate();

        DB::table('crm_funnel_stages')
            ->truncate();

        DB::table('crm_funnels')
            ->truncate();

        Schema::enableForeignKeyConstraints();
    }
}
