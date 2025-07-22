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
        Schema::create('financial_transactions', function (Blueprint $table) {
            $table->id();
            // Criador/Captador "id_owner"
            $table->foreignId('user_id');
            $table->foreign('user_id')
                ->references('id')
                ->on('users')
                ->onUpdate('cascade')
                ->onDelete('cascade');
            // Banco
            $table->foreignId('bank_account_id');
            $table->foreign('bank_account_id')
                ->references('id')
                ->on('financial_bank_accounts')
                ->onUpdate('cascade')
                ->onDelete('cascade');
            // Contato
            $table->foreignId('contact_id')->nullable()->default(null);
            $table->foreign('contact_id')
                ->references('id')
                ->on('crm_contacts')
                ->onUpdate('cascade')
                ->onDelete('set null');
            // Negócio
            $table->foreignId('business_id')->nullable()->default(null);
            $table->foreign('business_id')
                ->references('id')
                ->on('crm_business')
                ->onUpdate('cascade')
                ->onDelete('set null');
            // Auto relacionamento - Ref. transação parental/pai
            $table->foreignId('transaction_id')->nullable()->default(null);
            $table->foreign('transaction_id')
                ->references('id')
                ->on('financial_transactions')
                ->onUpdate('cascade')
                ->onDelete('restrict');
            // Tipo
            // 1 - 'Conta a pagar', 2 - 'Conta a receber', 3 - 'Transferência'.
            $table->char('role', 1);
            // Nome da transação
            $table->string('name');
            // Forma de pagamento
            // 1 - Dinheiro, 2 - Pix, 3 - Cheque, 4 - Transferência bancária, 5 - Cartão de débito, 6 - Cartão de crédito, 7 - Outros...
            $table->char('payment_method', 1)->nullable();
            // Condições de pagamento
            // Repetição
            // 1 - 'À vista', 2 - 'Parcelado', 3 - 'Recorrente'.
            $table->char('repeat_payment', 1)->default(1);
            // Ocorrências
            // 0 - À vista, 1 - 1x, 2 - 2x...
            $table->integer('repeat_occurrence');
            // 1- 'Diário', 2 - 'Semanal', 3 - 'Mensal', 4 - 'Bimestral', 5 - 'Trimestral', 6 - 'Semestral', 7 - 'Anual', 8 - 'Todos os dias da semana (Seg - Sex)'
            $table->char('repeat_frequency', 1)->nullable();
            // Index da repetição
            $table->integer('repeat_index')->default(1);
            // Preço/Valor da transação
            $table->bigInteger('price');
            // Juros (+)
            $table->bigInteger('interest')->nullable();
            // Multa (+)
            $table->bigInteger('fine')->nullable();
            // Desconto (-)
            $table->bigInteger('discount')->nullable();
            // Taxas/impostos (-)
            $table->bigInteger('taxes')->nullable();
            // Preço/Valor final da transação
            // (price + interest + fine) - (discount + taxes)
            $table->bigInteger('final_price');
            // Descrição/Observações da transação
            $table->string('complement')->nullable();
            // Dt. vencimento
            $table->timestamp('due_at')->nullable()->default(null);
            // Dt. pagamento
            $table->timestamp('paid_at')->nullable()->default(null);
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
        Schema::dropIfExists('financial_transactions');
    }
};
