<?php

namespace App\Console\Commands;

use App\Models\Financial\BankInstitution;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Http;

class SyncFinancialBankInstitutions extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:sync-financial-bank-institutions';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Synchronize bank institutions with BrasilAPI';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $response = Http::get('https://brasilapi.com.br/api/banks/v1');

        if ($response->failed()) {
            $this->error('Falha ao acessar a API');
            return;
        }

        $apiBanks = $response->json();
        $apiCodes = collect($apiBanks)
            ->pluck('code')
            ->toArray();

        // Update or create API banks
        foreach ($apiBanks as $bank) {
            if (empty($bank['code']) && empty($bank['ispb'])) {
                continue;
            }

            BankInstitution::updateOrCreate(
                ['code' => $bank['code']],
                [
                    'ispb'       => $bank['ispb'] ?? null,
                    'name'       => $bank['fullName'] ?? null,
                    'short_name' => $bank['name'] ?? null,
                ]
            );
        }

        // Remove banks that are no longer in the API
        $deletedCount = BankInstitution::whereNotIn('code', $apiCodes)
            ->delete();

        $this->info(sprintf(
            'Sincronização completa! %d bancos atualizados, %d removidos.',
            count($apiBanks),
            $deletedCount
        ));
    }
}
