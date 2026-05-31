package main

import "core:strings"
import rl "vendor:raylib"

TextureType :: enum {GREEN, GRAY, RED}
textures: map[TextureType]rl.Texture2D

LoadEmbeddedTexture :: proc($name: string, $extension: string) -> rl.Texture2D {
	data := #load("../res/" + name + extension)
	image := rl.LoadImageFromMemory(strings.clone_to_cstring(extension), &data[0], i32(len(data)))
	texture := rl.LoadTextureFromImage(image)
	rl.UnloadImage(image)
	return texture
}

LoadTextures :: proc() {
	textures[.GREEN] = LoadEmbeddedTexture("green", ".png")
	textures[.GRAY] = LoadEmbeddedTexture("gray", ".png")
	textures[.RED] = LoadEmbeddedTexture("red", ".png")
}

UnloadTextures :: proc() { for type, texture in textures do rl.UnloadTexture(texture) }