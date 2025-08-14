package main

bullets := [dynamic]Bullet{}

Bullet :: struct {
	pos: [2]f32,
	last_pos: [2]f32,
	vel: [2]f32,
	rad: f32,
	col: [4]f32,
	last_col: [4]f32,
	t: f32,
	last_t: f32,
	life: f32,
	thic: f32,
	fade: f32,
	ease: f32, // 0-1, default 1
	fadeout_start_t: f32 // 0-1, default 0.7
}

create_bullet :: proc(pos: [2]f32, vel: [2]f32, rad: f32, col: [4]f32, life: f32, thic: f32, fade: f32, ease: f32 = 1, fadeout_start_t: f32 = 0.7) -> Bullet
{
	return Bullet {
		pos = pos,
		last_pos = pos, 
		vel = vel,
		rad = rad,
		col = col,
		t = 0,
		last_t = 0,
		life = life,
		thic = thic,
		fade = fade,
		ease = ease,
		fadeout_start_t = 0.7
	}
}

