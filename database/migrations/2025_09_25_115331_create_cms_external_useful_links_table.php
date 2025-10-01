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
        Schema::create('cms_external_useful_links', function (Blueprint $table) {
            $table->id();
            // Tipo
            // 1 - 'Padrão', ...
            $table->char('role', 1)->default(1);
            $table->enum('target', ['_self', '_blank'])->default('_blank');
            // Ícone
            $table->string('icon')->nullable();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('cms_external_useful_links');
    }
};
