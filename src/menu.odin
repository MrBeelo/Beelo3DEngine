package main
import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

ToggleMenu :: proc() {
	menu_active = !menu_active;
	if !menu_active do rl.DisableCursor(); else do rl.EnableCursor()
}

UpdateMenu :: proc() {
	if rl.IsKeyPressed(.ESCAPE) do ToggleMenu()
	if !menu_active do return
	for &button in buttons do UpdateButton(&button)
}

DrawMenu :: proc() {
	if !menu_active do return
	for button in buttons do DrawButton(button)
}

buttons: [1]Button

InitButtons :: proc() {
	buttons = [?]Button{
		NewButton("Cube", 100, proc(){ append(&objects, NewCube({}, {}, {1, 1, 1}, .GREEN)); ToggleMenu() })
	}
}

Text :: struct { str: string, font_size: f32, font_spacing: f32 }
Button :: struct { text: Text, center: rl.Vector2, function: proc(), hovered: bool }

GetButtonSize :: proc(bt: Button) -> rl.Vector2 {
	return rl.MeasureTextEx(rl.GetFontDefault(), strings.clone_to_cstring(bt.text.str), bt.text.font_size, bt.text.font_spacing)
}

GetButtonTopLeft :: proc(bt: Button) -> rl.Vector2 { size := GetButtonSize(bt); return {bt.center.x - size.x / 2, bt.center.y - size.y / 2} }
GetButtonRec :: proc(bt: Button) -> rl.Rectangle { size := GetButtonSize(bt); return {bt.center.x - size.x / 2, bt.center.y - size.y / 2, size.x, size.y} }
NewButton :: proc(str: string, ypos: f32, function: proc()) -> Button { return Button{{str, 32, 3}, {SCREEN_SIZE.x / 2, ypos}, function, false} }

UpdateButton :: proc(bt: ^Button) {
	if rl.CheckCollisionPointRec(rl.GetMousePosition(), GetButtonRec(bt^)) do bt.hovered = true; else do bt.hovered = false
	if bt.hovered && rl.IsMouseButtonPressed(.LEFT) do bt.function()
}

DrawButton :: proc(bt: Button) {
	rl.DrawTextEx(rl.GetFontDefault(), strings.clone_to_cstring(bt.text.str), GetButtonTopLeft(bt), 
		bt.text.font_size, bt.text.font_spacing, rl.WHITE if !bt.hovered else rl.GOLD)
	fmt.printfln("%v, %v, %v", bt.text.str, bt.center, bt.hovered)
}