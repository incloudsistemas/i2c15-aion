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
        'Superadministrador' => [
            'Usuários'          => 'c,r,u,d',
            'Níveis de Acessos' => 'c,r,u,d',

            '[CRM] Origens dos Contatos/Negócios' => 'c,r,u,d',
            '[CRM] Tipos de Contatos'             => 'c,r,u,d',
            '[CRM] Contatos'                      => 'c,r,u,d',
            // '[CRM] Funis de Negócios'             => 'c,r,u,d',
            // '[CRM] Negócios'                      => 'c,r,u,d',
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
        'Cliente' => [
            //
        ],
        'Administrador' => [
            'Usuários'          => 'c,r,u,d',
            'Níveis de Acessos' => 'c,r,u,d',

            '[CRM] Origens dos Contatos/Negócios' => 'c,r,u,d',
            '[CRM] Tipos de Contatos'             => 'c,r,u,d',
            '[CRM] Contatos'                      => 'c,r,u,d',
            // '[CRM] Funis de Negócios'             => 'c,r,u,d',
            // '[CRM] Negócios'                      => 'c,r,u,d',
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
    ],

    'permissions_map' => [
        'c' => 'Cadastrar',
        'r' => 'Visualizar',
        'u' => 'Editar',
        'd' => 'Deletar'
    ]
];
