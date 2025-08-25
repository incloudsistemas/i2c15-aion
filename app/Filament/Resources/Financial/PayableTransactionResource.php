<?php

namespace App\Filament\Resources\Financial;

use App\Filament\Resources\Financial\PayableTransactionResource\Pages;
use App\Filament\Resources\Financial\PayableTransactionResource\RelationManagers;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

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
