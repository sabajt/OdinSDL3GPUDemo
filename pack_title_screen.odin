package main

import "core:fmt"

text_y_top :: proc() -> f32
{
	return resolution.y - 280
}

pack_title_screen :: proc(dt: f32, cam: [2]f32)
{
 	// text

 	pack_text_center_x(
 		text = {"z", "a", "p", " ", "a", "n", "d", " ", "z", "i", "p"},
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

