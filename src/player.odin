package main
import "core:fmt"
import "core:math"
import rl "vendor:raylib"

SENSITIVITY: f32 : 0.003
BASE_SPEED: f32 : 1.3
GRAVITY :: 2.2
TERMINAL_VELOCITY :: 3

Player :: struct {
	camera: rl.Camera,
	pos: rl.Vector3,
	vel: rl.Vector3,
	dir: rl.Vector3,
	rot: rl.Vector2,
	capsule: Capsule,
	active: bool
}

GetPlayerCapsule :: proc(pos: rl.Vector3) -> Capsule { 
	return { {pos, pos - {0, 0.2, 0}, pos - {0, 0.4, 0}}, 0.1 }
}

NewPlayer :: proc() -> Player { 
	return Player{{{0, 0.5, 0}, {1, 0.5, 1}, {0, 1, 0}, 60, .PERSPECTIVE}, {0, 0.5, 0}, {1, 0, 1}, 0, 0, Capsule{0, 0}, true} 
}

UpdatePlayer :: proc(plr: ^Player) {
	speed := rl.GetFrameTime() * BASE_SPEED * (2 if rl.IsKeyDown(.LEFT_SHIFT) else 1)
	mouse_delta := rl.GetMouseDelta() if plr.active else 0
	plr.rot.x -= mouse_delta.x * SENSITIVITY
	plr.rot.y = max(-1.57, min(1.57, plr.rot.y - mouse_delta.y * SENSITIVITY))
	plr.dir = {math.cos(plr.rot.y) * math.sin(plr.rot.x), math.sin(plr.rot.y), math.cos(plr.rot.y) * math.cos(plr.rot.x)}
	
	forward := f32(int(rl.IsKeyDown(.W)) - int(rl.IsKeyDown(.S)))
	sideward := f32(int(rl.IsKeyDown(.D)) - int(rl.IsKeyDown(.A)))
	upward := f32(int(rl.IsKeyDown(.SPACE)) - int(rl.IsKeyDown(.LEFT_CONTROL)))
	
	if !plr.active do forward, sideward, upward = 0, 0, 0
		
	ysin, ycos := math.sin(plr.rot.x), math.cos(plr.rot.x)
	psin := math.sin(plr.rot.y) if game_state == .FREECAM else 0
	pcos := math.cos(plr.rot.y) if game_state == .FREECAM else 1
	plr.vel = 0
		
	plr.vel += {(pcos * ysin * forward), (psin * forward), (pcos * ycos * forward)} * speed // W / S
	plr.vel += {(-ycos * sideward), upward if game_state == .FREECAM else 0, (ysin * sideward)} * speed // Other Buttons
		
	if game_state == .NORMAL && plr.vel.y > -TERMINAL_VELOCITY do plr.vel.y -= GRAVITY * rl.GetFrameTime()
	
	move_order := [3]u8{0, 2, 1}
	for axis in move_order do MovePlayer(plr, axis)
	
	plr.camera.position = plr.pos
	plr.camera.target = plr.pos + plr.dir
	plr.capsule = GetPlayerCapsule(plr.pos)
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

CheckCollisionWithObjects :: proc(plr_pos: rl.Vector3) -> bool {
	for obj in objects do if CheckCollisionCapsuleOBB(GetPlayerCapsule(plr_pos), obj.box) do return true
	return false
}

MovePlayer :: proc(plr: ^Player, axis: u8) {
	if axis >= 3 do return
	npos := plr.pos
	npos[axis] += plr.vel[axis]
	collided := false
	if CheckCollisionWithObjects(npos) do collided = true
	
	if axis != 1 && game_state == .NORMAL {
		CHECKS :: f32(10)
		for j in -CHECKS..=CHECKS {
			if j == 0 do continue
			y_change := f32(j) / 1000
			collision, down_collision_exists := false, false
			if CheckCollisionWithObjects(npos + {0, y_change, 0}) do collision = true
			if j < 0 do if CheckCollisionWithObjects(npos - {0, CHECKS / 1000, 0}) do down_collision_exists = true
			if j < 0 && !collided && !collision && down_collision_exists { npos.y += y_change; break }
			if j > 0 && collided && !collision { npos.y += y_change; collided = false; break }
		}
	}
	
	if !collided { plr.pos = npos; plr.capsule = GetPlayerCapsule(plr.pos) } else if axis == 1 do plr.vel.y = 0
}