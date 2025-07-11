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
        Schema::create('activities', function (Blueprint $table) {
            $table->id();
            // activityable_id e activityable_type
            $table->morphs('activityable');
            // Criador/Captador "id_owner"
            $table->foreignId('user_id');
            $table->foreign('user_id')
                ->references('id')
                ->on('users')
                ->onUpdate('cascade')
                ->onDelete('cascade');
            // Criador/Captador "id_owner"
            $table->foreignId('business_id')->nullable();
            $table->foreign('business_id')
                ->references('id')
                ->on('crm_business')
                ->onUpdate('cascade')
                ->onDelete('set null');
            // Título/Assunto
            $table->string('subject')->nullable();
            // Conteúdo
            $table->longText('body')->nullable();
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
        Schema::dropIfExists('activities');
    }
};
