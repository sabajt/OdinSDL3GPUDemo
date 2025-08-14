package main


pack_bombs_sdf :: proc(dt: f32, cam: [2]f32) 
{
	for b in bombs {

		alpha := f32(1)
		a := int(b.t / 4)
		if a % 2 == 0 {
			alpha = 0
		} 
		
		data := RenderPackData { b.rad, b.pos, b.last_pos, b.thic, b.fade, alpha }
		pack_render_data_sdf(data, dt, cam)
	}
}

