<?php

namespace App\Services\Polymorphics\Activities;

use App\Models\Polymorphics\Activities\Activity;
use App\Services\BaseService;
use App\Services\Polymorphics\ActivityLogService;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Facades\Storage;

class ActivityService extends BaseService
{
    public function __construct(protected Activity $activity, protected ActivityLogService $logService)
    {
        parent::__construct();
    }

    public function getQueryByActivitable(Builder $query, string $model): Builder
    {
        return $query->with('activityable')
            ->whereHas('activityable')
            ->where('activityable_type', MorphMapByClass(model: $model));
    }

    protected function attachContacts(Activity $activity, ?array $contacts): void
    {
        if (!isset($contacts)) {
            return;
        }

        $activity->contacts()
            ->attach($contacts);
    }

    protected function attachUsers(Activity $activity, ?array $users): void
    {
        if (!isset($users)) {
            return;
        }

        $activity->users()
            ->attach($users);
    }

    protected function syncContacts(Activity $activity, ?array $contacts): void
    {
        if (!isset($contacts)) {
            return;
        }

        $activity->contacts()
            ->sync($contacts);
    }

    protected function syncUsers(Activity $activity, ?array $users): void
    {
        if (!isset($users)) {
            return;
        }

        $activity->users()
            ->sync($users);
    }

    protected function createAttachments(Activity $activity, ?array $attachments): void
    {
        if (!isset($attachments) || empty($attachments)) {
            return;
        }

        foreach ($attachments as $attachment) {
            $filePath = Storage::disk('public')
                ->path($attachment);

            $activity->addMedia($filePath)
                ->usingName(basename($attachment))
                ->toMediaCollection('attachments');
        }
    }
}
