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
        Schema::create('cms_services', function (Blueprint $table) {
            $table->id();
            // Tipo
            // 1 - 'Padrão', ...
            $table->char('role', 1)->default(1);
            // Ícone
            $table->string('icon')->nullable();
            // Chamada para ação (Call to action)
            $table->json('cta')->nullable();
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
        Schema::dropIfExists('cms_services');
    }
};
