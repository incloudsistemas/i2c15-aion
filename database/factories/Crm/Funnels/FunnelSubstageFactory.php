<?php

namespace Database\Factories\Crm\Funnels;

use App\Models\Crm\Funnels\FunnelStage;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Crm\Funnels\FunnelSubstage>
 */
class FunnelSubstageFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $stage = FunnelStage::inRandomOrder()->first() ?? FunnelStage::factory()->create();
        $name = $this->faker->word();

        return [
            'funnel_stage_id' => $stage->id,
            'name'            => $name,
            // 'slug'            => Str::slug($name),
            'description'     => $this->faker->optional()->sentence(),
            'order'           => $this->faker->numberBetween(1, 5),
        ];
    }
}
