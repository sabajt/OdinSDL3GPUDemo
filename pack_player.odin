package main

import "core:fmt"
import "core:math"


pack_player_1 :: proc(dt: f32) 
{
	blend_pos := [3]f32 {}
	blend_pos.xy = math.lerp(player_1.last_pos, player_1.pos, dt)
	blend_pos.z = 1

	blend_rot := math.lerp(player_1.last_rot, player_1.rot, dt)
	blend_rot -= math.PI / 2.0 // model rotation offset

	p1_model := Batch_Shape_Model {
		position = blend_pos,
    	rotation = blend_rot,
    	scale = player_1.SCALE,
    	color = {1,1,1,1}, // model can be "identity" to multiply by itself
    	thic = 0, // not used
    	fade = 0, // not used
    	period = 0
	}

	alpha := f32(1)
	if player_1.grace_t > 0 {
		a := player_1.grace_t / PLAYER_GRACE_FLASH_PERIOD
		if a % 2 == 0 {
			alpha = 0
		} 
	}
	col : [4]f32 = {player_1.col.r, player_1.col.g, player_1.col.b, alpha}
	black := [4]f32 {0,0,0,alpha}

	pack_batch_shape(
		verts = {
			{ position = {-0.5, -0.5}, color = col}, // bl <- vert color specified now
			{ position = {0, -0.25}, color = col}, // mid
			{ position = {0, 0.5}, color = col}, // top
			{ position = {0, -0.25}, color = col}, // mid
			{ position = {0.5, -0.5}, color = col}, // br 
			{ position = {0, 0.5}, color = col}, // top

			{ position = {-0.45, -0.45}, color = black}, // bl <- vert color specified now
			{ position = {0, -0.22}, color = black}, // mid
			{ position = {0, 0.45}, color = black}, // top
			{ position = {0, -0.22}, color = black}, // mid
			{ position = {0.45, -0.45}, color = black}, // br 
			{ position = {0, 0.45}, color = black}, // top
		},
		model = p1_model
	)
}

pack_player_2 :: proc(dt: f32, cam: [2]f32) 
{
	blend_pos := [3]f32 {}
	blend_pos.xy = math.lerp(player_2.last_pos, player_2.pos, dt)
	blend_pos.z = 2

	models := [dynamic]Batch_Shape_Model{}
	defer { delete(models) }

	fill_wrap_models(
		models = &models, 
		pos = blend_pos, 
		model_scale = player_2.SCALE, 
		screen_scale = player_2.SCALE,
		rot = player_2.rot - ROTATION_OFFSET, 
		thic = 0, // not used 
		fade = 0, // not used
		period = 0,
		col = {1,1,1,1},
		cam = cam
	) 

	alpha := f32(1)
	if player_2.grace_t > 0 {
		a := player_2.grace_t / PLAYER_GRACE_FLASH_PERIOD
		if a % 2 == 0 {
			alpha = 0
		} 
	}
	col : [4]f32 = {player_2.col.r, player_2.col.g, player_2.col.b, alpha}
	black := [4]f32 {0,0,0,alpha}

	pack_batch_shape_arr(
		src_verts = {
			{ position = {-0.5, -0.25}, color = col }, // top: bl
			{ position = {0.5, -0.25}, color = col }, // top: br
			{ position = {0, 0.5}, color = col }, // top: top
			{ position = {-0.5, -0.25}, color = col }, // bottom: tl
			{ position = {-0.3, -0.5}, color = col }, // bottom: bl
			{ position = {0.5, -0.25}, color = col }, // bottom: tr
			{ position = {-0.3, -0.5}, color = col }, // bottom: bl
			{ position = {0.3, -0.5}, color = col }, // bottom: br
			{ position = {0.5, -0.25}, color = col }, // bottom: tr

			{ position = {-0.47, -0.25}, color = black }, // top: bl
			{ position = {0.47, -0.25}, color = black }, // top: br
			{ position = {0, 0.46}, color = black }, // top: top
			{ position = {-0.47, -0.25}, color = black }, // bottom: tl
			{ position = {-0.3, -0.47}, color = black }, // bottom: bl
			{ position = {0.47, -0.25}, color = black }, // bottom: tr
			{ position = {-0.3, -0.47}, color = black }, // bottom: bl
			{ position = {0.3, -0.47}, color = black }, // bottom: br
			{ position = {0.47, -0.25}, color = black }, // bottom: tr
		},
		// TODO: understand how these models don't go out of memory, 
		// b/c they are added to another dynamic array?
		src_models = models[:],
		dest_verts = &batch_shape_verts,
		dest_models = &batch_shape_models,
		dest_inputs = &batch_shape_inputs
	)
}

