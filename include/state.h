#ifndef STATE_H
#define STATE_H

#include <raylib.h>
#include "asteroid.h"

struct State
{
    Asteroid *asteroids;
    int asteroid_count;
};

typedef struct State State;

State init_state(int asteroid_count);
void delete_state(State *state);

#endif