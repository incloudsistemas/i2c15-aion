<?php

namespace Database\Factories\Financial;

use App\Models\Financial\Category;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Financial\Category>
 */
class CategoryFactory extends Factory
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

    public function withParent()
    {
        return $this->state(function (array $attributes) {
            return [
                'category_id' => Category::inRandomOrder()
                    ->first()?->id,
            ];
        });
    }
}
