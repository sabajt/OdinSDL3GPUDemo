package main

import "core:math"
import "core:math/linalg"

update_enemy_path_movement :: proc(e: ^Enemy)
{
	geo := &e.geo

	// set rotation, speed based on path type

	switch e.path_type {

		case .wavey_slowdown:
			geo.rot += math.sin(f32(e.t) / 25.0) / 90
			geo.max_speed -= math.sin(f32(e.t) / 25.0) / 10

		case .zigzag:
			if (e.t % 26) == 0 {
				geo.rot -= math.PI / 4.0
			} else if (e.t % 13) == 0 {
				geo.rot += math.PI / 4.0
			}

		case .none:
			// no modification
	}

	geo.vel = pvec(geo.rot, geo.max_speed)

	// move

	geo.last_pos = geo.pos
	// TODO: vel could be just defined in Path_Event? or set into geo (or something else) from path event?
	geo.pos += geo.vel 

	e.t += 1
	
	// thrust particles
	update_enemy_thrust_trail(geo^)
}

