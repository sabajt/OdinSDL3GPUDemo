package main

import sa "core:container/small_array"

Geo_Render_Mode :: enum {
	Solid,
	Line
}

Geo_Layer :: struct {
	rad: f32,
	res: uint,
	rot: f32,
	mode: Geo_Render_Mode,
	col: [4]f32
}

Geo_Collider_Type :: enum {
	Beacon,
	Enemy
}

GEO_COLLIDER_MAX_LAYERS :: int(20)

Geo_Collider :: struct {
	type: Geo_Collider_Type,
	t: f32,
	last_t: f32,
	layers: sa.Small_Array(20, Geo_Layer),
	pos: [2]f32,
	last_pos: [2]f32,
	acl_speed: f32,
	max_speed: f32,
	vel: [2]f32,
	collide_rad: f32,
	col : [3]f32,
	alpha : f32,
	rot: f32,
	last_rot: f32,
	rot_vel: f32,
	ROT_MAX_VEL: f32,
	ROT_ACL: f32
}
