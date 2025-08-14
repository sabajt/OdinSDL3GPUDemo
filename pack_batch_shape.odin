package main

import "core:fmt"

clear_batch_shape :: proc() 
{
	// TODO: can selectively not clear to get render trail to advantage...
	// clear and stop update for permanent trail (default behavior)
	// clear and continue to update for animating trail

	clear(&batch_shape_inputs)
	clear(&batch_shape_verts)
	clear(&batch_shape_models)
}

// pack a shape based on existing vert ref
pack_batch_shape_vert_ref :: proc (vert_index: int, count: int, model: Batch_Shape_Model)
{
	model_index := uint(len(batch_shape_models))
	append(&batch_shape_models, model)

	for i := vert_index; i < vert_index + count; i += 1 {
		input := Batch_Shape_Input { 
			vertex_index = uint(i),
			model_index = model_index
		}
		append(&batch_shape_inputs, input)
	}
}

// add a new vert ref, return index
pack_vert_ref :: proc(verts : []Batch_Shape_Vertex) -> (vert_index: int)
{
	i := len(batch_shape_verts)
	for &v in verts {
		append(&batch_shape_verts, v)
	}
	return i
}

pack_batch_shape :: proc(verts : []Batch_Shape_Vertex, model: Batch_Shape_Model) 
{
	// TODO: understand odin reference / arg passing rules 

	model_index := uint(len(batch_shape_models))
	append(&batch_shape_models, model)

	for &v in verts {
		vertex_index := uint(len(batch_shape_verts))
		append(&batch_shape_verts, v)

		input := Batch_Shape_Input { 
			vertex_index = vertex_index,
			model_index = model_index
		}
		append(&batch_shape_inputs, input)
	}
}

pack_batch_shape_arr :: proc(
	src_verts : []Batch_Shape_Vertex, 
	src_models: []Batch_Shape_Model, 
	dest_verts: ^[dynamic]Batch_Shape_Vertex,
	dest_models: ^[dynamic]Batch_Shape_Model,
	dest_inputs: ^[dynamic]Batch_Shape_Input) 
{
	// TODO: understand odin reference / arg passing rules 

	vertex_start_index := len(dest_verts)
	num_verts := len(src_verts)

	for &v in src_verts {
		append(dest_verts, v)
	}

	for m in src_models {
		model_index := uint(len(dest_models))
		append(dest_models, m)

		for i := 0; i < num_verts; i += 1 {

			input := Batch_Shape_Input { 
				vertex_index = uint(vertex_start_index + i),
				model_index = model_index
			}
			append(dest_inputs, input)
		}
	}
}

fill_wrap_models :: proc(
	models: ^[dynamic]Batch_Shape_Model, 
	pos: [3]f32, 
	model_scale: [2]f32, 
	screen_scale: [2]f32,
	rot: f32,
	thic: f32, 
	fade: f32,
	period: f32,
	col: [4]f32,
	cam: [2]f32) 
{
	wr := pos.x + screen_scale.x / 2.0 > (cam.x + resolution.x)
	wl := pos.x - screen_scale.x / 2.0 < cam.x
	wt := pos.y + screen_scale.y / 2.0 > (cam.y + resolution.y)
	wb := pos.y - screen_scale.y / 2.0 < cam.y

	positions := []([3]f32){pos}

	if wr && wt{
		positions = {
			pos, 
			{pos.x - resolution.x, pos.y, pos.z}, // l
			{pos.x, pos.y - resolution.y, pos.z}, // b
			{pos.x - resolution.x, pos.y - resolution.y, pos.z}, // bl
		}
	} else if wl && wt{
		positions = {
			pos, 
			{pos.x + resolution.x, pos.y, pos.z}, // r
			{pos.x, pos.y - resolution.y, pos.z}, // b
			{pos.x + resolution.x, pos.y - resolution.y, pos.z}, // br
		}
	} else if wr && wb{
		positions = {
			pos, 
			{pos.x - resolution.x, pos.y, pos.z}, // l
			{pos.x, pos.y + resolution.y, pos.z}, // t
			{pos.x - resolution.x, pos.y + resolution.y, pos.z}, // tl
		}
	} else if wl && wb{
		positions = {
			pos, 
			{pos.x + resolution.x, pos.y, pos.z}, // r
			{pos.x, pos.y + resolution.y, pos.z}, // t
			{pos.x + resolution.x, pos.y + resolution.y, pos.z}, // tr
		}
	} else if wr {
		positions = {
			pos,
			{pos.x - resolution.x, pos.y, pos.z}
		}
	} else if wl {
		positions = {
			pos,
			{pos.x + resolution.x, pos.y, pos.z}
		}
	} else if wt {
		positions = {
			pos,
			{pos.x, pos.y - resolution.y, pos.z}
		}
	} else if wb {
		positions = {
			pos,
			{pos.x, pos.y + resolution.y, pos.z}
		}
	}

	for p, i in positions {
		model := Batch_Shape_Model {
			position = p,
	    	rotation = rot,
	    	scale = model_scale,
	    	color = col,
	    	thic = thic,
	    	fade = fade,
	    	period = period
		}
		append(models, model)
	}
}

