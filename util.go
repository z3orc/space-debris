package main

import rl "github.com/gen2brain/raylib-go/raylib"

func ClampPosition(
	position rl.Vector2,
	padding float32,
	screenWidth int32,
	screenHeight int32) rl.Vector2 {

	if position.X < 0-(padding*1.1) {
		position.X = float32(screenWidth) + padding
	}

	if position.X > float32(screenWidth)+(padding*1.1) {
		position.X = 0 - padding
	}

	if position.Y < 0-(padding*1.1) {
		position.Y = float32(screenHeight) + padding
	}

	if position.Y > float32(screenHeight)+(padding*1.1) {
		position.Y = 0 - padding
	}

	return position
}
