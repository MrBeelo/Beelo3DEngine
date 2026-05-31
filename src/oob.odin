package main

import rl "vendor:raylib"

OBB :: struct {
	center: rl.Vector3,
	axis: [3]rl.Vector3,
	half_size: rl.Vector3
}

DrawOOB :: proc(obb: OBB, offset := f32(0.03), color := rl.RED) {
	hx := obb.axis.x * (obb.half_size.x + offset)
	hy := obb.axis.y * (obb.half_size.y + offset)
	hz := obb.axis.z * (obb.half_size.z + offset)

	corners := [?]rl.Vector3{
    	obb.center - hx - hy - hz,
     	obb.center + hx - hy - hz,
     	obb.center + hx + hy - hz,
     	obb.center - hx + hy - hz,

      	obb.center - hx - hy + hz,
       	obb.center + hx - hy + hz,
        obb.center + hx + hy + hz,
        obb.center - hx + hy + hz,
	}
	
	rl.DrawLine3D(corners[0], corners[1], color)
	rl.DrawLine3D(corners[1], corners[2], color)
	rl.DrawLine3D(corners[2], corners[3], color)
	rl.DrawLine3D(corners[3], corners[0], color)
	rl.DrawLine3D(corners[4], corners[5], color)
	rl.DrawLine3D(corners[5], corners[6], color)
	rl.DrawLine3D(corners[6], corners[7], color)
	rl.DrawLine3D(corners[7], corners[4], color)
	rl.DrawLine3D(corners[0], corners[4], color)
	rl.DrawLine3D(corners[1], corners[5], color)
	rl.DrawLine3D(corners[2], corners[6], color)
	rl.DrawLine3D(corners[3], corners[7], color)
}