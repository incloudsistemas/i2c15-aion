<?php

namespace Database\Seeders\Crm\Funnels;

use App\Models\Crm\Funnels\Funnel;
use App\Models\Crm\Funnels\FunnelStage;
use App\Models\Crm\Funnels\FunnelSubstage;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class RealEstateFunnelsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $this->truncateTable();

        // Funnel::factory(5)
        //     ->create();

        // 1) Funil Imobiliário – Vendas de Imóveis
        $pipeline = Funnel::create([
            'name'        => 'Funil de Vendas de Imóveis',
            'description' => 'Etapas adaptadas ao processo de vendas de imóveis novos ou lançamentos.',
            'order'       => 1,
            'status'      => 1,
        ]);

        $pipelineStages = [
            [
                'name'  => 'Lead Captado',
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
                'prob'  => 20,
                'order' => 2,
                'subs'  => [
                    'Validação de Interesse',
                    'Perfil e Capacidade de Pagamento',
                ],
            ],
            [
                'name'  => 'Atendimento e Visita',
                'prob'  => 40,
                'order' => 3,
                'subs'  => [
                    'Agendamento de Visita(s)',
                    'Visita Realizada(s)',
                ],
            ],
            [
                'name'  => 'Negociação',
                'prob'  => 60,
                'order' => 4,
                'subs'  => [
                    'Envio de Proposta',
                    'Contra-oferta ou Condições Especiais',
                ],
            ],
            [
                'name'  => 'Documentação',
                'prob'  => 80,
                'order' => 5,
                'subs'  => [
                    'Envio de Documentos do Cliente',
                    'Aprovação de Crédito ou Análise Jurídica',
                ],
            ],
            [
                'name'  => 'Contrato Assinado - Ganhou',
                'prob'  => 100,
                'order' => 6,
                'subs'  => [],
            ],
            [
                'name'  => 'Venda Perdida',
                'prob'  => 0,
                'order' => 7,
                'subs'  => [],
            ],
        ];

        $this->seedStagesAndSubstages(funnelId: $pipeline->id, stages: $pipelineStages);

        // 2) Funil Imobiliário – Aluguel de Imóveis
        $rent = Funnel::create([
            'name'        => 'Funil de Aluguel de Imóveis',
            'description' => 'Etapas para acompanhar renovações contratuais e manter a ocupação do imóvel.',
            'order'       => 2,
            'status'      => 1,
        ]);

        $rentStages = [
            [
                'name'  => 'Interessado em Locação',
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
                'name'  => 'Visita ao Imóvel',
                'prob'  => 30,
                'order' => 2,
                'subs'  => [
                    'Agendamento de Visita(s)',
                    'Visita(s) Realizada(s)',
                ],
            ],
            [
                'name'  => 'Proposta de Locação',
                'prob'  => 50,
                'order' => 3,
                'subs'  => [
                    'Negociação de Condições',
                    'Escolha de Garantia (fiador, caução, seguro)',
                ],
            ],
            [
                'name'  => 'Análise Cadastral',
                'prob'  => 70,
                'order' => 4,
                'subs'  => [
                    'Envio de Documentação',
                    'Aprovação pela Administradora',
                ],
            ],
            [
                'name'  => 'Contrato Assinado - Ganhou',
                'prob'  => 100,
                'order' => 5,
                'subs'  => [],
            ],
            [
                'name'  => 'Locação Perdida',
                'prob'  => 0,
                'order' => 6,
                'subs'  => [],
            ],
        ];

        $this->seedStagesAndSubstages(funnelId: $rent->id, stages: $rentStages);

        // 3) Funil Imobiliário – Renovação de Aluguel
        $renew = Funnel::create([
            'name'        => 'Funil de Renovação de Aluguel',
            'description' => 'Etapas para acompanhar renovações contratuais e manter a ocupação do imóvel.',
            'order'       => 3,
            'status'      => 1,
        ]);

        $renewStages = [
            [
                'name'  => 'Aviso de Vencimento Enviado',
                'prob'  => 20,
                'order' => 1,
                'subs'  => [
                    'Notificação por E-mail ou WhatsApp',
                    'Contato Telefônico',
                ],
            ],
            [
                'name'  => 'Negociação de Renovação',
                'prob'  => 50,
                'order' => 2,
                'subs'  => [
                    'Proposta de Novo Valor',
                    'Ajustes de Condições Contratuais',
                ],
            ],
            [
                'name'  => 'Aprovação do Inquilino',
                'prob'  => 80,
                'order' => 3,
                'subs'  => [],
            ],
            [
                'name'  => 'Contrato Renovado - Ganhou',
                'prob'  => 100,
                'order' => 4,
                'subs'  => [],
            ],
            [
                'name'  => 'Não Renovou / Desocupação - Perdido',
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
                    'order'           => $key + 1,
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
