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
        Schema::create('activity_notes', function (Blueprint $table) {
            $table->id();
            // Tipo
            // 1 - 'Note//Observação', 2 - 'Call/Ligação'...
            $table->char('role', 1);
            // Dt. registro
            $table->timestamp('register_at')->nullable();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Schema::disableForeignKeyConstraints();
        Schema::dropIfExists('activity_notes');
    }
};
