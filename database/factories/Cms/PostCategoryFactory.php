<?php

namespace Database\Factories\Cms;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Cms\PostCategory>
 */
class PostCategoryFactory extends Factory
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
            'name'   => $name,
            // 'slug'   => Str::slug($name),
            'order'  => $this->faker->numberBetween(1, 5),
            'status' => $this->faker->boolean,
        ];
    }
}
