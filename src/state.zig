const std = @import("std");
const rl = @import("raylib");

const entity = @import("entity/entity.zig");

pub const State = struct {
    player: entity.Player,
    asteroids: std.ArrayList(entity.Asteroid),
    asteroidQueue: std.ArrayList(entity.Asteroid),
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
