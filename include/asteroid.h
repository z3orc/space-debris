#ifndef ASTEROID_H
#define ASTEROID_H

#include <raylib.h>

enum AsteroidSize
{
    SMALL,
    MEDIUM,
    LARGE,
};

typedef enum AsteroidSize AsteroidSize;

struct Asteroid
{
    Vector2 position;
    Vector2 velocity;
    float rotation;
    float rotation_speed;
    AsteroidSize size;
    bool active;
};

typedef struct Asteroid Asteroid;

Asteroid asteroid_create(Vector2 position, float speed);
void asteroid_draw(Asteroid *asteroid);
void asteroid_update(Asteroid *asteroid, float frame_time);

#endif