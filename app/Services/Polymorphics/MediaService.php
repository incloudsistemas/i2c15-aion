<?php

namespace App\Services\Polymorphics;

use App\Models\Crm\Business\Business;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use Spatie\MediaLibrary\MediaCollections\Models\Media;
use Illuminate\Support\Facades\Storage;

class MediaService extends BaseService
{
    public function __construct(protected Media $media)
    {
        parent::__construct();
    }

    public function getQueryByAttachments(Builder $query): Builder
    {
        return $query->where('collection_name', 'attachments')
            ->orderBy('order_column', 'asc');
    }

    public function mutateFormDataToCreate(Model $ownerRecord, array $data): array
    {
        $data['model_type'] = MorphMapByClass(model: $ownerRecord::class);
        $data['model_id'] = $ownerRecord->id;

        return $data;
    }

    public function createAction(array $data, Model $ownerRecord): Model
    {
        return DB::transaction(function () use ($data, $ownerRecord): Model {
            foreach ($data['attachments'] as $attachment) {
                $filePath = Storage::disk('public')
                    ->path($attachment);

                $ownerRecord->addMedia($filePath)
                    ->usingName($data['name'] ?? basename($attachment))
                    ->toMediaCollection($data['collection_name'] ?? 'attachments');
            }

            $sentence = count($data['attachments']) . ' arquivo(s), ' . $data['name'];

            if ($ownerRecord instanceof Business) {
                $this->logBusinessSystemInteractions(
                    business: $ownerRecord,
                    description: $this->getSystemInteractionDescription(sentence: $sentence, action: 'cadastrado(s)'),
                    currentData: [
                        'name' => $data['name']
                    ]
                );
            }

            return $ownerRecord;
        });
    }

    public function beforeEditAction(Model $ownerRecord, Media $media, array $data): void
    {
        if ($ownerRecord instanceof Business) {
            $this->logBusinessSystemInteractions(
                business: $ownerRecord,
                description: $this->getSystemInteractionDescription(sentence: $data['name'], action: 'editado'),
                currentData: [
                    'name' => $data['name']
                ],
                oldData: [
                    'name' => $media->name
                ],
            );
        }
    }

    public function beforeDeleteAction(Model $ownerRecord, Media $media): void
    {
        if ($ownerRecord instanceof Business) {
            $this->logBusinessSystemInteractions(
                business: $ownerRecord,
                description: $this->getSystemInteractionDescription(sentence: $media->name, action: 'deletado(s)'),
                currentData: [
                    'name' => $media->name
                ],
            );
        }
    }

    public function beforeDeleteBulkAction(Model $ownerRecord, Collection $records): void
    {
        $description = $records->count() . ' arquivo(s)';

        $names = $records->pluck('name')
            ->implode(', ');

        if ($ownerRecord instanceof Business) {
            $this->logBusinessSystemInteractions(
                business: $ownerRecord,
                description: $this->getSystemInteractionDescription(sentence: $description, action: 'deletado(s) em volume'),
                currentData: [
                    'name' => $names
                ],
            );
        }
    }

    protected function getSystemInteractionDescription(string $sentence, string $action): string
    {
        $userName = auth()->user()->name;

        return "Anexo: {$sentence}, {$action} por: {$userName}";
    }

    protected function logBusinessSystemInteractions(
        Business $business,
        string $description,
        ?array $currentData = null,
        ?array $oldData = null
    ): void {
        if ($currentData) {
            $interactionData['current_data'] = $currentData;
        }

        if ($oldData) {
            $interactionData['old_data'] = $oldData;
        }

        $business->systemInteractions()
            ->create([
                'user_id'     => auth()->id(),
                'description' => $description,
                'data'        => $interactionData,
            ]);

        $business->updated_at = now();
        $business->save();
    }
}
