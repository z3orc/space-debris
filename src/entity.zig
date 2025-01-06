const std = @import("std");
const rl = @import("raylib");

const rlm = rl.math;
const math = std.math;

const Vector2 = rl.Vector2;
const Color = rl.Color;
const Key = rl.KeyboardKey;

const PLAYER_ROTATION_SPEED: f32 = 300;
const PLAYER_ACCELERATION: f32 = 5;
const PLAYER_MAX_SPEED: f32 = 350;
const PLAYER_DRAG: f32 = 0.3;

pub const Player = struct {
    position: Vector2,
    velocity: Vector2,
    rotation: f32,
    color: Color,

    pub fn new(posX: f32, posY: f32, color: Color) Player {
        return Player{
            .position = rl.Vector2.init(posX, posY),
            .velocity = rl.Vector2.zero(),
            .rotation = 0,
            .color = color,
        };
    }

    pub fn update(self: *Player, dt: f32) void {
        self.updatePosition(dt);
        self.updateRotation(dt);
    }

    fn updatePosition(self: *Player, dt: f32) void {
        const rotationRadians = self.rotation * @divTrunc(math.pi, 180);
        const direction = Vector2.init(math.cos(rotationRadians), math.sin(rotationRadians));

        if (rl.isKeyDown(Key.w)) {
            self.velocity = self.velocity.add(
                direction.scale(PLAYER_ACCELERATION),
            );

            self.velocity = self.velocity.clampValue(-PLAYER_MAX_SPEED, PLAYER_MAX_SPEED);
        } else if (rl.isKeyDown(Key.s)) {
            self.velocity = self.velocity.subtract(
                direction.scale(PLAYER_ACCELERATION),
            );

            self.velocity = self.velocity.clampValue(-PLAYER_MAX_SPEED, PLAYER_MAX_SPEED);
        }

        self.velocity = self.velocity.scale(math.pow(f32, PLAYER_DRAG, dt));

        self.position = self.position.add(self.velocity.scale(dt));
    }

    fn updateRotation(self: *Player, dt: f32) void {
        if (rl.isKeyDown(Key.a)) {
            self.rotation -= PLAYER_ROTATION_SPEED * dt;
        }

        if (rl.isKeyDown(Key.d)) {
            self.rotation += PLAYER_ROTATION_SPEED * dt;
        }

        self.rotation = @mod(self.rotation, 360);
    }

    pub fn draw(self: *Player) void {
        rl.drawPolyLines(self.position, 3, 16, self.rotation, Color.red);
    }
};

pub const Asteroid = struct {
    position: Vector2,
    velocity: Vector2,
    rotation: f32,
    rotationSpeed: f32,
    size: f32,

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

        return Asteroid{
            .position = position,
            .velocity = rlm.vector2Rotate(tempVelocity, @floatFromInt(rl.getRandomValue(-30, 30))),
            .rotation = @mod(std.crypto.random.float(f32), 360),
            .rotationSpeed = 25 + std.crypto.random.float(f32) * 150,
            .size = 15 + std.crypto.random.float(f32) * (64 - 15),
        };
    }

    pub fn draw(self: *Asteroid) void {
        rl.drawPolyLines(self.position, 5, self.size, self.rotation, Color.white);
        rl.drawLineV(self.position, rlm.vector2Add(self.position, rlm.vector2Scale(self.velocity, 0.5)), Color.red);
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
