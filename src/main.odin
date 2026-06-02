package main

import rl "vendor:raylib"

SCREEN_SIZE :: rl.Vector2{1920, 1080}
game_state: enum{NORMAL, FREECAM} = .FREECAM
menu_active := false
game_texture: rl.RenderTexture2D
player: Player

main :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(i32(SCREEN_SIZE.x), i32(SCREEN_SIZE.y), "Beelo 3D Engine")
    defer rl.CloseWindow()
    rl.DisableCursor()
    rl.SetExitKey(.KEY_NULL)
    
    LoadTextures()
    defer UnloadTextures()
    game_texture = rl.LoadRenderTexture(i32(SCREEN_SIZE.x), i32(SCREEN_SIZE.y))
    defer rl.UnloadRenderTexture(game_texture)
    InitButtons()
    player = NewPlayer()
    
    append(&objects, NewCube({2, 0, 2}, {30, 0, 0}, {1, 1, 2}, .RED))
    append(&objects, NewCube({3, 0, 3}, {0, 0, 30}, {1, 1, 2}, .GREEN))
    append(&objects, NewCube({0.5, 0.5, 0.5}, {0, 50, 0}, {1, 1, 1}, .GRAY))
        
    for !rl.WindowShouldClose() {
    	UpdatePlayer(&player)
    	UpdateMenu()
     	if rl.IsKeyPressed(.F3) do debug_on = !debug_on
     
        rl.BeginTextureMode(game_texture)
        rl.ClearBackground(rl.WHITE)
        rl.BeginMode3D(player.camera)
        rl.DrawGrid(100, 0.2)
        DrawObjects()
        rl.EndMode3D()
        rl.EndTextureMode()
        
        rl.BeginDrawing()
        defer rl.EndDrawing()
        rl.ClearBackground(rl.WHITE)
        rl.DrawTexturePro(game_texture.texture, {0, 0, SCREEN_SIZE.x, -SCREEN_SIZE.y}, 
        	{0, 0, SCREEN_SIZE.x, SCREEN_SIZE.y}, {}, 0, rl.WHITE if !menu_active else rl.GRAY)
        
        DrawCrosshair()
        DrawMenu()
        DrawDebug()
    }
}