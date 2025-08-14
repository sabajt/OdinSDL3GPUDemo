package main

Camera :: struct {
	ACL: f32,
	MAX_SPEED: f32,
	speed: f32,
	pos: [2]f32,
	last_pos: [2]f32,
}

camera := Camera {
	ACL = 0.1,
	MAX_SPEED = 2.0 * PLAYER_1_MAX_SPEED,
	speed = 0,
	pos = {0, 0},
	last_pos = {0, 0},
}

