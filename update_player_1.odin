package main

import "core:fmt"
import "core:math"
import "core:math/linalg"
import "core:math/rand"

update_player_1 :: proc() 
{
	// directional rotation

	p1_rot_acl := f32(0)

	switch player_1.rot_dir {
	case .Left:
		p1_rot_acl = player_1.ROT_ACL
	case .Right:
		p1_rot_acl = -player_1.ROT_ACL
	case .None:
	}

	player_1.rot_vel_directional += p1_rot_acl
	player_1.rot_vel_directional = clamp(player_1.rot_vel_directional, -player_1.MAX_ROT_VEL, player_1.MAX_ROT_VEL)

	if player_1.rot_vel_directional > 0 {
		player_1.rot_vel_directional = max(0, player_1.rot_vel_directional - player_1.ROT_DRAG)
	} else if player_1.rot_vel_directional < 0 {
		player_1.rot_vel_directional = min(0, player_1.rot_vel_directional + player_1.ROT_DRAG)
	}

	// analog rotation

	left_x_axis_val := abs(player_1.left_x_axis_val) > AXIS_CUTOFF ? player_1.left_x_axis_val : 0
	left_y_axis_val := abs(player_1.left_y_axis_val) > AXIS_CUTOFF ? player_1.left_y_axis_val : 0

	p1_is_rot : bool = abs(left_x_axis_val) > AXIS_CUTOFF || abs(left_y_axis_val) > AXIS_CUTOFF
	if p1_is_rot {

		ang := linalg.atan2(left_y_axis_val, left_x_axis_val)
		if ang < 0 {
			// neg val is bottom half, convert to 0...TAU going ccw
			ang = math.TAU - abs(ang)
		}

		dif : f32 = ang - player_1.rot
		spd : f32 = min(player_1.ANALOG_ROT_SPEED, abs(dif))
		mult : f32 = dif > 0 ? 1 : -1

		// flip if opposite dir is shortest path
		flip : f32 = abs(dif) < math.PI ? 1 : -1 

		player_1.rot_vel_analog = spd * mult * flip

	} else {
		player_1.rot_vel_analog = 0
	}

	// update rotation

	if player_1.rot > math.TAU { 
		player_1.rot = math.TAU - player_1.rot
	} else if player_1.rot < 0 {
		player_1.rot = math.TAU + player_1.rot
	}

	player_1.last_rot = player_1.rot
	player_1.rot += player_1.rot_vel_directional
	player_1.rot += player_1.rot_vel_analog

	// movement

	p1_acl : f32 = 0
	if player_1.is_acl {
		p1_acl = player_1.ACL
	} else if player_1.is_reverse_acl {
		p1_acl = -player_1.REVERSE_ACL
	}

	p1_facing := linalg.Vector2f32({math.cos(player_1.rot), math.sin(player_1.rot)})
	vel := p1_facing * p1_acl
	player_1.vel += vel

	if player_1.is_dcl && linalg.length(player_1.vel) > 0 {
		player_1.vel *= player_1.DCL
		if linalg.length(player_1.vel) < 0.1 {
			player_1.is_dcl = false
			player_1.is_reverse_acl = true
		}
	} else {
		player_1.is_dcl = false
	}

	player_1.vel = linalg.clamp_length(player_1.vel, player_1.MAX_SPEED)

	player_1.last_pos = player_1.pos
	player_1.pos += player_1.vel

	// thrust trail particles

	if player_1.is_acl {
		update_player_1_thrust_trail()
	} else if player_1.is_reverse_acl {
		update_player_1_reverse_thrust_trail()
	} else if player_1.is_dcl {
		update_player_1_dcl_thrust_trail()
	}

	// shoot

	if player_1.shoot_cool_time > 0 {
		player_1.shoot_cool_time -= 1
		player_1.shoot = false

	} else if player_1.shoot {
		player_1.shoot = false
		player_1.shoot_cool_time = player_1.SHOOT_COOL_DUR

		shoot_dir : [2]f32 = {
			math.cos(player_1.rot), 
			math.sin(player_1.rot)
		}

		bullet := create_bullet(
			pos = player_1.pos,
			vel = player_1.shoot_speed * shoot_dir + player_1.vel,
			rad = 12, 
			col = {player_1.col.r, player_1.col.g, player_1.col.b, 1},
			life = 30,
			thic = 12 + 4,
			fade = 4,
			ease = 0.99
		)
		append(&bullets, bullet)
	}

	// update grace period
	if player_1.grace_t > 0 {
		player_1.grace_t -= 1
	}
}

update_player_1_thrust_trail :: proc()
{
	update_player_thrust_trail(
		pos = player_1.pos,
		player_vel = player_1.vel,
		speed = 4.0,
		vel_mult_low = 2,
		vel_mult_high = 3.5,
		rot = player_1.rot,
		col = player_1.col.rgb,
		ang_range = 0.7,
		drag = 0.4,
		x_pos_range = {-10, 10},
		y_pos_range = {-10, 10}
	)
}

update_player_1_reverse_thrust_trail :: proc()
{
	ANG_DELTA := f32(math.PI / 4.0) 
	SPEED := f32(3.5)
	ANG_RANG := f32(0.3)
	DRAG := f32(0.5)
	POS_RANGE := f32(5)

	if sim_time % (MS_PER_UPDATE * 2) == 0 {
		forward_right_ang := player_1.rot - math.PI - ANG_DELTA
		update_player_thrust_trail(
			pos = player_1.pos,
			player_vel = player_1.vel,
			speed = SPEED,
			vel_mult_low = 2,
			vel_mult_high = 3.5,
			rot = forward_right_ang,
			col = player_1.col.rgb,
			ang_range = ANG_RANG,
			drag = DRAG,
			x_pos_range = {-POS_RANGE, POS_RANGE},
			y_pos_range = {-POS_RANGE, POS_RANGE}
		)
	} else {
		forward_left_ang := player_1.rot - math.PI + ANG_DELTA
		update_player_thrust_trail(
			pos = player_1.pos,
			player_vel = player_1.vel,
			speed = SPEED,
			vel_mult_low = 2,
			vel_mult_high = 3.5,
			rot = forward_left_ang,
			col = player_1.col.rgb,
			ang_range = ANG_RANG,
			drag = DRAG,
			x_pos_range = {-POS_RANGE, POS_RANGE},
			y_pos_range = {-POS_RANGE, POS_RANGE}
		)
	}
}

cur_player_1_dcl_particle_ang := int(0)
player_1_dcl_particle_angles := [4]f32 { 
	player_1.rot + math.PI / 4.0,
	player_1.rot - math.PI / 4.0,
	player_1.rot + math.PI + math.PI / 4.0,
	player_1.rot + math.PI - math.PI / 4.0
}
update_player_1_dcl_thrust_trail :: proc()
{
	SPEED := f32(3.5)
	ANG_RANG := f32(0.3)
	DRAG := f32(0.5)
	POS_RANGE := f32(5)

	ang := player_1_dcl_particle_angles[cur_player_1_dcl_particle_ang]
	cur_player_1_dcl_particle_ang += 1
	if cur_player_1_dcl_particle_ang >= len(player_1_dcl_particle_angles) {
		cur_player_1_dcl_particle_ang = 0
	}

	update_player_thrust_trail(
		pos = player_1.pos,
		player_vel = player_1.vel,
		speed = SPEED,
		vel_mult_low = 2,
		vel_mult_high = 3.5,
		rot = ang,
		col = player_1.col.rgb,
		ang_range = ANG_RANG,
		drag = DRAG,
		x_pos_range = {-POS_RANGE, POS_RANGE},
		y_pos_range = {-POS_RANGE, POS_RANGE}
	)
}

update_player_1_dead :: proc() 
{
	if player_1.dead_time > PLAYER_RESPAWN_RATE {
		// Respawn player 1

		player_1.is_spawning_in = false
		player_1.dead_time = 0
		player_1.is_alive = true
		player_1.pos = player_1.next_spawn_pos
		player_1.last_pos = player_1.pos 
		player_1.rot = ROTATION_OFFSET
		player_1.vel = 0
		player_1.grace_t = PLAYER_GRACE_DUR
	} else {
		if !player_1.is_spawning_in && (player_1.dead_time > PLAYER_RESPAWN_RATE - PLAYER_IN_TIME) {
			player_1.is_spawning_in = true
			player_1.next_spawn_pos = find_player_respawn_pos(.one)

			create_player_warp_in_effect(player_1)
		}

		player_1.dead_time += 1
	}
}

