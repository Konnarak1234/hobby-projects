<?php

namespace Database\Seeders;

use App\Models\Album;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // User::factory(10)->create();

        User::factory()->create();
        Album::create([
            'user_id' => 1,
            "title" => "Europe",
			"description" => "place we want to travel",
			"location" => "europe",
			"cover_image" => "albums/covers/D264YHHzLZ1FW8H7idwrFGeO2G1f62ESXPHCWU8R.jpg",
        ]);

    }
}
