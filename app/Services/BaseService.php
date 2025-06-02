<?php

namespace App\Services;

use App\Enums\DefaultStatusEnum;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Validation\ValidationException;

abstract class BaseService
{
    public function __construct()
    {
        //
    }

    protected function getErrorException(\Throwable $e): array
    {
        // Check the class of the exception to handle it appropriately
        $message = match (get_class($e)) {
            ValidationException::class => $e->errors(),
            default => $e->getMessage(),
        };

        return [
            'success' => false,
            'message' => $message,
        ];
    }

    public function tableSearchByStatus(
        Builder $query,
        string $search,
        string $enumClass = DefaultStatusEnum::class,
        string $columnName = 'status',
    ): Builder {
        if (!class_exists($enumClass) || !method_exists($enumClass, 'getAssociativeArray')) {
            return $query;
        }

        $statuses = $enumClass::getAssociativeArray();

        $matchingStatuses = [];
        foreach ($statuses as $index => $status) {
            if (stripos($status, $search) !== false) {
                $matchingStatuses[] = $index;
            }
        }

        if ($matchingStatuses) {
            return $query->whereIn($columnName, $matchingStatuses);
        }

        return $query;
    }

    public function tableSortByStatus(
        Builder $query,
        string $direction,
        string $enumClass = DefaultStatusEnum::class,
        string $columnName = 'status',
    ): Builder {
        if (!class_exists($enumClass) || !method_exists($enumClass, 'getAssociativeArray')) {
            return $query;
        }

        $statuses = $enumClass::getAssociativeArray();

        $caseParts = [];
        $bindings = [];

        foreach ($statuses as $key => $status) {
            $caseParts[] = "WHEN ? THEN ?";
            $bindings[] = $key;
            $bindings[] = $status;
        }

        $orderByCase = "CASE {$columnName} " . implode(' ', $caseParts) . " END";

        return $query->orderByRaw("$orderByCase $direction", $bindings);
    }

    public function tableFilterByCreatedAt(Builder $query, array $data): Builder
    {
        if (!$data['created_from'] && !$data['created_until']) {
            return $query;
        }

        return $query
            ->when(
                $data['created_from'],
                function (Builder $query, $date) use ($data) {
                    if (empty($data['created_until'])) {
                        return $query->whereDate('created_at', '=', $date);
                    }

                    return $query->whereDate('created_at', '>=', $date);
                }
            )
            ->when(
                $data['created_until'],
                fn(Builder $query, $date): Builder =>
                $query->whereDate('created_at', '<=', $date)
            );
    }

    public function tableFilterByUpdatedAt(Builder $query, array $data): Builder
    {
        if (!$data['updated_from'] && !$data['updated_until']) {
            return $query;
        }

        return $query
            ->when(
                $data['updated_from'],
                function (Builder $query, $date) use ($data) {
                    if (empty($data['updated_until'])) {
                        return $query->whereDate('updated_at', '=', $date);
                    }

                    return $query->whereDate('updated_at', '>=', $date);
                }
            )
            ->when(
                $data['updated_until'],
                fn(Builder $query, $date): Builder =>
                $query->whereDate('updated_at', '<=', $date),
            );
    }
}
