<?php

return [
    /**
     * Control if the seeder should create a user per role while seeding the data.
     */
    'create_users' => false,

    /**
     * Control if all the permissions tables should be truncated before running the seeder.
     */
    'truncate_tables' => true,

    'roles_structure' => [
        // SUPERADMINISTRADOR: possui acesso total e irrestrito a todos os módulos e registros do sistema.
        'Superadministrador' => [
            'Usuários'          => 'c,r,u,d',
            'Níveis de Acessos' => 'c,r,u,d',
            'Agências'          => 'c,r,u,d',
            'Equipes'           => 'c,r,u,d',

            '[CRM] Origens dos Contatos/Negócios' => 'c,r,u,d',
            '[CRM] Tipos de Contatos'             => 'c,r,u,d',
            '[CRM] Contatos'                      => 'c,r,u,d',
            '[CRM] Funis de Negócios'             => 'c,r,u,d',
            '[CRM] Negócios'                      => 'c,r,u,d',
            // '[CRM] Filas'                         => 'c,r,u,d',

            // '[Financeiro] Contas Bancárias'       => 'c,r,u,d',
            // '[Financeiro] Transações Financeiras' => 'c,r,u,d',
            // '[Financeiro] Categorias'             => 'c,r,u,d',

            // '[CMS] Páginas'         => 'c,r,u,d',
            // '[CMS] Blog'            => 'c,r,u,d',
            // '[CMS] Depoimentos'     => 'c,r,u,d',
            // '[CMS] Parceiros'       => 'c,r,u,d',
            // '[CMS] Links Externos'  => 'c,r,u,d',
            // '[CMS] Stories'         => 'c,r,u,d',
            // '[CMS] Árvore de Links' => 'c,r,u,d',
            // '[CMS] Categorias'      => 'c,r,u,d',
            // '[CMS] Sliders'         => 'c,r,u,d',
        ],
        // CLIENTE: perfil externo, utilizado em casos onde o cliente precisa acessar dados restritos dele próprio.
        'Cliente' => [
            //
        ],
        // ADMINISTRADOR: possui controle total de uma unidade ou sistema, com permissões semelhantes ao superadministrador, mas em contexto mais limitado.
        'Administrador' => [
            'Usuários'          => 'c,r,u,d',
            'Níveis de Acessos' => 'c,r,u,d',
            'Agências'          => 'c,r,u,d',
            'Equipes'           => 'c,r,u,d',

            '[CRM] Origens dos Contatos/Negócios' => 'c,r,u,d',
            '[CRM] Tipos de Contatos'             => 'c,r,u,d',
            '[CRM] Contatos'                      => 'c,r,u,d',
            '[CRM] Funis de Negócios'             => 'c,r,u,d',
            '[CRM] Negócios'                      => 'c,r,u,d',
            // '[CRM] Filas'                         => 'c,r,u,d',

            // '[Financeiro] Contas Bancárias'       => 'c,r,u,d',
            // '[Financeiro] Transações Financeiras' => 'c,r,u,d',
            // '[Financeiro] Categorias'             => 'c,r,u,d',

            // '[CMS] Páginas'         => 'c,r,u,d',
            // '[CMS] Blog'            => 'c,r,u,d',
            // '[CMS] Depoimentos'     => 'c,r,u,d',
            // '[CMS] Parceiros'       => 'c,r,u,d',
            // '[CMS] Links Externos'  => 'c,r,u,d',
            // '[CMS] Stories'         => 'c,r,u,d',
            // '[CMS] Árvore de Links' => 'c,r,u,d',
            // '[CMS] Categorias'      => 'c,r,u,d',
            // '[CMS] Sliders'         => 'c,r,u,d',
        ],
        // LÍDER: responsável por uma ou mais agências, podendo visualizar e gerenciar todos os dados das equipes e usuários subordinados às suas agências.
        'Líder' => [
            'Usuários' => 'c,r,u,d',
            'Equipes'  => 'c,r,u,d',

            '[CRM] Contatos' => 'c,r,u,d',
            '[CRM] Negócios' => 'c,r,u,d',
            // '[CRM] Filas' => 'c,r,u,d',

            // '[Financeiro] Contas Bancárias'       => 'c,r,u,d',
            // '[Financeiro] Transações Financeiras' => 'c,r,u,d',
            // '[Financeiro] Categorias'             => 'c,r,u,d',
        ],
        // COORDENADOR: gerencia uma ou mais equipes dentro de uma ou mais agências. Pode visualizar os dados de sua equipe e seus subordinados.
        'Coordenador' => [
            '[CRM] Contatos' => 'c,r,u,d',
            '[CRM] Negócios' => 'c,r,u,d',
        ],
        // COLABORADOR: perfil padrão operacional, limitado a visualizar, cadastrar e editar seus próprios contatos e negócios.
        'Colaborador' => [
            '[CRM] Contatos' => 'c,r,u,d',
            '[CRM] Negócios' => 'c,r,u,d',
        ],
        // FINANCEIRO: acesso restrito a módulos financeiros da empresa.
        'Financeiro' => [
            // '[Financeiro] Contas Bancárias'       => 'c,r,u,d',
            // '[Financeiro] Transações Financeiras' => 'c,r,u,d',
            // '[Financeiro] Categorias'             => 'c,r,u,d',
        ],
        // MARKETING: gerencia conteúdo e campanhas publicitárias do sistema.
        'Marketing' => [
            // '[CMS] Páginas'         => 'c,r,u,d',
            // '[CMS] Blog'            => 'c,r,u,d',
            // '[CMS] Depoimentos'     => 'c,r,u,d',
            // '[CMS] Parceiros'       => 'c,r,u,d',
            // '[CMS] Links Externos'  => 'c,r,u,d',
            // '[CMS] Stories'         => 'c,r,u,d',
            // '[CMS] Árvore de Links' => 'c,r,u,d',
            // '[CMS] Categorias'      => 'c,r,u,d',
            // '[CMS] Sliders'         => 'c,r,u,d',
        ],
    ],

    'permissions_map' => [
        'c' => 'Cadastrar',
        'r' => 'Visualizar',
        'u' => 'Editar',
        'd' => 'Deletar'
    ]
];
