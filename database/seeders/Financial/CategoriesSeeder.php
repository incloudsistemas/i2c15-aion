<?php

namespace Database\Seeders\Financial;

use App\Models\Financial\Category;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class CategoriesSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $this->truncateTable();

        // Create main categories
        $mainCategories = [
            [
                'name'  => 'Receitas',
                'order' => 1
            ],
            [
                'name'  => 'Despesas',
                'order' => 2
            ],
        ];

        foreach ($mainCategories as $category) {
            Category::create($category);
        }

        // Create subcategories for Recipes
        $incomeSubcategories = [
            [
                'name'  => 'Salário',
                'order' => 1
            ],
            [
                'name'  => 'Freelance',
                'order' => 2
            ],
            [
                'name'  => 'Investimentos',
                'order' => 3
            ],
            [
                'name'  => 'Vendas',
                'order' => 4
            ],
        ];

        $parentIncome = Category::where('slug', 'receitas')
            ->first();

        foreach ($incomeSubcategories as $subcategory) {
            Category::create([
                ...$subcategory,
                'category_id' => $parentIncome->id,
            ]);
        }

        // Create subcategories for Expenses
        $expenseSubcategories = [
            [
                'name'  => 'Alimentação',
                'order' => 1
            ],
            [
                'name'  => 'Moradia',
                'order' => 2
            ],
            [
                'name'  => 'Transporte',
                'order' => 3
            ],
            [
                'name'  => 'Lazer',
                'order' => 4
            ],
            [
                'name'  => 'Saúde',
                'order' => 5
            ],
        ];

        $parentExpense = Category::where('slug', 'despesas')
            ->first();

        foreach ($expenseSubcategories as $subcategory) {
            Category::create([
                ...$subcategory,
                'category_id' => $parentExpense->id,
            ]);
        }

        // Create drawn categories for testing
        Category::factory(10)
            ->create();

        // Create drawn subcategories for testing
        Category::factory(15)
            ->withParent()
            ->create();
    }

    protected function truncateTable()
    {
        $this->command->info('Truncating Financial Categories table');
        Schema::disableForeignKeyConstraints();

        DB::table('financial_categories')->truncate();

        Schema::enableForeignKeyConstraints();
    }
}
