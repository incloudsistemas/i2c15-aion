<?php

namespace Database\Seeders\Cms;

use App\Models\Cms\PostCategory;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class PostCategoriesSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Create drawn categories for testing
        PostCategory::factory(10)
            ->create();
    }
}
