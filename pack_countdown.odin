package main

import "core:fmt"
import "core:math"

pack_countdown :: proc(dt: f32, cam: [2]f32)
{
	life := f32(PLAYER_RESPAWN_RATE - PLAYER_IN_TIME)
	dead_time := f32(player_1.is_alive ? player_2.dead_time : player_1.dead_time)

	life_seconds := math.ceil(life / 60)
	elapsed_seconds := math.floor(dead_time / 60)
	seconds := life_seconds - elapsed_seconds
	seconds_str := fmt.tprint(seconds)

	text := [dynamic]string {}
	for r, i in seconds_str {
		append(&text, fmt.tprint(r))
	}

 	pack_text_center_x(
 		text = text[:], 
 		cam = cam,
 		y = text_y_top()
 	)
 	delete(text)
}



