<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('posts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->text('content')->nullable();
            $table->enum('visibility', ['public', 'followers', 'private'])->default('public');
            $table->timestamps();
            $table->softDeletes();
        });

        Schema::create('post_media', function (Blueprint $table) {
            $table->foreignId('post_id')->constrained()->cascadeOnDelete();
            $table->foreignId('media_id')->constrained()->cascadeOnDelete();
            
            $table->primary(['post_id', 'media_id']);
        });
    }

    public function down()
    {
        Schema::dropIfExists('post_media');
        Schema::dropIfExists('posts');
    }
};