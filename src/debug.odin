package main

import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

debug_on := true

draw_debug_strip :: proc(name: string, index: int, args: ..any) {
	format_name := strings.concatenate({name, ": "})
	for arg in args do format_name = strings.concatenate({format_name, "%v, "})
	format_name = strings.cut(format_name, rune_length = len(format_name) - 2)
	rl.DrawText(fmt.ctprintf(format_name, ..args), 10, 10 + 40 * i32(index), 32, rl.LIGHTGRAY)
}

draw_debug :: proc() {
	if !debug_on do return
	draw_debug_strip("FPS", 0, rl.GetFPS())
    draw_debug_strip("Player State", 1, player.state)
    draw_debug_strip("Position", 2, player.pos)
}