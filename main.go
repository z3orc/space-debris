package main

import (
	"math"
	"math/rand"

	rl "github.com/gen2brain/raylib-go/raylib"
)

const SCREEN_WIDTH int32 = 1280
const SCREEN_HEIGHT int32 = 720
const ASTEROID_COUNT = 24

func main() {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Space Debris")
	defer rl.CloseWindow()

	rl.SetTargetFPS(120)

	var asteroids [ASTEROID_COUNT]*Asteroid
	var player Player = NewPlayer(200, 200, rl.Red)

	for idx, asteroid := range asteroids {
		if asteroid == nil {
			new := AsteroidCreate(
				rand.Float32()*float32(rl.GetScreenWidth()),
				rand.Float32()*float32(rl.GetScreenHeight()),
				float32(rl.GetRandomValue(100, 250)))

			// fmt.Println(new.Size)

			asteroids[idx] = &new
		}
	}

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.Black)

		rl.DrawFPS(10, 10)

		player.Update(rl.GetFrameTime())
		for _, asteroid := range asteroids {
			asteroid.Update(rl.GetFrameTime())
		}

		player.Draw()
		for _, asteroid := range asteroids {
			asteroid.Draw()
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

func (a *Asteroid) Draw() {
	rl.DrawPolyLines(a.Position, 3, a.Size, a.Rotation, rl.White)
}

func (a *Asteroid) Update(dt float32) {
	a.Position = ClampPosition(a.Position, a.Size, SCREEN_WIDTH, SCREEN_HEIGHT)

	a.Position = rl.Vector2Add(
		a.Position,
		rl.Vector2Scale(a.Velocity, dt),
	)

	a.Rotation = float32(math.Mod(
		float64(a.Rotation+(a.RotationSpeed*dt)),
		360))
}

type Player struct {
	Position      rl.Vector2
	Velocity      rl.Vector2
	Rotation      float32
	RotationSpeed float32
	Acceleration  float32
	Drag          float32
	MaxSpeed      float32
}

func NewPlayer(posX float32, posY float32, color rl.Color) Player {
	return Player{
		Position:      rl.NewVector2(posX, posY),
		Rotation:      10,
		RotationSpeed: 300,
		Acceleration:  5,
		Drag:          0.3,
		MaxSpeed:      350,
	}
}

func (p *Player) Draw() {
	rl.DrawPolyLines(p.Position, 3, 16, p.Rotation, rl.Red)
}

func (p *Player) Update(dt float32) {
	rotationRadians := p.Rotation * rl.Deg2rad
	direction := rl.Vector2{
		X: float32(math.Cos(float64(rotationRadians))),
		Y: float32(math.Sin(float64(rotationRadians))),
	}

	if rl.IsKeyDown(rl.KeyW) {
		p.Velocity = rl.Vector2Add(
			p.Velocity,
			rl.Vector2Scale(direction, p.Acceleration),
		)

		p.Velocity = rl.Vector2ClampValue(p.Velocity, -p.MaxSpeed, p.MaxSpeed)
	} else if rl.IsKeyDown(rl.KeyS) {
		p.Velocity = rl.Vector2Subtract(
			p.Velocity,
			rl.Vector2Scale(direction, p.Acceleration),
		)

		p.Velocity = rl.Vector2ClampValue(p.Velocity, -250, 250)
	}

	p.Velocity = rl.Vector2Scale(p.Velocity, float32(math.Pow(float64(p.Drag), float64(dt))))

	p.Position = rl.Vector2Add(
		p.Position,
		rl.Vector2Scale(p.Velocity, dt),
	)

	p.Position = ClampPosition(p.Position, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

	if rl.IsKeyDown(rl.KeyA) {
		p.Rotation -= p.RotationSpeed * dt
	}

	if rl.IsKeyDown(rl.KeyD) {
		p.Rotation += p.RotationSpeed * dt
	}

	p.Rotation = float32(math.Mod(float64(p.Rotation), 360))
	// if p.Rotation < 0 {
	// 	p.Rotation += 360
	// }

}
