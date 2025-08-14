package main

import "core:math"

Bomb :: struct {
	pos: [2]f32,
	last_pos: [2]f32,
	vel: [2]f32, 
	rad: f32,
	col: [4]f32,
	t: f32,
	last_t: f32,
	detonate: bool,
	thic: f32,
	fade: f32,
	ACL: f32, 
	DRAG: f32,
	MAX_SPEED: f32
}

bombs := [dynamic]Bomb{}

create_player_2_bomb :: proc() -> Bomb
{
	behind := [2]f32 {
		-math.cos(player_2.rot), 
		-math.sin(player_2.rot)
	}
	bomb_pos := player_2.pos + 80 * behind
	return Bomb {
		pos = bomb_pos,
		last_pos = bomb_pos,
		vel = 0.3 * behind, 
		rad = 30,
		col = {1,1,1,1},
		t = 0,
		last_t = 0,
		detonate = false,
		thic = 32,
		fade = 12,
		ACL = 3, //5
		DRAG = 0.1, //2
		MAX_SPEED = 8.5 //20
	}
}
