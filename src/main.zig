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
var playerDeathTime: f64 = undefined;

var asteroids: [40]entity.Asteroid = undefined;
var activeAsteroids: usize = 0;

var deathSoundBytes = @embedFile("./assets/player_death.wav");
var deathSound: rl.Sound = undefined;

pub fn main() !void {
    rl.initWindow(1280, 720, "Space Debris");
    defer rl.closeWindow();

    rl.initAudioDevice();
    defer rl.closeAudioDevice();

    deathSound = rl.loadSoundFromWave(rl.loadWaveFromMemory(".wav", deathSoundBytes));
    defer rl.unloadSound(deathSound);

    while (!rl.isWindowReady() and !rl.isAudioDeviceReady()) {}
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
    }

    player.update(dt);

    for (&asteroids) |*asteroid| {
        asteroid.update(dt);

        if (player.state == playerState.Alive and
            player.position.distance(asteroid.position) < (player.size + asteroid.size) * 0.6)
        {
            player.state = playerState.Dead;
            playerDeathTime = rl.getTime();
            rl.playSound(deathSound);
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

    //Player dead, and dead for more then 3 secods
    if (player.state == playerState.Dead and (playerDeathTime + 1) < rl.getTime()) {
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
    } else if (player.state == playerState.Dead) {
        for (&asteroids) |*asteroid| {
            asteroid.draw();

            if (showDebugInfo) {
                asteroid.drawDebug();
            }
        }

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
