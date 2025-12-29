<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('events', function (Blueprint $table) {
            $table->id();
            $table->foreignId('creator_id')->constrained('users')->cascadeOnDelete();
            $table->string('title', 255);
            $table->text('description')->nullable();
            $table->string('location', 255)->nullable();
            $table->timestamp('start_at');
            $table->timestamp('end_at');
            $table->enum('type', ['event', 'open_photoshoot']);
            $table->enum('visibility', ['public', 'followers', 'invite'])->default('public');
            $table->timestamps();
        });

        Schema::create('event_participants', function (Blueprint $table) {
            $table->foreignId('event_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->enum('status', ['interested', 'going', 'declined'])->default('interested');
            
            $table->primary(['event_id', 'user_id']);
        });
    }

    public function down()
    {
        Schema::dropIfExists('event_participants');
        Schema::dropIfExists('events');
    }
};