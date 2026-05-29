package main

import "core:fmt"

import rl "vendor:raylib"

SCREEN_SIZE :: rl.Vector2{1920, 1080}
player: Player

main :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(i32(SCREEN_SIZE.x), i32(SCREEN_SIZE.y), "Beelo 3D Engine")
    defer rl.CloseWindow()
    rl.DisableCursor()
    
    player = new_player()
        
    for !rl.WindowShouldClose() {
    	update_player(&player)
     	if rl.IsKeyPressed(.F3) do debug_on = !debug_on
     
        rl.BeginDrawing()
        defer rl.EndDrawing()
        rl.ClearBackground(rl.WHITE)
        
        rl.BeginMode3D(player.camera)
        rl.DrawGrid(100, 0.2)
        rl.EndMode3D()
        
        draw_crosshair()
        draw_debug()
    }
}