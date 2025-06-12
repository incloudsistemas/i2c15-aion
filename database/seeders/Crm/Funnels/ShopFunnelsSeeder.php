<?php

namespace Database\Seeders\Crm\Funnels;

use App\Models\Crm\Funnels\Funnel;
use App\Models\Crm\Funnels\FunnelStage;
use App\Models\Crm\Funnels\FunnelSubstage;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class ShopFunnelsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $this->truncateTable();

        // Funnel::factory(5)
        //     ->create();

        // 1) Funil de Loja Física (PDV)
        $pipeline = Funnel::create([
            'name'        => 'Funil de Loja Física (PDV)',
            'description' => 'Etapas de atendimento e conversão no ponto de venda físico.',
            'order'       => 1,
            'status'      => 1,
        ]);

        $pipelineStages = [
            [
                'name'  => 'Cliente Interessado',
                'prob'  => 10,
                'order' => 1,
                'subs'  => [
                    'Abordagem na Loja',
                    'Lead via WhatsApp ou Instagram',
                ],
            ],
            [
                'name'  => 'Necessidade Identificada',
                'prob'  => 30,
                'order' => 2,
                'subs'  => [
                    'Conversa com Vendedor',
                    'Demonstração do Produto',
                ],
            ],
            [
                'name'  => 'Proposta ou Condição Apresentada',
                'prob'  => 50,
                'order' => 3,
                'subs'  => [
                    'Oferta Especial ou Desconto',
                    'Parcelamento Apresentado',
                ],
            ],
            [
                'name'  => 'Cliente Decidindo',
                'prob'  => 70,
                'order' => 4,
                'subs'  => [
                    'Tratativa de Objeções',
                    'Revisão de Contrato',
                ],
            ],
            [
                'name'  => 'Compra Realizada – Ganhou',
                'prob'  => 100,
                'order' => 5,
                'subs'  => [],
            ],
            [
                'name'  => 'Não Comprou - Perdido',
                'prob'  => 0,
                'order' => 6,
                'subs'  => [],
            ],
        ];

        $this->seedStagesAndSubstages(funnelId: $pipeline->id, stages: $pipelineStages);

        // 2) Funil de Loja Virtual (E-commerce)
        $ecommerce = Funnel::create([
            'name'        => 'Funil de Loja Virtual (E-commerce)',
            'description' => 'Acompanhamento de leads, carrinhos e pedidos online.',
            'order'       => 2,
            'status'      => 1,
        ]);

        $ecommerceStages = [
            [
                'name'  => 'Visitou o Site / Landing Page',
                'prob'  => 10,
                'order' => 1,
                'subs'  => [
                    'Acesso Direto ou Redes Sociais',
                    'Clique em Anúncio'
                ],
            ],
            [
                'name'  => 'Adicionou ao Carrinho',
                'prob'  => 30,
                'order' => 2,
                'subs'  => [],
            ],
            [
                'name'  => 'Iniciou Checkout',
                'prob'  => 60,
                'order' => 3,
                'subs'  => [
                    'Cadastro Iniciado',
                    'Preenchimento de Endereço',
                ],
            ],
            [
                'name'  => 'Pedido Realizado',
                'prob'  => 90,
                'order' => 4,
                'subs'  => [],
            ],
            [
                'name'  => 'Pedido Pago – Ganhou',
                'prob'  => 100,
                'order' => 5,
                'subs'  => [],
            ],
            [
                'name'  => 'Carrinho Abandonado - Perdido',
                'prob'  => 0,
                'order' => 6,
                'subs'  => [],
            ],
        ];

        $this->seedStagesAndSubstages(funnelId: $ecommerce->id, stages: $ecommerceStages);
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
