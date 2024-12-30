#include "asteroid.h"
#include <stdio.h>
#include <stdlib.h>
#include <raylib.h>
#include <raymath.h>

Asteroid asteroid_create(Vector2 position, float speed)
{
    float angle = DEG2RAD * (rand() % 360);
    Vector2 direction = {cos(angle), sin(angle)};

    Asteroid asteroid = {
        .position = position,
        .velocity = Vector2Scale(direction, speed),
        .rotation = (rand() % 360),
        .rotation_speed = (rand() % 100),
        .size = GetRandomValue(1, 3),
    };

    return asteroid;
}

void asteroid_draw(Asteroid *asteroid)
{
    DrawPolyLines(asteroid->position, 3, 64 * asteroid->size, asteroid->rotation, WHITE);
}

void asteroid_update(Asteroid *asteroid, float frametime)
{
    // asteroid->position.x += asteroid->velocity.x * frametime;
    // asteroid->position.y += asteroid->velocity.y * frametime;

    asteroid->position = Vector2Add(
        asteroid->position,
        Vector2Scale(asteroid->velocity, frametime));

    asteroid->rotation += asteroid->rotation_speed * frametime;
}