package main

import "core:math"
import "core:fmt"

pack_bullets_sdf :: proc(dt: f32, cam: [2]f32) 
{
	for b in bullets {
		data := RenderPackData { b.rad, b.pos, b.last_pos, b.thic, b.fade, b.col }
		pack_render_data_sdf(data, dt, cam)
	}
}

