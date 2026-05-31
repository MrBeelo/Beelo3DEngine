package main

import "core:mem"
import rl "vendor:raylib"

cube_model_cache: map[struct{scale: rl.Vector3, tile: bool}]rl.Model

NewCube :: proc(pos: rl.Vector3, rot: rl.Vector3, scale: rl.Vector3, texture := TextureType.GRAY, tile := true, 
props := ObjectProperties{true, false, true, .XYZ}) -> Object {
	model: rl.Model
	if cached_model, ok := cube_model_cache[{scale, tile}]; ok do model = cached_model; else {
		model = rl.LoadModelFromMesh(GenCustomCubeMesh(scale, tile))
		cube_model_cache[{scale, tile}] = model
	}
	model.materials[0].maps[0].texture = textures[texture]
	return Object{pos, rot, model, GetCubeOBB(pos, rot, scale, props.rotation_order), props}
}

GetCubeOBB :: proc(pos: rl.Vector3, rot: rl.Vector3, scale: rl.Vector3, order: MatrixRotationOrder) -> OBB {
	rm := MatrixRotateGeneral(rot, order)
	axis_x := rl.Vector3{rm[0, 0], rm[1, 0], rm[2, 0]}
	axis_y := rl.Vector3{rm[0, 1], rm[1, 1], rm[2, 1]}
	axis_z := rl.Vector3{rm[0, 2], rm[1, 2], rm[2, 2]}
	return {pos, {axis_x, axis_y, axis_z}, scale / 2}
}

GenCustomCubeMesh :: proc(scale: rl.Vector3, tile: bool = true) -> rl.Mesh {
	hw := scale.x / 2
	hh := scale.y / 2
	hl := scale.z / 2
	vertices := [?]f32{
        -hw, -hh, hl,  hw, -hh, hl,  hw, hh, hl,  -hw, -hh, hl,  hw, hh, hl,  -hw, hh, hl, // FRONT
        hw, -hh, -hl,  -hw, -hh, -hl,  -hw, hh, -hl,  hw, -hh, -hl,  -hw, hh, -hl,  hw, hh, -hl, // BACK
        -hw, -hh, -hl,  -hw, -hh, hl,  -hw, hh, hl,  -hw, -hh, -hl,  -hw, hh, hl,  -hw, hh, -hl, // LEFT
        hw, -hh, hl,  hw, -hh, -hl,  hw, hh, -hl,  hw, -hh, hl,  hw, hh, -hl,  hw, hh, hl, // RIGHT
        -hw, hh, hl,  hw, hh, hl,  hw, hh, -hl,  -hw, hh, hl,  hw, hh, -hl,  -hw, hh, -hl, // TOP
        -hw, -hh, -hl,  hw, -hh, -hl,  hw, -hh, hl,  -hw, -hh, -hl,  hw, -hh, hl,  -hw, -hh, hl // BOTTOM
    }
    
    tw := (tile) ? scale.x : 1
    th := (tile) ? scale.y : 1
    tl := (tile) ? scale.z : 1
    texcoords := [?]f32{
        0, 0,  tw, 0,  tw, th,  0, 0,  tw, th,  0, th, // FRONT
        0, 0,  tw, 0,  tw, th,  0, 0,  tw, th,  0, th, // BACK
        0, 0,  tl, 0,  tl, th,  0, 0,  tl, th,  0, th, // LEFT
        0, 0,  tl, 0,  tl, th,  0, 0,  tl, th,  0, th, // RIGHT
        0, 0,  tw, 0,  tw, tl,  0, 0,  tw, tl,  0, tl, // TOP
        0, 0,  tw, 0,  tw, tl,  0, 0,  tw, tl,  0, tl, // BOTTOM
    }

    normals := [?]f32{
        0, 0, 1,  0, 0, 1,  0, 0, 1,  0, 0, 1,  0, 0, 1,  0, 0, 1, // FRONT
        0, 0,-1,  0, 0,-1,  0, 0,-1,  0, 0,-1,  0, 0,-1,  0, 0,-1, // BACK
        -1, 0, 0,  -1, 0, 0,  -1, 0, 0,  -1, 0, 0,  -1, 0, 0,  -1, 0, 0, // LEFT
        1, 0, 0,  1, 0, 0,  1, 0, 0,  1, 0, 0,  1, 0, 0,  1, 0, 0, // RIGHT
        0, 1, 0,  0, 1, 0,  0, 1, 0,  0, 1, 0,  0, 1, 0,  0, 1, 0, // TOP
        0,-1, 0,  0,-1, 0,  0,-1, 0,  0,-1, 0,  0,-1, 0,  0,-1, 0, // BOTTOM
    }
    
    mesh := rl.Mesh{}
    mesh.vertexCount = 36

    vertices_ptr, _ := mem.alloc(len(vertices) * size_of(f32))
    mesh.vertices = cast([^]f32) vertices_ptr
    mem.copy(mesh.vertices, &vertices, len(vertices) * size_of(f32))
    
    texcoords_ptr, _ := mem.alloc(len(texcoords) * size_of(f32))
    mesh.texcoords = cast([^]f32) texcoords_ptr
    mem.copy(mesh.texcoords, &texcoords, len(texcoords) * size_of(f32))
    
    normals_ptr, _ := mem.alloc(len(normals) * size_of(f32))
    mesh.normals = cast([^]f32) normals_ptr
    mem.copy(mesh.normals, &normals, len(normals) * size_of(f32))
    
    rl.GenMeshTangents(&mesh)

    rl.UploadMesh(&mesh, false)
    return mesh
}