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
        Schema::create('cms_portfolio_posts', function (Blueprint $table) {
            $table->id();
            // Tipo
            // 1 - 'Imagem', 2 - 'Vídeo', 3 - 'Galeria de Fotos e Vídeos', 4 - 'Case de Sucesso'...
            $table->char('role', 1)->default(1);
            // Vídeos destaques (embed)
            $table->json('embed_videos')->nullable();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('cms_portfolio_posts');
    }
};
