<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('cms_post_subcontents', function (Blueprint $table) {
            $table->id();
            // contentable_id e contentable_type.
            $table->morphs('contentable');
            // Tipo
            // 1 - 'Abas', 2 - 'Acordeões', 3 - 'FAQs'...
            $table->char('role', 1)->default(1);
            // Título
            $table->string('title');
            // Subtítulo
            $table->string('subtitle')->nullable();
            // Chamada
            $table->text('excerpt')->nullable();
            // Conteúdo
            $table->longText('body')->nullable();
            // Url destaque
            $table->string('url')->nullable();
            // Ícone
            $table->string('icon')->nullable();
            // Chamada para ação (Call to action)
            $table->json('cta')->nullable();
            // Vídeo destaque (embed)
            $table->string('embed_video')->nullable();
            // Vídeos destaques (embed)
            $table->json('embed_videos')->nullable();
            // Tags
            $table->json('tags')->nullable();
            // Ordem
            $table->integer('order')->unsigned()->default(1);
            // Status
            // 0- Inativo, 1 - Ativo, 2 - Rascunho
            $table->char('status', 1)->default(1);
            // Data da publicação
            $table->datetime('publish_at')->default(now());
            // Data de expiração
            $table->datetime('expiration_at')->nullable();
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('cms_post_subcontents');
    }
};
