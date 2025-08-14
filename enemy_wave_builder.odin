package main

import "core:math/rand"
import "core:math"
import "core:fmt"

create_enemy_wave_0 :: proc()
{
	create_enemy_wave_seeker(
		rest = 5,
		positions = {
			camera.pos + {resolution.x / 4, resolution.y * 3.0 / 4.0},
			camera.pos + {resolution.x * 3.0 / 4.0, resolution.y / 4}
		},
		col = COL_OOZE_GREEN,
		base_rad = 75,
		res = 5,
		acl_speed = 0.02,
		max_speed = 1.5,
		rot_acl = 0.0002,
		rot_max_vel = 0.01
	)
}

create_enemy_wave_1 :: proc()
{
	create_enemy_wave_seeker(
		rest = 4.6,
		positions = {
			camera.pos + {resolution.x / 4, resolution.y / 4},
			camera.pos + {resolution.x / 4, resolution.y * 3.0 / 4.0},
			camera.pos + {resolution.x * 3.0 / 4.0, resolution.y / 4},
			camera.pos + {resolution.x * 3.0 / 4.0, resolution.y * 3.0 / 4.0},
		},
		col = COL_PANIC_RED,
		base_rad = 75,
		res = 3,
		acl_speed = 0.015,
		max_speed = 2.5,
		rot_acl = 0.0004,
		rot_max_vel = 0.03
	)
}

create_enemy_wave_2 :: proc()
{
	create_enemy_wave_seeker(
		rest = 4.7,
		positions = {
			camera.pos + {1.0 * resolution.x / 6.0, resolution.y / 4.0},
			camera.pos + {2.0 * resolution.x / 6.0, resolution.y * 3.0 / 4.0},
			camera.pos + {3.0 * resolution.x / 6.0, resolution.y / 4.0},
			camera.pos + {4.0 * resolution.x / 6.0, resolution.y * 3.0 / 4.0},
			camera.pos + {5.0 * resolution.x / 6.0, resolution.y / 4.0},
			camera.pos + {6.0 * resolution.x / 6.0, resolution.y * 3.0 / 4.0},
		},
		col = COL_WARNING_YELLOW,
		base_rad = 69,
		res = 5,
		acl_speed = 0.03,
		max_speed = 3.5,
		rot_acl = 0.0009,
		rot_max_vel = 0.04
	)
}

create_enemy_wave_3 :: proc()
{
	create_enemy_wave_seeker(
		rest = 2.9,
		positions = {
			camera.pos + {1.0 * resolution.x / 6.0, resolution.y / 4.0},
			camera.pos + {2.0 * resolution.x / 6.0, resolution.y * 3.0 / 4.0},
			camera.pos + {3.0 * resolution.x / 6.0, resolution.y / 4.0},
			camera.pos + {4.0 * resolution.x / 6.0, resolution.y * 3.0 / 4.0},
			camera.pos + {5.0 * resolution.x / 6.0, resolution.y / 4.0},
			camera.pos + {6.0 * resolution.x / 6.0, resolution.y * 3.0 / 4.0},
		},
		col = COL_ICY_BLUE,
		base_rad = 95,
		res = 4,
		acl_speed = 0.04,
		max_speed = 4.5,
		rot_acl = 0.0009,
		rot_max_vel = 0.04
	)
}

create_enemy_wave_4 :: proc()
{
	data: []Enemy_Wave_Path_Data = {
		{
			pos = camera.pos + {resolution.x / 4, resolution.y / 2},
			rot = math.PI / 2.0,
			speed = 10
		},
		{
			pos = camera.pos + {3 * resolution.x / 4, resolution.y / 2},
			rot = -math.PI / 2.0,
			speed = 10
		},
		{
			pos = camera.pos + {resolution.x / 2, resolution.y / 4},
			rot = math.PI,
			speed = 10
		},
		{
			pos = camera.pos + {resolution.x / 2, 3 * resolution.y / 4},
			rot = 0,
			speed = 10
		}
	}
	create_enemy_wave_path(
		rest = 6,
		data = data,
		col = COL_FRESH_ORANGE,
		base_rad = 60,
		res = 3,
		path_type = .none
	)
}

create_enemy_wave_5 :: proc()
{
	create_enemy_wave_seeker(
		rest = 3.5,
		positions = {
			camera.pos + {1.0 * resolution.x / 6.0, resolution.y / 4.0},
			camera.pos + {2.0 * resolution.x / 6.0, resolution.y * 3.0 / 4.0},
			camera.pos + {3.0 * resolution.x / 6.0, resolution.y / 4.0},
			camera.pos + {4.0 * resolution.x / 6.0, resolution.y * 3.0 / 4.0},
			camera.pos + {5.0 * resolution.x / 6.0, resolution.y / 4.0},
			camera.pos + {6.0 * resolution.x / 6.0, resolution.y * 3.0 / 4.0},
		},
		col = COL_PINKY_PINK,
		base_rad = 35,
		res = 8,
		acl_speed = 0.06,
		max_speed = 5.5,
		rot_acl = 0.002,
		rot_max_vel = 0.05
	)
}

create_enemy_wave_6 :: proc()
{
	data: []Enemy_Wave_Path_Data = {
		{
			pos = camera.pos + {resolution.x / 4, 3 * resolution.y / 4},
			rot = math.PI / 4.0,
			speed = 13
		},
		{
			pos = camera.pos + {3 * resolution.x / 4, resolution.y / 4},
			rot = -math.PI / 4.0,
			speed = 13
		},
		{
			pos = camera.pos + {3 * resolution.x / 4, 3 * resolution.y / 4},
			rot = 3 * math.PI / 4.0,
			speed = 13
		},
		{
			pos = camera.pos + {resolution.x / 4, resolution.y / 4},
			rot = 3 * -math.PI / 4.0,
			speed = 13
		},
	}
	create_enemy_wave_path(
		rest = 3.3,
		data = data,
		col = COL_BLUE_RASP,
		base_rad = 80,
		res = 5,
		path_type = .none
	)
}

create_enemy_wave_7 :: proc()
{
	create_enemy_wave_seeker(
		rest = 2.5,
		positions = {
			camera.pos + {rand.float32() * resolution.x, rand.float32() * resolution.y},
			camera.pos + {rand.float32() * resolution.x, rand.float32() * resolution.y},
			camera.pos + {rand.float32() * resolution.x, rand.float32() * resolution.y},
		},
		col = COL_WARNING_YELLOW,
		base_rad = 55,
		res = 4,
		acl_speed = 0.065,
		max_speed = 5.8,
		rot_acl = 0.004,
		rot_max_vel = 0.06
	)
}

create_enemy_wave_8 :: proc()
{
	data: []Enemy_Wave_Path_Data = {
		{
			pos = rand_screen_vec(),
			rot = rand_rot(),
			speed = 9
		},
		{
			pos = rand_screen_vec(),
			rot = rand_rot(),
			speed = 9
		},
		{
			pos = rand_screen_vec(),
			rot = rand_rot(),
			speed = 9
		},
		{
			pos = rand_screen_vec(),
			rot = rand_rot(),
			speed = 9
		},
		{
			pos = rand_screen_vec(),
			rot = rand_rot(),
			speed = 9
		},
	}
	create_enemy_wave_path(
		rest = 4.1,
		data = data,
		col = COL_DANGER_PURP,
		base_rad = 48,
		res = 4,
		path_type = .wavey_slowdown
	)
}

create_enemy_wave_9 :: proc()
{
	create_enemy_wave_seeker(
		rest = 3.7,
		positions = {
			camera.pos + {rand.float32() * resolution.x, rand.float32() * resolution.y},
			camera.pos + {rand.float32() * resolution.x, rand.float32() * resolution.y},
			camera.pos + {rand.float32() * resolution.x, rand.float32() * resolution.y},
			camera.pos + {rand.float32() * resolution.x, rand.float32() * resolution.y},
			camera.pos + {rand.float32() * resolution.x, rand.float32() * resolution.y},
			camera.pos + {rand.float32() * resolution.x, rand.float32() * resolution.y},
		},
		col = COL_OOZE_GREEN,
		base_rad = 42,
		res = 5,
		acl_speed = 0.07,
		max_speed = 7.5,
		rot_acl = 0.001,
		rot_max_vel = 0.01
	)
}

create_enemy_wave_10 :: proc()
{
	create_enemy_wave_seeker(
		rest = 6.1,
		positions = {
			camera.pos + {rand.float32() * resolution.x, rand.float32() * resolution.y},
			camera.pos + {rand.float32() * resolution.x, rand.float32() * resolution.y},
			camera.pos + {rand.float32() * resolution.x, rand.float32() * resolution.y},
			camera.pos + {rand.float32() * resolution.x, rand.float32() * resolution.y},
			camera.pos + {rand.float32() * resolution.x, rand.float32() * resolution.y},
		},
		col = COL_ICY_BLUE,
		base_rad = 150,
		res = 3,
		acl_speed = 0.04,
		max_speed = 9.5,
		rot_acl = 0.003,
		rot_max_vel = 0.04,
		layer_count = 6,
		layer_delay = 15
	)
}

create_enemy_wave_11 :: proc()
{
	data: []Enemy_Wave_Path_Data = {
		{
			pos = rand_screen_vec(),
			rot = rand_rot(),
			speed = 10
		},
		{
			pos = rand_screen_vec(),
			rot = rand_rot(),
			speed = 10
		},
		{
			pos = rand_screen_vec(),
			rot = rand_rot(),
			speed = 10
		},
		{
			pos = rand_screen_vec(),
			rot = rand_rot(),
			speed = 10
		},
	}
	create_enemy_wave_path(
		rest = 1.2,
		data = data,
		col = COL_PANIC_RED,
		base_rad = 45,
		res = 8,
		path_type = .zigzag
	)
}

create_enemy_wave_12 :: proc() // hard
{
	data: []Enemy_Wave_Path_Data = {
		{
			pos = rand_screen_vec(),
			rot = rand_rot(),
			speed = 4
		},
		{
			pos = rand_screen_vec(),
			rot = rand_rot(),
			speed = 4
		},
		{
			pos = rand_screen_vec(),
			rot = rand_rot(),
			speed = 4
		},
	}
	create_enemy_wave_path(
		rest = 4.1,
		data = data,
		col = COL_WARNING_YELLOW,
		base_rad = 225,
		res = 10,
		path_type = .wavey_slowdown
	)
}

create_enemy_wave_13 :: proc()
{
	step := f32(200)
	top := resolution.y - step
	data: []Enemy_Wave_Path_Data = {

		// bottom
		{
			pos = camera.pos + {
				step, 
				step
			},
			rot = math.PI / 2.0,
			speed = 13
		},
		{
			pos = camera.pos + {
				2 * step, 
				step
			},
			rot = math.PI / 2.0,
			speed = 13
		},
		{
			pos = camera.pos + {
				3 * step, 
				step
			},
			rot = math.PI / 2.0,
			speed = 13
		},
		{
			pos = camera.pos + {
				4 * step, 
				step
			},
			rot = math.PI / 2.0,
			speed = 13
		},

		// top
		{
			pos = camera.pos + {
				resolution.x - step, 
				top
			},
			rot = -math.PI / 2.0,
			speed = 13
		},
		{
			pos = camera.pos + {
				resolution.x - 2 * step, 
				top
			},
			rot = -math.PI / 2.0,
			speed = 13
		},
		{
			pos = camera.pos + {
				resolution.x - 3 * step, 
				top
			},
			rot = -math.PI / 2.0,
			speed = 13
		},
		{
			pos = camera.pos + {
				resolution.x - 4 * step, 
				top
			},
			rot = -math.PI / 2.0,
			speed = 13
		},
	}
	create_enemy_wave_path(
		rest = 1,
		data = data,
		col = COL_ICY_BLUE,
		base_rad = 40,
		res = 3,
		path_type = .none
	)
}

create_enemy_wave_14 :: proc()
{
	step := f32(300)
	right := resolution.x - step
	data: []Enemy_Wave_Path_Data = {

		// left
		{
			pos = camera.pos + {
				step, 
				step
			},
			rot = 0,
			speed = 13
		},
		{
			pos = camera.pos + {
				step,
				2 * step, 
			},
			rot = 0,
			speed = 13
		},
		{
			pos = camera.pos + {
				step,
				3 * step, 
			},
			rot = 0,
			speed = 13
		},

		// right
		{
			pos = camera.pos + {
				right, 
				resolution.x - step
			},
			rot = math.PI,
			speed = 13
		},
		{
			pos = camera.pos + {
				right,
				resolution.x - 2 * step, 
			},
			rot = math.PI,
			speed = 13
		},
		{
			pos = camera.pos + {
				right,
				resolution.x - 3 * step, 
			},
			rot = math.PI,
			speed = 13
		},
	}
	create_enemy_wave_path(
		rest = 1,
		data = data,
		col = COL_WARNING_YELLOW,
		base_rad = 40,
		res = 3,
		path_type = .none
	)
}

create_enemy_wave_15 :: proc()
{
	create_enemy_wave_seeker(
		rest = 5,
		positions = {
			camera.pos + {rand.float32() * resolution.x, rand.float32() * resolution.y},
			camera.pos + {rand.float32() * resolution.x, rand.float32() * resolution.y},
			camera.pos + {rand.float32() * resolution.x, rand.float32() * resolution.y},
			camera.pos + {rand.float32() * resolution.x, rand.float32() * resolution.y},
			camera.pos + {rand.float32() * resolution.x, rand.float32() * resolution.y},
			camera.pos + {rand.float32() * resolution.x, rand.float32() * resolution.y},
			camera.pos + {rand.float32() * resolution.x, rand.float32() * resolution.y},
			camera.pos + {rand.float32() * resolution.x, rand.float32() * resolution.y},
		},
		col = COL_BLUE_RASP,
		base_rad = 140,
		res = 6,
		acl_speed = 0.05,
		max_speed = 7.5,
		rot_acl = 0.002,
		rot_max_vel = 0.03
	)
}

create_enemy_wave_16 :: proc()
{
	data: []Enemy_Wave_Path_Data = {
		{
			pos = rand_screen_vec(),
			rot = rand_rot(),
			speed = 2
		},
		{
			pos = rand_screen_vec(),
			rot = rand_rot(),
			speed = 3
		},
		{
			pos = rand_screen_vec(),
			rot = rand_rot(),
			speed = 4
		},
		{
			pos = rand_screen_vec(),
			rot = rand_rot(),
			speed = 5
		},
		{
			pos = rand_screen_vec(),
			rot = rand_rot(),
			speed = 7
		},
		{
			pos = rand_screen_vec(),
			rot = rand_rot(),
			speed = 8
		},
		{
			pos = rand_screen_vec(),
			rot = rand_rot(),
			speed = 9
		},
		{
			pos = rand_screen_vec(),
			rot = rand_rot(),
			speed = 10
		},
	}
	create_enemy_wave_path(
		rest = 3.2,
		data = data,
		col = COL_DANGER_PURP,
		base_rad = 40,
		res = 8,
		path_type = .zigzag
	)
}

create_enemy_wave_17 :: proc()
{
	data: []Enemy_Wave_Path_Data = {
		{
			pos = camera.pos + resolution / 2,
			rot = rand_rot(),
			speed = rand.float32() * 1.5
		},
	}
	create_enemy_wave_path(
		rest = 1,
		data = data,
		col = COL_PANIC_RED,
		base_rad = 400,
		res = 30,
		path_type = .none
	)
}

create_enemy_wave_18 :: proc()
{
	data: []Enemy_Wave_Path_Data = {
		{
			pos = camera.pos,
			rot = rand_rot(),
			speed = 0
		},
	}
	create_enemy_wave_path(
		rest = 1,
		data = data,
		col = COL_PINKY_PINK,
		base_rad = 470,
		res = 40,
		path_type = .none
	)
}

create_enemy_wave_19 :: proc()
{
	fmt.println("gj you win")
}






