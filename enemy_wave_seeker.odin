package main

import "core:math/rand"
import "core:container/small_array"

create_enemy_wave_seeker :: proc(
	rest: f32, 
	positions: [][2]f32, 
	col: [4]f32, 
	base_rad: f32, 
	res: int, 
	acl_speed: f32, 
	max_speed: f32, 
	rot_acl: f32, 
	rot_max_vel: f32,
	layer_count: int = 5,
	layer_delay: int = 10)
{		
	next_enemy_wave_rest_t = int(60 * rest)
	next_enemy_wave_in_t = 0

	for pos, enemy_i in positions {

		layers : small_array.Small_Array(GEO_COLLIDER_MAX_LAYERS, Geo_Layer) // TODO: why does this work, but not using slice w/ inline init?
		step := f32(12)

		for i := 0; i < layer_count; i += 1 {

			rad := base_rad - f32(i) * step

			for j := 0; j <= 1; j += 1 {
				r := j == 0 ? rad : rad - LINE_WIDTH
				c := j == 0 ? col : {0,0,0,1} // TODO: BLACK

				// don't fill in last layer center with black
				if (i != layer_count - 1) || j == 0 { 
					small_array.append_elem(&layers, Geo_Layer {
						rad = r, 
						res = uint(res), 
						rot = 0, 
						mode = .Solid,
						col = c
					})
				}
			}

			// Create entry effects

			if i == 0 {
				// solid back background
				p := create_particle_effect(
					mode = .Solid, 
					pos = pos,
					vel = {0, 0},
					drag = 0,
					life = f32(int(ENEMY_IN_TIME) - layer_delay * i) / 60.0,
					res = uint(res),
					rad_start = 600 - f32(i * 90),
					rad_end = rad,
					col_start = {col.r, col.g, col.b, 0},
					col_end = {0,0,0,1}, // TODO: BLACK
					rot_start = 0,
					rot_end = 0,
					node_rad_start = 0,
					node_rad_end = 0,
					thic = 0,
					fade = 0,
					delay = i * layer_delay,
					ease = .Quadratic_Out
				)
				append(&next_enemy_in_effects, p)
			}

			radius_effect_mode : Radius_Effect_Mode = i == (layer_count - 1) ? .Solid : .Line
			p := create_particle_effect(
				mode = radius_effect_mode, 
				pos = pos,
				vel = {0, 0},
				drag = 0,
				life = f32(int(ENEMY_IN_TIME) - layer_delay * i) / 60.0,
				res = uint(res),
				rad_start = 600 - f32(i * 90),
				rad_end = rad,
				col_start = {col.r, col.g, col.b, 0},
				col_end = col,
				rot_start = 0,
				rot_end = 0,
				node_rad_start = 0,
				node_rad_end = 0,
				thic = 0,
				fade = 0,
				delay = i * layer_delay,
				ease = .Quadratic_Out
			)
			append(&next_enemy_in_effects, p)

			for j := 0; j < 3; j += 1 {
				// implode 
				implode_delay := int(rand.float32_range(0, f32(ENEMY_IN_TIME / 2)))
				implode_life := f32(ENEMY_IN_TIME - 60) / 60.0
				p := create_particle_effect(
					mode = .Circles, 
					pos = pos,
					vel = {0, 0}, // not used
					drag = 0, // not used
					life = implode_life,
					res = uint(rand.float32_range(10, 50)),
					rad_start = 600 - rand.float32_range(0, 200),
					rad_end = 30,
					col_start = {col.r, col.g, col.b, 0.8},
					col_end = {col.r, col.g, col.b, 0},
					rot_start = 0,
					rot_end = 0,
					node_rad_start = 4,
					node_rad_end = 2,
					thic = 6,
					fade = 2,
					delay = implode_delay,
				)
				append(&next_enemy_in_effects, p)
			}

		}

		// Create enemy

		geo := Geo_Collider {
			type = .Enemy,
			t = 0,
			last_t = 0,
			layers = layers,
			pos = pos,
			last_pos = pos,
			acl_speed = acl_speed,
			max_speed = max_speed,
			vel = {0, 0},
			collide_rad = base_rad,
			col = col.rgb,
			alpha = 1,
			rot = 0,
			ROT_ACL = rot_acl, // 0.0005,
			ROT_MAX_VEL = rot_max_vel // 0.02,
		}
		seek_player := int(enemy_i % 2 == 0 ? 0 : 1)
		enemy := create_enemy_seeker(geo, seek_i = seek_player)

		append(&next_enemies, enemy)
	}
}

