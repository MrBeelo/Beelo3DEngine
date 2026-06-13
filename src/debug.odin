package main

import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

debug_on := true

DrawDebugStrip :: proc(name: string, index: int, args: ..any) {
	format_name := strings.concatenate({name, ": "})
	for arg in args do format_name = strings.concatenate({format_name, "%v, "})
	format_name = strings.cut(format_name, rune_length = len(format_name) - 2)
	rl.DrawText(fmt.ctprintf(format_name, ..args), 10, 10 + 40 * i32(index), 32, rl.LIGHTGRAY)
}

DrawDebug :: proc() {
	if !debug_on do return
	DrawDebugStrip("FPS", 0, rl.GetFPS())
    DrawDebugStrip("Player State", 1, game_state)
    DrawDebugStrip("Position", 2, player.pos)
    DrawDebugStrip("Velocity", 3, player.vel)
}