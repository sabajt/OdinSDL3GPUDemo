package main

import "core:math"

RenderPackData :: struct {
	rad: f32,
	pos: [2]f32,
	last_pos: [2]f32,
	thic: f32,
	fade: f32,
	col: [4]f32
}

pack_sdf :: proc(dt: f32, cam: [2]f32)
{
	first_sdf_input = len(batch_shape_inputs)

	pack_radius_particles_sdf(dt, cam)
	pack_bombs_sdf(dt, cam)
	pack_bullets_sdf(dt, cam)

	last_sdf_input = len(batch_shape_inputs)
}

pack_render_data_sdf :: proc(data: RenderPackData, dt: f32, cam: [2]f32)
{
	models := [dynamic]Batch_Shape_Model{}
	blend_pos: [2]f32
	blend_rad: f32 = data.rad
	blend_pos = math.lerp(data.last_pos, data.pos, dt)
	
	fill_wrap_models(
		models = &models, 
		pos = { blend_pos.x, blend_pos.y, 1 }, // TODO: handle z val
		model_scale = blend_rad * 2.0, 
		screen_scale = blend_rad * 2.0, 
		rot = 0, 
		thic = data.thic,
		fade = data.fade,
		period = 0,
		col = data.col,
		cam = cam,
 	)

	// TODO: instead of appending dups, reference a common quad
	verts := [dynamic]Batch_Shape_Vertex {}

	append(&verts, Batch_Shape_Vertex { 
		position = {-0.5, -0.5}, 
		color = {1, 1, 1, 1}  // multiplying by this col in shader
	})
	append(&verts, Batch_Shape_Vertex { 
		position = {0.5, -0.5}, 
		color = {1, 1, 1, 1}  
	})
	append(&verts, Batch_Shape_Vertex { 
		position = {0.5, 0.5}, 
		color = {1, 1, 1, 1} 
	})

	append(&verts, Batch_Shape_Vertex { 
		position = {-0.5, -0.5}, 
		color = {1, 1, 1, 1}
	})
	append(&verts, Batch_Shape_Vertex { 
		position = {0.5, 0.5}, 
		color = {1, 1, 1, 1}
	})
	append(&verts, Batch_Shape_Vertex { 
		position = {-0.5, 0.5}, 
		color = {1, 1, 1, 1}
	})

	pack_batch_shape_arr(
		src_verts = verts[:],
		// TODO: understand how these models don't go out of memory, 
		// b/c they are added to another dynamic array?
		src_models = models[:],
		dest_verts = &batch_shape_verts,
		dest_models = &batch_shape_models,
		dest_inputs = &batch_shape_inputs
	)

	delete(models)
	delete(verts)
}


