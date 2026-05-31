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
    
    LoadTextures()
    defer UnloadTextures()
    player = NewPlayer()
    
    append(&objects, NewCube({2, 0, 2}, {30, 0, 0}, {1, 1, 2}, .GRAY))
        
    for !rl.WindowShouldClose() {
    	UpdatePlayer(&player)
     	if rl.IsKeyPressed(.F3) do debug_on = !debug_on
     
        rl.BeginDrawing()
        defer rl.EndDrawing()
        rl.ClearBackground(rl.WHITE)
        
        rl.BeginMode3D(player.camera)
        rl.DrawGrid(100, 0.2)
        DrawObjects()
        rl.EndMode3D()
        
        DrawCrosshair()
        DrawDebug()
    }
}