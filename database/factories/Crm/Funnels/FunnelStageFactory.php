<?php

namespace Database\Factories\Crm\Funnels;

use App\Models\Crm\Funnels\Funnel;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Crm\Funnels\FunnelStage>
 */
class FunnelStageFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $funnel = Funnel::inRandomOrder()->first() ?? Funnel::factory()->create();
        $name = $this->faker->word();

        return [
            'funnel_id'           => $funnel->id,
            'name'                => $name,
            // 'slug'                => Str::slug($name),
            'description'         => $this->faker->optional()->sentence(),
            'business_probability'=> $this->faker->numberBetween(0, 100),
            'order'               => $this->faker->numberBetween(1, 5),
        ];
    }
}
