<?php

namespace Database\Factories\Crm\Business;

use App\Enums\Crm\Business\LossReasonEnum;
use App\Models\Crm\Business\Business;
use App\Models\Crm\Business\FunnelStage as BusinessFunnelStage;
use App\Models\Crm\Contacts\Contact;
use App\Models\Crm\Funnels\Funnel;
use App\Models\Crm\Funnels\FunnelStage;
use App\Models\Crm\Funnels\FunnelSubstage;
use App\Models\Crm\Source;
use App\Models\System\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Crm\Business\Business>
 */
class BusinessFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $user = User::inRandomOrder()->first() ?? User::factory()->create();

        $contact = $user->contacts()->inRandomOrder()->first()
            ?? Contact::inRandomOrder()->first()
            ?? Contact::factory()->create();

        $funnel = Funnel::inRandomOrder()->first() ?? Funnel::factory()->create();

        $stage = FunnelStage::where('funnel_id', $funnel->id)->inRandomOrder()->first()
            ?? FunnelStage::factory()->create(['funnel_id' => $funnel->id]);

        $substage = FunnelSubstage::where('funnel_stage_id', $stage->id)->inRandomOrder()->first();

        $source = Source::inRandomOrder()->value('id');

        // first pick price and percentage…
        $price = $this->faker->numberBetween(1000, 1000000);
        $percentage = $this->faker->numberBetween(0, 100);
        // …then compute the commission value
        $commissionPrice = (int) round($price * ($percentage / 100));

        return [
            'user_id'               => $user->id,
            'contact_id'            => $contact->id,
            'funnel_id'             => $funnel->id,
            'funnel_stage_id'       => $stage->id,
            'funnel_substage_id'    => $substage?->id,
            'source_id'             => $source,
            'name'                  => $this->faker->words(3, true),
            'description'           => $this->faker->optional()->sentence(),
            'price'                 => $price,
            'commission_percentage' => $percentage,
            'commission_price'      => $commissionPrice,
            'priority'              => $this->faker->numberBetween(1, 3),
            'order'                 => $this->faker->numberBetween(1, 5),
            'business_at'           => $this->faker->dateTimeBetween('-1 year', 'now')->format('d/m/Y H:i:s'),
        ];
    }

    /**
     * After creating a Business, automatically:
     * - Associate to Funnel, Stage and Substage (BusinessFunnelStage)
     * - Associate one existing User
     * - Create business activity
     */
    public function configure()
    {
        return $this->afterCreating(
            function (Business $business): void {
                // Create Business Funnel Stage
                $lossReason = null;
                if ($business->stage->business_probability === 0) {
                    $values = LossReasonEnum::getValues();
                    $key = array_rand($values);
                    $lossReason = $values[$key];
                }

                $business->businessFunnelStages()
                    ->create([
                        'funnel_id'          => $business->funnel_id,
                        'funnel_stage_id'    => $business->funnel_stage_id,
                        'funnel_substage_id' => $business->funnel_substage_id,
                        'loss_reason'        => $lossReason,
                        'business_at'        => ConvertEnToPtBrDateTime(date: $business->business_at),
                    ]);

                // Attach one existing User to the Business
                $business->users()
                    ->attach($business->user_id);

                // Create business activity
                $superadm = User::find(1); // 1 - Superadmin
                $superadmId = $superadm->id;
                $superadmName = $superadm->name;

                $descriptions = [];

                $baseDesc = "Novo negócio criado por: {$superadmName} ⇒ {$business->current_funnel->name} / Etapa: {$business->current_stage->name}";

                if ($business->current_substage) {
                    $baseDesc .= " / Sub-etapa: {$business->current_substage->name}";
                }

                $descriptions[] = $baseDesc;

                if ($superadmId !== $business->current_user->id) {
                    $usrName = $business->current_user->name;
                    $descriptions[] = "Novo negócio atribuído à {$usrName} por: {$superadmName}";
                }

                foreach ($descriptions as $description) {
                    $businessActivity = $business->activities()
                        ->create();

                    $businessActivity->activity()
                        ->create([
                            'user_id'     => $superadmId,
                            'description' => $description,
                        ]);
                }
            }
        );
    }
}
