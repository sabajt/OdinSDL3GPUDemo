#+feature dynamic-literals

package main

import "core:fmt"
import "core:math"
import "core:math/rand"

// particles

LINE_WIDTH := f32(3)

Ease_Mode :: enum {
	Linear,
	Quadratic_In,
	Quadratic_Out,
	Quadratic_In_Out,
	Cubic_In,
	Cubic_Out,
	Cubic_In_Out,
	Quartic_In,
	Quartic_Out,
	Quartic_In_Out,
	Exponential_In,
	Exponential_Out,
	Exponential_In_Out,
}

Radius_Effect :: struct {
	mode: Radius_Effect_Mode,
	t_int: int, // raw t interger
	delay_onset_t: int, // t before active / rendered
	t: f32, // normalized 0-1
	last_t: f32,
	ease: Ease_Mode,
	life: f32, // approx. seconds
	res: uint,
	rad_start: f32,
	rad_end: f32,
	pos: [2]f32,
	last_pos: [2]f32,
	vel: [2]f32,
	drag: f32,
	col_start: [4]f32,
	col_end: [4]f32,
	rot_start: f32,
	rot_end: f32,
	node_rad_start: f32,
	node_rad_end: f32,
	expired: bool,
	thic: f32,
	fade: f32
}

Radius_Effect_Mode :: enum {
	Solid,
	Line,
	Circles
}

MAX_RADIUS_EFFECT_BATCH := int(100)
radius_effects := [dynamic][dynamic]Radius_Effect { [dynamic]Radius_Effect{} }
create_random_particles := false

create_random_particle :: proc(mode: Radius_Effect_Mode) -> Radius_Effect 
{
	pos := [2]f32{
		resolution.x / 2 + (2 * rand.float32() - 1) * 300, 
		resolution.y / 2 + (2 * rand.float32() - 1) * 300 
	}
	return create_random_particle_pos(mode, pos + camera.pos)
}

create_random_particle_pos :: proc(mode: Radius_Effect_Mode, pos: [2]f32) -> Radius_Effect
{
	rad_start := f32(2)
	rad_end := f32(2) + f32(rand.int_max(int(resolution.y / 2.0)))

	return create_particle_effect(
		mode = mode, 
		pos = pos,
		vel = {0, 0},
		drag = 0,
		life = 0.5 + 3.0 * rand.float32(),
		res = uint(rand.int_max(15) + 3),
		rad_start = rad_start,
		rad_end = rad_end, 
		col_start = {rand.float32(), rand.float32(), rand.float32(), 1},
		col_end = {rand.float32(), rand.float32(), rand.float32(), 0},
		rot_start = 0,
		rot_end = (2 * rand.float32() - 1.0) * math.TAU + (math.PI / 4.0),
		node_rad_start = 6,
		node_rad_end = 6,
		thic = rand.float32_range(2, rad_end),
		fade = rand.float32_range(0, 10),
	)
}

// TODO: REFACTOR 1) Modes have mode create structs to separate from common particle effect container
// TODO: REFACTOR 2) Designated inits for each type of effect

// creates particle with life starting at current sim_time
create_particle_effect :: proc(
	mode: Radius_Effect_Mode, 
	pos: [2]f32,
	vel: [2]f32,
	drag: f32,
	life: f32,
	res: uint,
	rad_start: f32,
	rad_end: f32,
	col_start: [4]f32,
	col_end: [4]f32,
	rot_start: f32,
	rot_end: f32,	
	node_rad_start : f32,
	node_rad_end : f32,
	thic : f32, 
	fade: f32,
	delay: int = 0, 
	ease: Ease_Mode = .Linear) -> Radius_Effect 
{
	return Radius_Effect {
		t_int = 0,
		delay_onset_t = delay,
		t = 0,
		last_t = 0,
		ease = ease,
		life = life,
		res = res,
		rad_start = rad_start,
		rad_end = rad_end,
		pos = pos,
		last_pos = pos,
		vel = vel,
		drag = drag,
		col_start = col_start,
		col_end = col_end,
		rot_start = rot_start,
		rot_end = rot_end,
		mode = mode,
		expired = false,
		node_rad_start = node_rad_start,
		node_rad_end = node_rad_end,
		thic = thic,
		fade = fade
	}
}
