package main

import "core:math"
import rl "vendor:raylib"

SENSITIVITY: f32 : 0.003
BASE_SPEED: f32 : 3

Player :: struct {
	state: enum{NORMAL, FREECAM},
	camera: rl.Camera,
	pos: rl.Vector3,
	vel: rl.Vector3,
	dir: rl.Vector3,
	rot: rl.Vector2
}

NewPlayer :: proc() -> Player {
	return Player{.FREECAM, {{0, 0.5, 0}, {1, 0.5, 1}, {0, 1, 0}, 60, .PERSPECTIVE}, {0, 0.5, 0}, {1, 0, 1}, 0, 0}
}

UpdatePlayer :: proc(plr: ^Player) {
	speed := rl.GetFrameTime() * BASE_SPEED * (2 if rl.IsKeyDown(.LEFT_SHIFT) else 1)
	plr.rot.x -= rl.GetMouseDelta().x * SENSITIVITY
	plr.rot.y = max(-1.57, min(1.57, plr.rot.y - rl.GetMouseDelta().y * SENSITIVITY))
	plr.dir = {math.cos(plr.rot.y) * math.sin(plr.rot.x), math.sin(plr.rot.y), math.cos(plr.rot.y) * math.cos(plr.rot.x)}
	
	forward := f32(int(rl.IsKeyDown(.W)) - int(rl.IsKeyDown(.S)))
	sideward := f32(int(rl.IsKeyDown(.D)) - int(rl.IsKeyDown(.A)))
	upward := f32(int(rl.IsKeyDown(.SPACE)) - int(rl.IsKeyDown(.LEFT_CONTROL)))
	
	ysin, ycos := math.sin(plr.rot.x), math.cos(plr.rot.x)
	psin := math.sin(plr.rot.y) if plr.state == .FREECAM else 0
	pcos := math.cos(plr.rot.y) if plr.state == .FREECAM else 1
	plr.vel = 0
		
	plr.vel += {(pcos * ysin * forward), (psin * forward), (pcos * ycos * forward)} * speed // W / S
	plr.vel += {(-ycos * sideward), upward if plr.state == .FREECAM else 0, (ysin * sideward)} * speed // Other Buttons
	
	plr.pos += plr.vel // ! Stop this if the player shouldn't be able to move
	
	plr.camera.position = plr.pos
	plr.camera.target = plr.pos + plr.dir
}

DrawCrosshair :: proc() {
	LINE_SIZE :: 30
	DSCR_X :: SCREEN_SIZE.x / 2
	DSCR_Y :: SCREEN_SIZE.y / 2
	OFFSET_X :: DSCR_X - LINE_SIZE / 2
	OFFSET_Y :: DSCR_Y - LINE_SIZE / 2
	LINE_THICKNESS :: 2
	rl.DrawLineEx({OFFSET_X, DSCR_Y}, {SCREEN_SIZE.x - OFFSET_X, DSCR_Y}, LINE_THICKNESS, rl.BLACK)
	rl.DrawLineEx({DSCR_X, OFFSET_Y}, {DSCR_X, SCREEN_SIZE.y - OFFSET_Y}, LINE_THICKNESS, rl.BLACK)
}