<?php

namespace Database\Factories\Financial;

use App\Enums\DefaultStatusEnum;
use App\Enums\Financial\BankAccountRoleEnum;
use App\Enums\Financial\BankAccountTypePersonEnum;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Financial\BankAccount>
 */
class BankAccountFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'bank_institution_id' => null,
            'agency_id'           => null,
            'role'                => $this->faker->randomElement(BankAccountRoleEnum::class),
            'type_person'         => $this->faker->randomElement(BankAccountTypePersonEnum::class),
            'name'                => $this->faker->words(3, true) . ' Account',
            'is_main'             => false,
            'balance_date'        => now(),
            'balance'             => $this->faker->numberBetween(0, 1000000),
            'complement'          => $this->faker->sentence(),
            'status'              => DefaultStatusEnum::ACTIVE->value,
        ];
    }

    public function mainAccount(): static
    {
        return $this->state(fn(array $attributes): array => [
            'is_main' => true,
        ]);
    }

    public function inactive(): static
    {
        return $this->state(fn(array $attributes): array => [
            'status' => DefaultStatusEnum::INACTIVE->value,
        ]);
    }
}
