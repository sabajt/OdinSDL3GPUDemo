package main

import "core:math"

pack_game_over :: proc(dt: f32, cam: [2]f32)
{
	// background

	model := create_batch_shape_model(
		pos = cam + resolution / 2.0, 
		rot = 0, 
		scale = resolution, 
		col = {0, 0, 0, 0.5}, 
		thic = 0, 
		fade = 0, 
		period = 0
	)
	pack_batch_shape_vert_ref(
 		vert_index = vert_ref_quad, 
 		count = 6, 
 		model = model
 	)

	// lines effect

	// col_var := math.sin(f32(sim_time) / 1000.0)
 	model = create_batch_shape_model(
		pos = cam + resolution / 2.0, 
		rot = 0, 
		scale = resolution, 
		col = {COL_PINKY_PINK.r, COL_PINKY_PINK.g, COL_PINKY_PINK.b, 0.15}, 
		thic = 0, 
		fade = 0, 
		period = 2
	)
	pack_batch_shape_vert_ref(
 		vert_index = vert_ref_quad, 
 		count = 6, 
 		model = model
 	)

 	// text

 	pack_text_center_x(
 		text = {"g", "a", "m", "e", " ", "o", "v", "e", "r"},
 		cam = cam, 
 		y = text_y_top()
 	)

 	pack_text_center_x(
 		text = {"p", "r", "e", "s", "s", " ", "s", "t", "a", "r", "t"},
 		cam = cam, 
 		y = text_y_top() - 100,
 		scale = {0.6, 0.6}
 	)
}

