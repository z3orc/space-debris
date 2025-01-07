const std = @import("std");
const builtin = @import("builtin");
const rl = @import("raylib");
const gui = @import("raygui");

const math = std.math;
const entity = @import("entity/entity.zig");
const playerState = entity.PlayerState;

const color = rl.Color;
const Vector2 = rl.Vector2;

const INFO_STRING = "SPACE DEBRIS DEV 0.1.0 " ++ builtin.target.osArchName() ++ " " ++ builtin.zig_version_string;
var showDebugInfo: bool = false;

var player: entity.Player = undefined;
var asteroids: [40]entity.Asteroid = undefined;
var activeAsteroids: usize = 0;

pub fn main() !void {
    rl.initWindow(1280, 720, "Space Debris");
    defer rl.closeWindow();
    rl.setTargetFPS(120);

    start();

    while (!rl.windowShouldClose()) {
        update(rl.getFrameTime());
        draw();
    }
}

pub fn start() void {
    player = entity.Player.new(
        @floatFromInt(@divFloor(rl.getScreenWidth(), 2)),
        @floatFromInt(@divFloor(rl.getScreenHeight(), 2)),
        color.red,
    );
    for (0..asteroids.len) |idx| {
        asteroids[idx] = entity.Asteroid.new();
        activeAsteroids += 1;
    }
}

pub fn update(dt: f32) void {
    if (player.state == playerState.Dead) {
        if (rl.isKeyPressed(rl.KeyboardKey.r)) {
            start();
        }
        return;
    }

    player.update(dt);

    for (&asteroids) |*asteroid| {
        asteroid.update(dt);

        if (player.position.distance(asteroid.position) < (player.size + asteroid.size) * 0.8) {
            player.state = playerState.Dead;
        }
    }
}

pub fn draw() void {
    rl.beginDrawing();
    defer rl.endDrawing();

    rl.clearBackground(color.black);

    if (showDebugInfo) {
        rl.drawFPS(10, 10);
        rl.drawText(INFO_STRING, 10, 40, 20, color.white);
    }

    _ = gui.guiCheckBox(
        rl.Rectangle{ .height = 20, .width = 20, .x = 5, .y = @floatFromInt(rl.getScreenHeight() - 25) },
        "Show debug info",
        &showDebugInfo,
    );

    if (player.state == playerState.Dead) {
        const gameoverMessage = "Gameover! Press 'R' to restart!";
        const gameoverFontSize = 30;
        rl.drawText(
            gameoverMessage,
            @divFloor(rl.getScreenWidth() - rl.measureText(gameoverMessage, gameoverFontSize), 2),
            @divFloor(rl.getScreenHeight(), 2),
            gameoverFontSize,
            color.white,
        );
        return;
    }

    player.draw();

    for (&asteroids) |*asteroid| {
        asteroid.draw();

        if (showDebugInfo) {
            asteroid.drawDebug();
        }
    }
}
