const std = @import("std");
const rl = @import("raylib");

const rlm = rl.math;
const Vector2 = rl.Vector2;
const math = std.math;
const color = rl.Color;

pub const Player = struct {
    position: Vector2,
    velocity: Vector2,
};

pub const Asteroid = struct {
    position: Vector2,
    velocity: Vector2,
    rotation: f32,
    rotationSpeed: f32,
    size: f32,

    pub fn create(posX: f32, posY: f32, speed: f32) Asteroid {
        const angle: f32 = std.crypto.random.float(f32) * 2 * math.pi;
        const direction: Vector2 = .{
            .x = math.cos(angle),
            .y = math.sin(angle),
        };

        return Asteroid{
            .position = .{ .x = posX, .y = posY },
            .velocity = rlm.vector2Scale(direction, speed),
            .rotation = @mod(std.crypto.random.float(f32), 360),
            .rotationSpeed = 25 + std.crypto.random.float(f32) * 150,
            .size = 15 + std.crypto.random.float(f32) * (64 - 15),
        };
    }

    pub fn draw(self: *Asteroid) void {
        rl.drawPolyLines(self.position, 5, self.size, self.rotation, color.white);
    }

    pub fn update(self: *Asteroid, dt: f32) void {
        const maxX: f32 = @floatFromInt(rl.getScreenWidth());
        const maxY: f32 = @floatFromInt(rl.getScreenHeight());
        const padding: f32 = self.size * 1.1;

        self.position = rlm.vector2Add(self.position, rlm.vector2Scale(self.velocity, dt));

        if (self.position.x < 0 - (padding)) {
            self.position.x = maxX + padding;
        }

        if (self.position.x > maxX + padding) {
            self.position.x = 0 - padding;
        }

        if (self.position.y < 0 - padding) {
            self.position.y = maxY + padding;
        }

        if (self.position.y > maxY + padding) {
            self.position.y = 0 - padding;
        }

        self.rotation += (self.rotationSpeed * dt);
    }
};
