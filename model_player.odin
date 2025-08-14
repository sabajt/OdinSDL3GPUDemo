package main

import "core:math/linalg"

PLAYER_1_MAX_SPEED := f32(6)
PLAYER_1_REVERSE_MAX_SPEED := f32(4)
PLAYER_GRACE_DUR := int(60 * 2.5)
PLAYER_GRACE_FLASH_PERIOD := int(3)
PLAYER_RESPAWN_RATE := u64(60 * 21)
PLAYER_IN_TIME := u64(60) // TODO: change so it's not this minus the thing above for timing?

Rotate_Dir :: enum {
	None,
	Left,
	Right
}

Player_Number :: enum {
	one,
	two
}

Player :: struct {
	// transform
	pos: [2]f32,
	last_pos: [2]f32,

	// scale
	SCALE: [2]f32,

	// rotation
	rot: f32,
	last_rot: f32,

	// analog rotation
	ANALOG_ROT_SPEED: f32,
	left_x_axis_val: f32,
	left_y_axis_val: f32,
	is_rot: bool,
	rot_vel_analog: f32,

	// right analog values
	right_x_axis_val: f32,
	right_y_axis_val: f32,

	// directional rotation
	ROT_ACL: f32,
	MAX_ROT_VEL: f32,
	ROT_DRAG: f32,

	rot_dir: Rotate_Dir,
	rot_vel_directional: f32,

	// dynamic movement
	ACL: f32,
	REVERSE_ACL: f32,
	DCL: f32,
	MAX_SPEED: f32,
	REVERSE_MAX_SPEED: f32,
	is_acl: bool,
	is_reverse_acl: bool,
	is_dcl: bool,
	vel: [2]f32,

	// color
	col: [3]f32,

	// collision 
	COLLIDE_RAD: f32,

	// state
	is_alive: bool,
	dead_time: u64,
	is_spawning_in: bool,
	next_spawn_pos: [2]f32,

	// shoot
	SHOOT_COOL_DUR: u64,
	shoot_speed: f32,
	shoot: bool,
	shoot_cool_time: u64,

	// bomb (player 2 only)
	detonate: bool,

	// invincible period on respawn
	grace_t: int
}

player_1 := Player {
	// transform
	pos = resolution / 2.0,
	last_pos = resolution / 2.0,

	// scale
	SCALE = {100, 100},

	// rotation
	rot = ROTATION_OFFSET,
	last_rot = ROTATION_OFFSET,

	// analog rotation
	ANALOG_ROT_SPEED = 0.3,
	left_x_axis_val = 0,
	left_y_axis_val = 0,
	is_rot = false,
	rot_vel_analog = 0,

	// directional rotation
	ROT_ACL = 0.02,
	MAX_ROT_VEL = 0.15,
	ROT_DRAG = 0.01,

	rot_dir = .None,
	rot_vel_directional = 0,

	// movement
	ACL = 0.15,
	REVERSE_ACL = 0.1,
	DCL = 0.85,
	MAX_SPEED = PLAYER_1_MAX_SPEED,
	REVERSE_MAX_SPEED = PLAYER_1_REVERSE_MAX_SPEED,
	is_acl = false,
	is_reverse_acl = false,
	is_dcl = false,
	vel = {0, 0},

	// color
	col = {1, 1, 1},

	// collision 
	COLLIDE_RAD = 20,

	// state
	is_alive = true,
	dead_time = 0,
	is_spawning_in = false,
	next_spawn_pos = {0, 0},

	// shoot
	SHOOT_COOL_DUR = 15,
	shoot_speed = 25,
	shoot = false,
	shoot_cool_time = 0,

	// bomb (not used)
	detonate = false,

	// invincible period on respawn
	grace_t = 0
}

player_2 := Player {
	// transform
	pos = player_1.pos - {200, 0},
	last_pos = player_1.pos - {200, 0},

	// scale
	SCALE = {100, 100},

	// rotation
	rot = ROTATION_OFFSET,
	last_rot = ROTATION_OFFSET,

	// analog rotation
	ANALOG_ROT_SPEED = 0.3,
	left_x_axis_val = 0,
	left_y_axis_val = 0,
	is_rot = false,
	rot_vel_analog = 0,

	// directional rotation (not using)
	ROT_ACL = 0,
	MAX_ROT_VEL = 0,
	ROT_DRAG = 0,

	rot_dir = .None,
	rot_vel_directional = 0,

	// movement
	ACL = 0, // doesn't use acl: directly mapped to analog stick %
	REVERSE_ACL = 0, // not used
	DCL = 0.62, // used as a multiplier on velocity for slowdown
	MAX_SPEED = 15,
	REVERSE_MAX_SPEED = 0, // not used
	is_acl = false,
	is_reverse_acl = false,
	is_dcl = false,
	vel = {0, 0},

	// color
	col = {1, 1, 1},

	// collision 
	COLLIDE_RAD = 20,

	// state
	is_alive = true,
	dead_time = 0,
	is_spawning_in = false,
	next_spawn_pos = {0, 0},

	// shoot
	SHOOT_COOL_DUR = 1, // used as true / false for bomb
	shoot_speed = 6,
	shoot = false,
	shoot_cool_time = 0, // used as true / false for bomb

	// bomb 
	detonate = false,

	// invincible period on respawn
	grace_t = 0
}
