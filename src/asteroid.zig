const std = @import("std");
const rl = @import("raylib");

const rlm = rl.math;
const math = std.math;

const Vector2 = rl.Vector2;
const Color = rl.Color;
const Key = rl.KeyboardKey;

pub const Asteroid = struct {
    position: Vector2,
    velocity: Vector2,
    rotation: f32,
    rotationSpeed: f32,
    size: f32,
    hitbox: f32,

    pub fn new() Asteroid {
        var position = Vector2.zero();

        if (rl.getRandomValue(0, 1) == 0) {
            position.y = -100;
            position.x = @floatFromInt(rl.getRandomValue(0, rl.getScreenWidth()));
        } else {
            position.y = @floatFromInt(100 + rl.getScreenHeight());
            position.x = @floatFromInt(rl.getRandomValue(0, rl.getScreenWidth()));
        }

        const speed: f32 = @floatFromInt(rl.getRandomValue(50, 150));
        const center = Vector2{
            .x = @floatFromInt(@divFloor(rl.getScreenWidth(), 2)),
            .y = @floatFromInt(@divFloor(rl.getScreenHeight(), 2)),
        };
        const tempVelocity = rlm.vector2Scale(
            rlm.vector2Normalize(rlm.vector2Subtract(center, position)),
            speed,
        );

        const size = 15 + std.crypto.random.float(f32) * (64 - 15);

        return Asteroid{
            .position = position,
            .velocity = rlm.vector2Rotate(tempVelocity, @floatFromInt(rl.getRandomValue(-30, 30))),
            .rotation = @mod(std.crypto.random.float(f32), 360),
            .rotationSpeed = 25 + std.crypto.random.float(f32) * 150,
            .size = size,
            .hitbox = size * 0.75,
        };
    }

    pub fn draw(self: *Asteroid) void {
        rl.drawPolyLines(self.position, 5, self.size, self.rotation, Color.white);
    }

    pub fn drawDebug(self: *Asteroid) void {
        rl.drawLineV(self.position, rlm.vector2Add(self.position, rlm.vector2Scale(self.velocity, 0.5)), Color.red);
        rl.drawCircleV(self.position, self.hitbox, Color.red);
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
