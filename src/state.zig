const std = @import("std");
const entity = @import("entity/entity.zig");

pub const State = struct {
    player: entity.Player,
    asteroids: []entity.Asteroid,
    asteroidQueue: std.DoublyLinkedList(entity.Asteroid),

    pub fn init() State {
        return .{
            .player = undefined,
            .asteroids = undefined,
            .asteroidQueue = undefined,
        };
    }
};
