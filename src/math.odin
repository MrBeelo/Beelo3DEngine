package main

import "core:math"

array_min :: proc(arr: []$T) -> T {
	min := arr[0]
	for t in arr do if t < min do min = t
	return min
}

array_max :: proc(arr: []$T) -> T {
	max := arr[0]
	for t in arr do if t > max do max = t
	return max
}

rot_rad :: proc(v: [3]f32) -> [3]f32 {
	return {math.to_radians(v.x), math.to_radians(v.y), math.to_radians(v.z)}
}