<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('brands', function (Blueprint $table) {
            $table->id();
            $table->string('name', 255)->unique();
            $table->timestamps();
        });

        Schema::create('cameras', function (Blueprint $table) {
            $table->id();
            $table->foreignId('brand_id')->constrained();
            $table->string('model', 255);
            $table->string('sensor_type', 100)->nullable();
            $table->integer('release_year')->nullable();
            $table->timestamps();
        });

        Schema::create('lenses', function (Blueprint $table) {
            $table->id();
            $table->foreignId('brand_id')->constrained();
            $table->string('model', 255);
            $table->string('mount', 100)->nullable();
            $table->string('focal_length', 100)->nullable();
            $table->string('aperture', 50)->nullable();
            $table->timestamps();
        });

        Schema::create('user_cameras', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('camera_id')->constrained();
            $table->text('usage_notes')->nullable();
            $table->timestamps();
        });

        Schema::create('user_lenses', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('lens_id')->constrained();
            $table->text('usage_notes')->nullable();
            $table->timestamps();
        });

        Schema::create('reviews', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->morphs('reviewable');
            $table->integer('rating')->checkBetween(1, 5);
            $table->text('content')->nullable();
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('reviews');
        Schema::dropIfExists('user_lenses');
        Schema::dropIfExists('user_cameras');
        Schema::dropIfExists('lenses');
        Schema::dropIfExists('cameras');
        Schema::dropIfExists('brands');
    }
};