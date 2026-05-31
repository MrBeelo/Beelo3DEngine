package main

import rl "vendor:raylib"

MatrixRotationOrder :: enum{ XYZ, XZY, YXZ, YZX, ZXY, ZYX }

MatrixRotateGeneral :: proc(vector: rl.Vector3, order: MatrixRotationOrder) -> rl.Matrix {
	v := rot_rad(vector)
	rx := rl.MatrixRotateX(v.x)
	ry := rl.MatrixRotateY(v.y)
    rz := rl.MatrixRotateZ(v.z)
    switch(order) {
    	case .XYZ: return rx * ry * rz
     	case .XZY: return rx * rz * ry
      	case .YXZ: return ry * rx * rz
       	case .YZX: return ry * rz * rx
        case .ZXY: return rz * rx * ry
        case .ZYX: return rz * ry * rx
    }
    
    return rx * ry * rz
}

DrawModelPro :: proc(model: rl.Model, position: rl.Vector3, rotation: rl.Vector3, scale: rl.Vector3, tint: rl.Color, order: MatrixRotationOrder = MatrixRotationOrder.XYZ) {
    matScale := rl.MatrixScale(scale.x, scale.y, scale.z)
    matRotation := MatrixRotateGeneral(rotation, order)
    matTranslation := rl.MatrixTranslate(position.x, position.y, position.z)
    matTransform := matTranslation * matRotation * matScale

    for i := 0; i < int(model.meshCount); i += 1 {
        mat := model.materials[model.meshMaterial[i]]
        colDiffuse := mat.maps[rl.MaterialMapIndex.ALBEDO].color

        colTinted: rl.Color = {}
        colTinted.r = u8((int(colDiffuse.r) * int(tint.r)) / 255)
        colTinted.g = u8((int(colDiffuse.g) * int(tint.g)) / 255)
        colTinted.b = u8((int(colDiffuse.b) * int(tint.b)) / 255)
        colTinted.a = u8((int(colDiffuse.a) * int(tint.a)) / 255)

        mat.maps[rl.MaterialMapIndex.ALBEDO].color = colTinted
        rl.DrawMesh(model.meshes[i], mat, matTransform)
        mat.maps[rl.MaterialMapIndex.ALBEDO].color = colDiffuse
    }
}