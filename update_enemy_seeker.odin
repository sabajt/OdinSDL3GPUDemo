package main

import "core:math"
import "core:math/linalg"

update_enemy_seeker_movement :: proc(e: ^Enemy)
{
	geo := &e.geo

	// decide where to move

	path: [2]f32
	if e.seek_i == 0 {
		path = player_1.pos - geo.pos
	} else {
		path = player_2.pos - geo.pos
	}

	dir_to_player : [2]f32 = {0, 0}
	if linalg.dot(path, path) > 0 {
		dir_to_player = linalg.normalize(path)
	}

	ang := linalg.atan2(dir_to_player.y, dir_to_player.x)
	if ang < 0 {
		// neg val is bottom half, convert to 0...TAU going ccw
		ang = math.TAU - abs(ang)
	}

	dif : f32 = ang - geo.rot	
	if dif != 0 {
		mult : f32 = dif > 0 ? 1 : -1

		// flip if opposite dir is shortest path
		flip : f32 = abs(dif) < math.PI ? 1 : -1 
		geo.rot_vel += geo.ROT_ACL * mult * flip

		// max rotation speed
		if abs(geo.rot_vel) > geo.ROT_MAX_VEL {
			geo.rot_vel = geo.ROT_MAX_VEL  * mult * flip
		}

	} else {
		geo.rot_vel = 0
	}

	// update rotation

	if geo.rot > math.TAU { 
		geo.rot = math.TAU - geo.rot
	} else if geo.rot < 0 {
		geo.rot = math.TAU + geo.rot
	}

	geo.last_rot = geo.rot
	geo.rot += geo.rot_vel

	// vel

	facing := [2]f32 {math.cos(geo.rot), math.sin(geo.rot)}

	geo.vel += facing * geo.acl_speed
	if linalg.length(geo.vel) > geo.max_speed {
		geo.vel = facing * geo.max_speed
	}

	// move

	geo.last_pos = geo.pos
	geo.pos += geo.vel

	// thrust particles
	update_enemy_thrust_trail(geo^)
}

