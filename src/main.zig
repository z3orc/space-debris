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

var asteroids: [40]entity.Asteroid = undefined;
var activeAsteroids: usize = 0;

pub fn main() !void {
    rl.initWindow(1280, 720, "Space Debris");
    defer rl.closeWindow();

    rl.setTargetFPS(120);

    var showDebugInfo: bool = true;
    for (0..asteroids.len) |idx| {
        asteroids[idx] = entity.Asteroid.new();
        activeAsteroids += 1;
    }

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
