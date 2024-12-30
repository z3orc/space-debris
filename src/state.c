#include "state.h"
#include <stdlib.h>
#include <stdio.h>

#include "asteroid.h"

// Create new game state using malloc. Exit if malloc failed.
State init_state(int asteroid_count)
{
    printf("Creating new state with %d asteroids\n", asteroid_count);

    State state = {
        .asteroids = malloc(sizeof(Asteroid) * asteroid_count),
        .asteroid_count = asteroid_count,
    };

    if (state.asteroids == NULL)
    {
        perror("Error while allocating memory for asteroid array");
        exit(1);
    }

    return state;
}

// Removes game state by freeing allocated memory for asteroids.
// Sets pointer to NULL
void delete_state(State *state)
{
    free(state->asteroids);
    state->asteroids = NULL;
}