<?php

namespace Database\Seeders\Cms;

use App\Models\Cms\Page;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class PagesSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $pages = [
            [
                'settings' => [
                    'categories',
                    // 'subtitle',
                    // 'excerpt',
                    // 'body',
                    // 'icon',
                    // 'cta',
                    // 'url',
                    // 'embed_video',
                    // 'video',
                    'image',
                    // 'images',
                    // 'videos',
                    // 'embed_videos',
                    // 'tags',
                    'seo',
                    // 'user_id',
                    // 'order',
                    // 'featured',
                    // 'comment',
                    // 'publish_at',
                    // 'expiration_at',
                    // 'status',
                    'sliders',
                    // 'tabs',
                    // 'accordions',
                    // 'faqs',
                    // 'attachments',
                ],
                'post' => [
                    'title'            => 'Página inicial',
                    'slug'             => 'index',
                    'meta_title'       => 'Aion - CMS, Marketing, CRM e Vendas',
                    'meta_description' => 'Plataforma unificada com site CMS personalizável, CRM robusto, controle financeiro e automação de marketing.',
                ],
                'subpages' => [
                    //
                ],
            ],
        ];

        foreach ($pages as $pageData) {
            $page = Page::create(['settings' => $pageData['settings']]);

            $page->cmsPost()
                ->create($pageData['post']);

            if (isset($pageData['subpages'])) {
                foreach ($pageData['subpages'] as $subpageData) {
                    $subpage = Page::create([
                        'settings' => $subpageData['settings'],
                        'page_id'  => $page->id,
                    ]);

                    $subpage->cmsPost()
                        ->create($subpageData['post']);
                }
            }
        }
    }
}
