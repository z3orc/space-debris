const std = @import("std");
const builtin = @import("builtin");
const rl = @import("raylib");
const gui = @import("raygui");

const math = std.math;
const State = @import("state.zig").State;
const Player = @import("player.zig").Player;
const Asteroid = @import("asteroid.zig").Asteroid;

const color = rl.Color;
const Vector2 = rl.Vector2;

const INFO_STRING = "SPACE DEBRIS DEV 0.1.0 " ++ builtin.target.osArchName() ++ " " ++ builtin.zig_version_string;

var state: State = undefined;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer std.debug.assert(gpa.deinit() == .ok);

    rl.initWindow(1280, 720, "Space Debris");
    defer rl.closeWindow();
    rl.setTargetFPS(120);

    rl.initAudioDevice();
    defer rl.closeAudioDevice();

    try initState(allocator);
    defer state.deinit();

    while (!rl.windowShouldClose()) {
        try update(rl.getFrameTime());
        draw();
    }
}

fn initState(allocator: std.mem.Allocator) !void {
    state.player = Player.new(
        @floatFromInt(@divFloor(rl.getScreenWidth(), 2)),
        @floatFromInt(@divFloor(rl.getScreenHeight(), 2)),
        color.red,
    );

    state.maxActiveAsteroids = 32;
    // state.asteroidQueue = std.ArrayList(entity.Asteroid).init(allocator);
    state.asteroids = std.ArrayList(Asteroid).init(allocator);
    while (state.activeAsteroids < state.maxActiveAsteroids) {
        try state.asteroids.append(Asteroid.new());
        state.activeAsteroids += 1;
    }

    state.deathSound = rl.loadSoundFromWave(rl.loadWaveFromMemory(
        ".wav",
        @embedFile("./assets/player_death.wav"),
    ));

    state.gameActive = true;
}

fn resetState() !void {
    state.player = Player.new(
        @floatFromInt(@divFloor(rl.getScreenWidth(), 2)),
        @floatFromInt(@divFloor(rl.getScreenHeight(), 2)),
        color.red,
    );

    try state.asteroids.resize(0);
    for (0..state.maxActiveAsteroids) |_| {
        try state.asteroids.append(Asteroid.new());
    }

    state.gameActive = true;
}

fn update(dt: f32) !void {
    if (!state.gameActive) {
        if (rl.isKeyPressed(rl.KeyboardKey.r)) {
            try resetState();
        }
    }

    state.player.update(dt);

    for (state.asteroids.items) |*asteroid| {
        asteroid.update(dt);
    }

    for (state.asteroids.items) |asteroid| {
        if (state.player.checkCollision(asteroid)) {
            rl.playSound(state.deathSound);
            state.player.status = .dead;
            state.gameEndTime = rl.getTime();
            state.gameActive = false;
        }
    }
}

fn draw() void {
    rl.beginDrawing();
    defer rl.endDrawing();

    rl.clearBackground(color.black);
    drawDebug();

    if (!state.gameActive and (rl.getTime() - state.gameEndTime) > 1) {
        drawGameover();
        return;
    }

    if (state.gameActive) {
        state.player.draw();
    }

    for (state.asteroids.items) |*asteroid| {
        asteroid.draw();
    }
}

fn drawGameover() void {
    const gameoverMessage = "Gameover! Press 'R' to restart!";
    const gameoverFontSize = 30;
    rl.drawText(
        gameoverMessage,
        @divFloor(rl.getScreenWidth() - rl.measureText(gameoverMessage, gameoverFontSize), 2),
        @divFloor(rl.getScreenHeight(), 2),
        gameoverFontSize,
        color.white,
    );
}

fn drawDebug() void {
    if (state.debug) {
        state.player.drawDebug();
        rl.drawFPS(10, 10);
        rl.drawText(INFO_STRING, 10, 40, 20, color.white);

        for (state.asteroids.items) |*asteroid| {
            asteroid.drawDebug();
        }
    }

    _ = gui.guiCheckBox(
        rl.Rectangle{ .height = 20, .width = 20, .x = 5, .y = @floatFromInt(rl.getScreenHeight() - 25) },
        "Show debug info",
        &state.debug,
    );
}
