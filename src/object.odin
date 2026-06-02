package main

import rl "vendor:raylib"

objects : [dynamic]Object

ObjectProperties :: struct {
	collidable: bool,
	force_draw: bool,
	should_draw: bool,
	selected: bool
}

Object :: struct {
	pos: rl.Vector3,
	rot: rl.Vector3,
	model: Maybe(rl.Model),
	box: OBB,
	rotation_order: MatrixRotationOrder,
	props: ObjectProperties
}

DrawObjects :: proc() { for obj in objects do DrawObject(obj) }

DrawObject :: proc(obj: Object) {
	is_seen := FrustumContainsOBB(GetFrustumFromCamera(&player.camera, f32(SCREEN_SIZE.x / SCREEN_SIZE.y)), obj.box)
	if (!is_seen && !obj.props.force_draw) || !obj.props.should_draw || obj.model == nil do return
	DrawModelPro(obj.model.?, obj.pos, obj.rot, 1, rl.WHITE, obj.rotation_order)
	if debug_on do DrawOOB(obj.box, color = rl.BLUE if OBBIsColliding(obj.box) else rl.RED)
}