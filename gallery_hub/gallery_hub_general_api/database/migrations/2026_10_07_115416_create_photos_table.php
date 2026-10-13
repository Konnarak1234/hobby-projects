<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('photos', function (Blueprint $table) {
            $table->id();

            $table->uuid('uuid')->unique();

            $table->foreignId('album_id')
                ->constrained()
                ->cascadeOnDelete();

            // Photo information
            $table->string('title')->nullable();
            $table->text('description')->nullable();

            // File storage information
            $table->string('file_path');
            $table->string('original_name');
            $table->string('mime_type', 100);
            $table->unsignedBigInteger('file_size');

            // Optional image dimensions
            $table->unsignedInteger('width')->nullable();
            $table->unsignedInteger('height')->nullable();

            $table->timestamps();

            // Optimize queries that retrieve album photos
            $table->index(['album_id', 'created_at']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('photos');
    }
};
