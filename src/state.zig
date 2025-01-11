const std = @import("std");
const rl = @import("raylib");

const Player = @import("player.zig").Player;
const Asteroid = @import("asteroid.zig").Asteroid;

pub const State = struct {
    player: Player,
    asteroids: std.ArrayList(Asteroid),
    asteroidQueue: std.ArrayList(Asteroid),
    activeAsteroids: usize,
    maxActiveAsteroids: usize,
    deathSound: rl.Sound,
    debug: bool = false,
    gameActive: bool,
    gameEndTime: f64,

    pub fn deinit(self: *State) void {
        self.asteroids.deinit();
        self.asteroidQueue.deinit();
    }
};
