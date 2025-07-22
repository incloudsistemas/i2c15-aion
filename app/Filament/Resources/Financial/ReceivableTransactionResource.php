<?php

namespace App\Filament\Resources\Financial;

use App\Filament\Resources\Financial\ReceivableTransactionResource\Pages;
use App\Filament\Resources\Financial\ReceivableTransactionResource\RelationManagers;
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

class ReceivableTransactionResource extends TransactionResource
{
    // protected static ?string $model = Transaction::class;

    public static ?int $role = 2; // Contas a receber

    protected static ?string $recordTitleAttribute = 'name';

    protected static ?string $modelLabel = 'Conta a Receber';

    protected static ?string $pluralModelLabel = 'Contas a Receber';

    protected static ?string $navigationGroup = 'Financeiro';

    protected static ?int $navigationSort = 2;

    protected static ?string $navigationLabel = 'Contas a Receber';

    protected static ?string $navigationIcon = 'heroicon-o-plus-circle';

    public static function getPages(): array
    {
        return [
            'index'  => Pages\ListReceivableTransactions::route('/'),
            'create' => Pages\CreateReceivableTransaction::route('/create'),
            // 'edit'   => Pages\EditReceivableTransaction::route('/{record}/edit'),
        ];
    }

    public static function getEloquentQuery(): Builder
    {
        return parent::getEloquentQuery()
            ->byRoles(roles: [static::$role]);
    }
}
