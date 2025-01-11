const std = @import("std");
const rl = @import("raylib");

const Asteroid = @import("asteroid.zig").Asteroid;

const math = std.math;

const Vector2 = rl.Vector2;
const Color = rl.Color;
const Key = rl.KeyboardKey;

const PLAYER_ROTATION_SPEED: f32 = 300;
const PLAYER_ACCELERATION: f32 = 600;
const PLAYER_MAX_SPEED: f32 = 450;
const PLAYER_DRAG: f32 = 0.3;

const PlayerStatus = enum {
    alive,
    dead,
};

pub const Player = struct {
    position: Vector2,
    velocity: Vector2,
    rotation: f32,
    size: f32,
    hitbox: f32,
    color: Color,
    status: PlayerStatus,

    pub fn new(posX: f32, posY: f32, color: Color) Player {
        return Player{
            .position = rl.Vector2.init(posX, posY),
            .velocity = rl.Vector2.zero(),
            .size = 20,
            .hitbox = 20 * 0.6,
            .rotation = 0,
            .color = color,
            .status = .alive,
        };
    }

    pub fn update(self: *Player, dt: f32) void {
        if (self.status == .dead) {
            return;
        }

        self.updatePosition(dt);
        self.updateRotation(dt);
    }

    fn updatePosition(self: *Player, dt: f32) void {
        const rotationRadians = self.rotation * (math.pi / 180.0);
        const direction = Vector2.init(math.cos(rotationRadians), math.sin(rotationRadians));

        if (rl.isKeyDown(Key.w)) {
            self.velocity = self.velocity
                .add(direction.scale(PLAYER_ACCELERATION * dt))
                .clampValue(-PLAYER_MAX_SPEED, PLAYER_MAX_SPEED);
        } else if (rl.isKeyDown(Key.s)) {
            self.velocity = self.velocity
                .subtract(direction.scale(PLAYER_ACCELERATION * dt))
                .clampValue(-PLAYER_MAX_SPEED, PLAYER_MAX_SPEED);
        }

        self.velocity = self.velocity.scale(math.pow(f32, PLAYER_DRAG, dt));

        //Clamps the position to the screen size.
        const maxX: f32 = @floatFromInt(rl.getScreenWidth());
        const maxY: f32 = @floatFromInt(rl.getScreenHeight());
        self.position = self.position
            .add(self.velocity.scale(dt))
            .clamp(Vector2.zero(), Vector2.init(maxX, maxY));
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
        rl.drawPolyLines(self.position, 3, self.size, self.rotation, Color.red);
    }

    pub fn drawDebug(self: *Player) void {
        rl.drawCircle(
            @intFromFloat(self.position.x),
            @intFromFloat(self.position.y),
            self.hitbox,
            Color.red,
        );
    }

    pub fn isAlive(self: *Player) bool {
        return self.status == .alive;
    }

    pub fn checkCollision(self: *Player, asteroid: Asteroid) bool {
        const distance = self.position.distance(asteroid.position);
        return (distance < (self.hitbox + asteroid.hitbox));
    }
};
