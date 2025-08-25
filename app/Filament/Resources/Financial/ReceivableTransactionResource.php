<?php

namespace App\Filament\Resources\Financial;

use App\Filament\Resources\Financial\ReceivableTransactionResource\Pages;
use App\Filament\Resources\Financial\ReceivableTransactionResource\RelationManagers;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

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
