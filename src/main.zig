const std = @import("std");
const builtin = @import("builtin");
const rl = @import("raylib");
const gui = @import("raygui");

const entity = @import("entity.zig");
const rlm = rl.math;
const math = std.math;

const color = rl.Color;
const Vector2 = rl.Vector2;

const INFO_STRING = "SPACE DEBRIS DEV 0.1.0 " ++ builtin.target.osArchName() ++ " " ++ builtin.zig_version_string;

pub fn main() !void {
    rl.initWindow(1280, 720, "Space Debris");
    defer rl.closeWindow();

    rl.setTargetFPS(120);

    var asteroids: [40]entity.Asteroid = undefined;
    var asteroidCount: usize = 0;
    var lastSpawnTime: f64 = 0;
    var showDebugInfo: bool = true;
    // for (0..asteroids.len) |idx| {
    //     asteroids[idx] = entity.Asteroid.create(
    //         @floatFromInt(rl.getRandomValue(0, 1280)),
    //         @floatFromInt(rl.getRandomValue(0, 720)),
    //         @floatFromInt(rl.getRandomValue(50, 150)),
    //     );
    // }

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();

        if (showDebugInfo) {
            rl.drawFPS(10, 10);
            rl.drawText(INFO_STRING, 10, 40, 20, color.white);
        }

        _ = gui.guiCheckBox(
            rl.Rectangle{ .height = 20, .width = 20, .x = 5, .y = @floatFromInt(rl.getScreenHeight() - 25) },
            "Show debug info",
            &showDebugInfo,
        );

        if (asteroidCount < 36 and (rl.getTime() - lastSpawnTime) > 0.2) {
            asteroids[asteroidCount] = entity.Asteroid.create(
                @floatFromInt(rl.getRandomValue(0, 1280)),
                @floatFromInt(rl.getRandomValue(0, 720)),
                @floatFromInt(rl.getRandomValue(50, 150)),
            );

            asteroidCount += 1;
            lastSpawnTime = rl.getTime();
        }

        for (&asteroids) |*asteroid| {
            asteroid.update(rl.getFrameTime());
        }

        for (&asteroids) |*asteroid| {
            asteroid.draw();
        }

        rl.clearBackground(color.black);
        rl.endDrawing();
    }
}
