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
        // https://brasilapi.com.br/docs#tag/BANKS/paths/~1banks~1v1/get
        // php artisan app:sync-financial-bank-institutions
        Schema::create('financial_bank_institutions', function (Blueprint $table) {
            $table->id();
            // Código COMPE
            // Atribuído pelo Banco Central do Brasil (BACEN) e usado em transações financeiras, como TEDs, DOCs e PIX.
            $table->integer('code')->unique()->nullable();
            // Código ISPB
            $table->string('ispb')->unique()->nullable();
            // Nome
            $table->string('name');
            // Nome reduzido
            $table->string('short_name')->nullable();
            // Status
            // 0- Inativo, 1 - Ativo
            $table->char('status', 1)->default(1);
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('financial_bank_institutions');
    }
};
