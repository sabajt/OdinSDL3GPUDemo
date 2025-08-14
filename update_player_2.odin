package main

import "core:fmt"
import "core:math"
import "core:math/linalg"
import "core:math/rand"

update_player_2 :: proc()
{
	// analog rotation

	left_x_axis_val := abs(player_2.left_x_axis_val) > AXIS_CUTOFF ? player_2.left_x_axis_val : 0
	left_y_axis_val := abs(player_2.left_y_axis_val) > AXIS_CUTOFF ? player_2.left_y_axis_val : 0

	is_rot : bool = abs(left_x_axis_val) > AXIS_CUTOFF || abs(left_y_axis_val) > AXIS_CUTOFF
	if is_rot {
		ang := linalg.atan2(left_y_axis_val, left_x_axis_val)
		if ang < 0 {
			// neg val is bottom half, convert to 0...TAU going ccw
			ang = math.TAU - abs(ang)
		}

		dif : f32 = ang - player_2.rot
		spd : f32 = min(player_2.ANALOG_ROT_SPEED, abs(dif))
		mult : f32 = dif > 0 ? 1 : -1

		// flip if opposite dir is shortest path
		flip : f32 = abs(dif) < math.PI ? 1 : -1 

		player_2.rot_vel_analog = spd * mult * flip

	} else {
		player_2.rot_vel_analog = 0
	}

	// update rotation

	if player_2.rot > math.TAU { 
		player_2.rot = math.TAU - player_2.rot
	} else if player_2.rot < 0 {
		player_2.rot = math.TAU + player_2.rot
	}

	player_2.last_rot = player_2.rot
	player_2.rot += player_2.rot_vel_analog

	// movement: directly assign vel to stick % (no acl)

	if is_rot {
		rot_intent := [2]f32{left_x_axis_val, left_y_axis_val}
		player_2.vel = (rot_intent * player_2.MAX_SPEED)
	} else {
		player_2.vel *= player_2.DCL
	}

	player_2.last_pos = player_2.pos
	player_2.pos += player_2.vel

	// thrust trail particles
	if is_rot {
		update_player_2_thrust_trail()
	}

	// drop or explode remote bomb

	if player_2.shoot_cool_time > 0 {
		// detonate bomb
		if player_2.detonate {
			player_2.shoot_cool_time = 0
			for &b in bombs {
				b.detonate = true
			}
		}

	} else if player_2.shoot {
		player_2.shoot_cool_time = player_2.SHOOT_COOL_DUR

		behind : [2]f32 = {
			-math.cos(player_2.rot), 
			-math.sin(player_2.rot)
		}

		bomb := create_player_2_bomb()
		append(&bombs, bomb)
	}
	player_2.shoot = false
	player_2.detonate = false

	// update grace period
	if player_2.grace_t > 0 {
		player_2.grace_t -= 1
	}
}

update_player_2_thrust_trail :: proc()
{
	r := linalg.atan2(player_2.vel.y, player_2.vel.x) 

	update_player_thrust_trail(
		pos = player_2.pos,
		player_vel = player_2.vel,
		speed = 8.0,
		vel_mult_low = 1,
		vel_mult_high = 2,
		rot = r,
		col = player_2.col.rgb,
		ang_range = 0.1,
		drag = 0.3,
		x_pos_range = {-5, 5},
		y_pos_range = {-5, 5}
	)
}

update_player_2_dead :: proc() 
{
	if player_2.dead_time > PLAYER_RESPAWN_RATE {
		// Respawn player 2

		player_2.is_spawning_in = false
		player_2.dead_time = 0
		player_2.is_alive = true
		player_2.pos = player_2.next_spawn_pos
		player_2.last_pos = player_2.pos 
		player_2.rot = ROTATION_OFFSET
		player_2.vel = 0
		player_2.detonate = false
		player_2.shoot = false
		player_2.shoot_cool_time = 0
		player_2.grace_t = PLAYER_GRACE_DUR
	} else {
		// detonate any lingering bombs
		for &b in bombs {
			b.detonate = true
		}

		if !player_2.is_spawning_in && (player_2.dead_time > PLAYER_RESPAWN_RATE - PLAYER_IN_TIME) { // TODO: embed respawn rate?
			player_2.is_spawning_in = true
			player_2.next_spawn_pos = find_player_respawn_pos(.two)

			create_player_warp_in_effect(player_2)
		}

		player_2.dead_time += 1
	}
}

