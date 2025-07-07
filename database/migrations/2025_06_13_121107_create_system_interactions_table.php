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
        Schema::create('system_interactions', function (Blueprint $table) {
            $table->id();
            // interactable_id e interactable_type
            $table->morphs('interactable');
            // Criador/Captador "id_owner"
            $table->foreignId('user_id')->nullable();
            $table->foreign('user_id')
                ->references('id')
                ->on('users')
                ->onUpdate('cascade')
                ->onDelete('set null');
            // Descrição da atividade
            $table->text('description')->nullable();
            // Data
            $table->json('data')->nullable();
            // Atributos personalizados
            $table->json('custom')->nullable();
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::disableForeignKeyConstraints();
        Schema::dropIfExists('system_interactions');
    }
};
