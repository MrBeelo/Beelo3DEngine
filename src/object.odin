package main

import "core:math"
import rl "vendor:raylib"

objects : [dynamic]Object

ObjectProperties :: struct {
	collidable: bool,
	force_draw: bool,
	should_draw: bool,
	rotation_order: MatrixRotationOrder
}
DefaultObjectProperties :: proc() -> ObjectProperties { return {true, false, true, .XYZ} }

Object :: struct {
	pos: rl.Vector3,
	rot: rl.Vector3,
	model: rl.Model,
	box: OOB,
	props: ObjectProperties
}

DrawObjects :: proc() { for &obj in objects do DrawObject(&obj) }

DrawObject :: proc(obj: ^Object) {
	//is_seen := FrustumContainsBox(GetFrustumFromCamera(&player.camera, f32(SCREEN_SIZE.x / SCREEN_SIZE.y)), rl.GetModelBoundingBox(obj.model))
	if !obj.props.should_draw do return // if !is_seen && !obj.props.force_draw
	DrawModelPro(&obj.model, obj.pos, obj.rot, 1, rl.WHITE, obj.props.rotation_order)
}