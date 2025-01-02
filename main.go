package main

import (
	"fmt"
	"math"
	"math/rand"

	rl "github.com/gen2brain/raylib-go/raylib"
)

const SCREEN_WIDTH int32 = 1280
const SCREEN_HEIGHT int32 = 720

func main() {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Space Debris")
	defer rl.CloseWindow()

	rl.SetTargetFPS(120)

	var asteroids [32]*Asteroid
	for idx, asteroid := range asteroids {
		if asteroid == nil {
			new := AsteroidCreate(
				rand.Float32()*float32(rl.GetScreenWidth()),
				rand.Float32()*float32(rl.GetScreenHeight()),
				float32(rl.GetRandomValue(100, 250)))

			fmt.Println(new.Size)

			asteroids[idx] = &new
		}
	}

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.Black)

		rl.DrawFPS(10, 10)

		for _, asteroid := range asteroids {
			asteroid.update(rl.GetFrameTime())
		}

		for _, asteroid := range asteroids {
			asteroid.draw()
		}

		rl.EndDrawing()
	}
}

type Asteroid struct {
	Position      rl.Vector2
	Velocity      rl.Vector2
	Rotation      float32
	RotationSpeed float32
	Size          float32
	Active        bool
}

func AsteroidCreate(posX float32, posY float32, speed float32) Asteroid {
	angle := rand.Float64() * 2 * math.Pi
	direction := rl.Vector2{
		X: float32(math.Cos(angle)),
		Y: float32(math.Sin(angle)),
	}

	return Asteroid{
		Position:      rl.Vector2{X: posX, Y: posY},
		Velocity:      rl.Vector2Scale(direction, speed),
		Rotation:      float32(rand.Int31() % 360),
		RotationSpeed: float32(rand.Int31() % 300),
		Size:          15 + rand.Float32()*(64-15),
	}
}

func (a *Asteroid) draw() {
	rl.DrawPolyLines(a.Position, 3, a.Size, a.Rotation, rl.White)
}

func (a *Asteroid) update(dt float32) {
	if a.Position.X < 0-(a.Size*1.1) {
		a.Position.X = float32(SCREEN_WIDTH) + a.Size
	}

	if a.Position.X > float32(SCREEN_WIDTH)+(a.Size*1.1) {
		a.Position.X = 0 - a.Size
	}

	if a.Position.Y < 0-(a.Size*1.1) {
		a.Position.Y = float32(SCREEN_HEIGHT) + a.Size
	}

	if a.Position.Y > float32(SCREEN_HEIGHT)+(a.Size*1.1) {
		a.Position.Y = 0 - a.Size
	}

	a.Position = rl.Vector2Add(
		a.Position,
		rl.Vector2Scale(a.Velocity, dt),
	)

	a.Rotation = float32(math.Mod(float64(a.Rotation+(a.RotationSpeed*dt)), 360))
}
