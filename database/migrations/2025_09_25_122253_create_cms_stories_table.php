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
        Schema::create('cms_stories', function (Blueprint $table) {
            $table->id();
            // Tipo
            // 1 - 'Imagem', 2 - 'Vídeo'...
            $table->char('role', 1)->default(1);
            // Chamada para ação (Call to action)
            $table->json('cta')->nullable();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('cms_stories');
    }
};
