const std = @import("std");
const rl = @import("raylib");

const Player = @import("player.zig").Player;
const Asteroid = @import("asteroid.zig").Asteroid;

pub const StateConfig = struct {
    allocator: std.mem.Allocator,
    player: Player,
    maxAsteroids: usize,
    deathSound: rl.Sound,
    pointSound: rl.Sound,
};

pub const State = struct {
    player: Player,
    asteroids: std.ArrayList(Asteroid),
    asteroidQueue: std.ArrayList(Asteroid),
    activeAsteroids: usize,
    maxActiveAsteroids: usize,
    deathSound: rl.Sound,
    pointSound: rl.Sound,
    debug: bool = false,
    points: i16 = 0,
    lastPointTime: f64 = 0, //Time since last point in seconds
    gameActive: bool = false,
    gameEndTime: f64 = 0,

    pub fn init(config: StateConfig) !State {
        var state: State = .{
            .player = config.player,
            .asteroids = std.ArrayList(Asteroid).init(config.allocator),
            .asteroidQueue = std.ArrayList(Asteroid).init(config.allocator),
            .activeAsteroids = 0,
            .maxActiveAsteroids = config.maxAsteroids,
            .deathSound = config.deathSound,
            .pointSound = config.pointSound,
            .gameActive = true,
        };

        for (0..state.maxActiveAsteroids) |_| {
            try state.asteroids.append(Asteroid.new());
            state.activeAsteroids += 1;
        }

        return state;
    }

    pub fn deinit(self: *State) void {
        self.asteroids.deinit();
        self.asteroidQueue.deinit();
    }
};
