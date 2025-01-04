const std = @import("std");
const rl = @import("raylib");
const entity = @import("entity.zig");

const rlm = rl.math;
const math = std.math;

const color = rl.Color;
const Vector2 = rl.Vector2;

pub fn main() !void {
    rl.initWindow(1280, 720, "Raylib Zig");
    defer rl.closeWindow();

    rl.setTargetFPS(120);

    var asteroids: [40]entity.Asteroid = undefined;
    var asteroidCount: usize = 0;
    var lastSpawnTime: f64 = 0;
    // for (0..asteroids.len) |idx| {
    //     asteroids[idx] = entity.Asteroid.create(
    //         @floatFromInt(rl.getRandomValue(0, 1280)),
    //         @floatFromInt(rl.getRandomValue(0, 720)),
    //         @floatFromInt(rl.getRandomValue(50, 150)),
    //     );
    // }

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();

        rl.drawFPS(10, 10);

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
