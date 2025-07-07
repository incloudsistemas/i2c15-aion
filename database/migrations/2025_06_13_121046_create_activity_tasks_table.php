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
        Schema::create('activity_tasks', function (Blueprint $table) {
            $table->id();
            // Auto relacionamento - Ref. atividade parental/pai
            $table->foreignId('task_id')->nullable()->default(null);
            $table->foreign('task_id')
                ->references('id')
                ->on('activity_tasks')
                ->onUpdate('cascade')
                ->onDelete('set null');
            // Tipo
            // 1 - 'Task/Tarefa', 2 - 'Meeting/Reunião'...
            $table->char('role', 1);
            // Dt. início
            $table->date('start_date');
            // Horário início
            $table->time('start_time');
            // Dt. fim
            $table->date('end_date')->nullable();
            // Horário fim
            $table->time('end_time')->nullable();
            // Repetir a cada  (Ocorrências)
            // 1 - 1x, 2 - 2x...
            $table->integer('repeat_occurrence')->default(1);
            // Repetição
            // 1- 'Diário', 2 - 'Semanal', 3 - 'Mensal', 4 - 'Bimestral', 5 - 'Trimestral', 6 - 'Semestral', 7 - 'Anual', 8 - 'Todos os dias da semana (Seg - Sex)'
            $table->char('repeat_frequency', 1)->nullable();
            // Index da repetição
            $table->integer('repeat_index')->default(1);
            // Local
            $table->string('location')->nullable();
            // Prioridade
            // 1 - Baixa, 2 - Média, 3 - Alta
            $table->char('priority', 1)->nullable();
            // Enviar lembrete
            // 0 - Nenhum lembrete, 1 - Na hora de vencimento da tarefa, 2 - 30 minutos antes, 3 - 1 hora antes
            // 4 - 1 dia antes, 5 - 1 semana antes, 6 - Data personalizada
            // Frequency / Custom Date
            $table->json('reminders')->nullable();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Schema::disableForeignKeyConstraints();
        Schema::dropIfExists('activity_tasks');
    }
};
