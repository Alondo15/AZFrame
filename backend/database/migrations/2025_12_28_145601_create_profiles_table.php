<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('profiles', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->unique()->constrained()->cascadeOnDelete();
            $table->string('full_name', 255)->nullable();
            $table->text('bio')->nullable();
            $table->foreignId('avatar_media_id')->nullable()->constrained('media');
            $table->foreignId('cover_media_id')->nullable()->constrained('media');
            $table->string('location', 255)->nullable();
            $table->string('website', 255)->nullable();
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('profiles');
    }
};