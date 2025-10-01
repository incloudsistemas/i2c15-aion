<?php

namespace App\Filament\Resources\Cms\TestimonialResource\Pages;

use App\Filament\Resources\Cms\TestimonialResource;
use App\Models\Cms\Testimonial;
use App\Services\Cms\TestimonialService;
use Filament\Actions;
use Filament\Resources\Pages\ManageRecords;

class ManageTestimonials extends ManageRecords
{
    protected static string $resource = TestimonialResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make()
                ->after(
                    fn(TestimonialService $service, Testimonial $record, array $data) =>
                    $service->afterCreateAction(testimonial: $record, data: $data)
                ),
        ];
    }
}
