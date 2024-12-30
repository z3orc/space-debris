#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <raylib.h>

#include "asteroid.h"
#include "state.h"

#define TITLE "RAYLIB in C"
#define WIDTH 1280
#define HEIGHT 720
#define TARGET_FPS 60

static State state;

void draw(void);
void update(void);

int main(void)
{
    InitWindow(WIDTH, HEIGHT, TITLE);
    SetTargetFPS(120);

    // Init game state. Both asteroids and player
    state = init_state(32);
    srand(time(NULL));

    for (int i = 0; i < state.asteroid_count; i++)
    {
        state.asteroids[i] = asteroid_create(
            (Vector2){GetRandomValue(0, 1000), GetRandomValue(0, 600)},
            GetRandomValue(100, 250));
        // printf("x=%f\n", state.asteroids[i].velocity.x);
    }
    while (!WindowShouldClose())
    {
        update();
        draw();
    }

    delete_state(&state);
    CloseWindow();
    return 0;
}

void draw(void)
{
    BeginDrawing();

    ClearBackground(BLACK);
    DrawFPS(10, 10);

    for (int i = 0; i < state.asteroid_count; i++)
    {
        asteroid_draw(&state.asteroids[i]);
    }

    EndDrawing();
}

void update(void)
{
    for (int i = 0; i < state.asteroid_count; i++)
    {
        asteroid_update(&state.asteroids[i], GetFrameTime());
    }
}