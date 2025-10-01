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
        Schema::create('cms_link_trees', function (Blueprint $table) {
            $table->id();
            // Tipo
            // 1 - 'Padrão', 2 - 'Imagem'...
            $table->char('role', 1)->default(1);
            $table->enum('target', ['_self', '_blank'])->default('_blank');
            // Ícone
            $table->string('icon')->nullable();
            // Configurações do botão
            // Cor do botão
            // 'color' => hex -> #000000
            // Cor do texto
            // 'text_color' => 1 - 'dark', 2 - 'light';
            $table->json('button_settings')->nullable();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('cms_link_trees');
    }
};
