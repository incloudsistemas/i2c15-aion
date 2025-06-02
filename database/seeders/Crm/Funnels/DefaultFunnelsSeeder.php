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

        // 1) Pipeline de Vendas Padrão
        $pipeline = Funnel::create([
            'name'        => 'Pipeline de Vendas Padrão',
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
                    [
                        'name'  => 'Captura de Lead',
                        'order' => 1
                    ],
                    [
                        'name'  => 'Primeiro Contato',
                        'order' => 2
                    ],
                ],
            ],
            [
                'name'  => 'Qualificação',
                'prob'  => 30,
                'order' => 2,
                'subs'  => [
                    [
                        'name'  => 'Necessidades Levantadas',
                        'order' => 1
                    ],
                    [
                        'name'  => 'Orçamento Confirmado',
                        'order' => 2
                    ],
                ],
            ],
            [
                'name'  => 'Proposta',
                'prob'  => 50,
                'order' => 3,
                'subs'  => [
                    [
                        'name'  => 'Proposta Elaborada',
                        'order' => 1
                    ],
                    [
                        'name'  => 'Proposta Enviada',
                        'order' => 2
                    ],
                ],
            ],
            [
                'name'  => 'Negociação',
                'prob'  => 80,
                'order' => 4,
                'subs'  => [
                    [
                        'name'  => 'Tratativa de Objeções',
                        'order' => 1
                    ],
                    [
                        'name'  => 'Revisão de Contrato',
                        'order' => 2
                    ],
                ],
            ],
            [
                'name'  => 'Fechado – Ganhou',
                'prob'  => 100,
                'order' => 5,
                'subs'  => [],
            ],
            [
                'name'  => 'Fechado – Perdido',
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
                    [
                        'name'  => 'Demonstração Agendada',
                        'order' => 1
                    ],
                    [
                        'name'  => 'Proposta Enviada',
                        'order' => 2
                    ],
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
                    [
                        'name'  => 'E-mail de Aviso',
                        'order' => 1
                    ],
                    [
                        'name'  => 'Chamada de Follow-up',
                        'order' => 2
                    ],
                ],
            ],
            [
                'name'  => 'Negociação (Renovação/Upsell)',
                'prob'  => 50,
                'order' => 2,
                'subs'  => [
                    [
                        'name'  => 'Apresentação de Opções',
                        'order' => 1
                    ],
                    [
                        'name'  => 'Ajuste de Termos',
                        'order' => 2
                    ],
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

            foreach ($stageData['subs'] as $subData) {
                FunnelSubstage::create([
                    'funnel_stage_id' => $stage->id,
                    'name'            => $subData['name'],
                    'description'     => null,
                    'order'           => $subData['order'],
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
