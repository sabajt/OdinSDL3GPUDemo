package main

import "core:fmt"
import "core:math"

pack_pause_menu :: proc(dt: f32, cam: [2]f32)
{
	// background

	model := create_batch_shape_model(
		pos = cam + resolution / 2.0, 
		rot = 0, 
		scale = resolution, 
		col = {0, 0, 0, 0.7}, 
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

 	model = create_batch_shape_model(
		pos = cam + resolution / 2.0, 
		rot = 0, 
		scale = resolution, 
		col = {COL_BLUE_RASP.r, COL_BLUE_RASP.g, COL_BLUE_RASP.b, 0.2}, 
		thic = 0, 
		fade = 0, 
		period = 2
	)
	pack_batch_shape_vert_ref(
 		vert_index = vert_ref_quad, 
 		count = 6, 
 		model = model
 	)

	// menu slots

	CURSOR_SCALE := f32(60)
 	slot_0 := text_y_top()
	slot_1 := text_y_top() - 100

 	// cursor

	cursor_x := resolution.x / 2.0 - 270
 	cursor_y := pause_menu_option == .resume ? slot_0 : slot_1
 	cursor_y += CURSOR_SCALE / 2.0

 	model = create_batch_shape_model(
		pos = cam + {
			cursor_x,
			cursor_y
		}, 
		rot = -math.PI / 2, 
		scale = {CURSOR_SCALE, CURSOR_SCALE}, 
		col = {1, 1, 1, 1}, 
		thic = 0, 
		fade = 0, 
		period = 0
	)
	pack_batch_shape_vert_ref(
 		vert_index = vert_ref_tri, 
 		count = 3, 
 		model = model
 	)

 	// text

 	pack_text(
 		text = {"r", "e", "s", "u", "m", "e"}, 
 		pos = cam + {cursor_x + CURSOR_SCALE, slot_0}
 	)

 	pack_text(
 		text = {"m", "e", "n", "u"}, 
 		pos = cam + {cursor_x + CURSOR_SCALE, slot_1}
 	)
}

