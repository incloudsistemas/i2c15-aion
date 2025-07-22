<?php

namespace App\Filament\Resources\Financial;

use App\Enums\Financial\TransactionPaymentMethodEnum;
use App\Enums\Financial\TransactionRepeatFrequencyEnum;
use App\Enums\Financial\TransactionRepeatPaymentEnum;
use App\Filament\Resources\Financial\PayableTransactionResource\Pages;
use App\Filament\Resources\Financial\PayableTransactionResource\RelationManagers;
use App\Models\Financial\Transaction;
use App\Services\Crm\Contacts\ContactService;
use App\Services\Financial\BankAccountService;
use App\Services\Financial\CategoryService;
use App\Services\Financial\TransactionService;
use App\Services\Polymorphics\MediaService;
use Closure;
use Filament\Infolists;
use Filament\Infolists\Infolist;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Support;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\SoftDeletingScope;
use Livewire\Features\SupportFileUploads\TemporaryUploadedFile;
use Illuminate\Support\Str;
use Spatie\MediaLibrary\MediaCollections\Models\Media;

class PayableTransactionResource extends TransactionResource
{
    // protected static ?string $model = Transaction::class;

    public static ?int $role = 1; // Contas a pagar

    protected static ?string $recordTitleAttribute = 'name';

    protected static ?string $modelLabel = 'Conta a Pagar';

    protected static ?string $pluralModelLabel = 'Contas a Pagar';

    protected static ?string $navigationGroup = 'Financeiro';

    protected static ?int $navigationSort = 1;

    protected static ?string $navigationLabel = 'Contas a Pagar';

    protected static ?string $navigationIcon = 'heroicon-o-minus-circle';

    public static function getPages(): array
    {
        return [
            'index'  => Pages\ListPayableTransactions::route('/'),
            'create' => Pages\CreatePayableTransaction::route('/create'),
            // 'edit'   => Pages\EditPayableTransaction::route('/{record}/edit'),
        ];
    }

    public static function getEloquentQuery(): Builder
    {
        return parent::getEloquentQuery()
            ->byRoles(roles: [static::$role]);
    }
}
