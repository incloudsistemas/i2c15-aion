<?php

namespace Database\Factories\Crm\Funnels;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Crm\Funnels\Funnel>
 */
class FunnelFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $name = $this->faker->word();

        return [
            'name'        => $name,
            // 'slug'        => Str::slug($name),
            'description' => $this->faker->optional()->sentence(),
            'order'       => $this->faker->numberBetween(1, 5),
            'status'      => $this->faker->boolean,
        ];
    }
}
