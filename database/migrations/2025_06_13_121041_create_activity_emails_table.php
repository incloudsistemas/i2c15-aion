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
        Schema::create('activity_emails', function (Blueprint $table) {
            $table->id();
            // // Atividade
            // $table->foreignId('activity_id');
            // $table->foreign('activity_id')
            //     ->references('id')
            //     ->on('activities')
            //     ->onUpdate('cascade')
            //     ->onDelete('cascade');
            // Remetente
            $table->string('sender_mail')->nullable();
            // Destinatário(s)
            $table->json('recipient_mails')->nullable();
            // Status
            // 0 - Falhou, 1 - Pendente, 2 - Enviado
            $table->char('status', 1)->default(1);
            // Dt. de envio
            $table->timestamp('send_at')->nullable();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Schema::disableForeignKeyConstraints();
        Schema::dropIfExists('activity_emails');
    }
};
