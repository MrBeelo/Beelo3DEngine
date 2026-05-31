package main

import rl "vendor:raylib"

OOB :: struct {
	center: rl.Vector3,
	axis: [3]rl.Vector3,
	half_size: rl.Vector3
}