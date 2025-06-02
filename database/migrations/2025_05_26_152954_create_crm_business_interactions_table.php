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
        Schema::create('crm_business_interactions', function (Blueprint $table) {
            $table->id();
            // Negócio
            $table->foreignId('business_id');
            $table->foreign('business_id')
                ->references('id')
                ->on('crm_business')
                ->onUpdate('cascade')
                ->onDelete('cascade');
            // Usuário
            $table->foreignId('user_id');
            $table->foreign('user_id')
                ->references('id')
                ->on('users')
                ->onUpdate('cascade')
                ->onDelete('cascade');
            // Contato
            $table->foreignId('contact_id');
            $table->foreign('contact_id')
                ->references('id')
                ->on('crm_contacts')
                ->onUpdate('cascade')
                ->onDelete('cascade');
            // Tipo
            // 1 - 'Note//Observação', 2 - 'Email', 3 - 'Call/Ligação', 4 - 'Task/Tarefa', 5 - 'Meeting/Reunião'...
            $table->char('role', 1);
            // Título/Assunto
            $table->string('subject')->nullable();
            // Conteúdo
            $table->longText('body')->nullable();
            // Dt. agendamento
            $table->timestamp('scheduled_at')->nullable();
            // Dt. conclusão
            $table->timestamp('finished_at')->nullable();
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
        Schema::dropIfExists('crm_business_interactions');
    }
};
