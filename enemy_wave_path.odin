package main

import "core:math/rand"
import "core:container/small_array"

Enemy_Wave_Path_Data :: struct {
	pos: [2]f32,
	rot: f32,
	speed: f32
}

create_enemy_wave_path :: proc(
	rest: f32, 
	data: []Enemy_Wave_Path_Data, 
	col: [4]f32, 
	base_rad: f32, 
	res: int,
	path_type: Enemy_Path_Type)
{		
	next_enemy_wave_rest_t = int(60 * rest)
	next_enemy_wave_in_t = 0

	for dat, enemy_i in data {

		layers : small_array.Small_Array(GEO_COLLIDER_MAX_LAYERS, Geo_Layer) // TODO: why does this work, but not using slice w/ inline init?
		step := f32(4) // TODO: this matches stroke of line which should be defined somewhere

		for i := 0; i < 2; i += 1 {

			geo_render_mode : Geo_Render_Mode = i == 1 ? .Solid : .Line
			rad := base_rad - f32(i) * step

			// inner layer is solid black
			layer_col : [4]f32 = i == 1 ? {0,0,0,1} : col 

			small_array.append_elem(&layers, Geo_Layer {
				rad = rad, 
				res = uint(res), 
				rot = 0, 
				mode = geo_render_mode,
				col = layer_col
			})

			// Create entry effect

			// layered zoom in
			radius_effect_mode : Radius_Effect_Mode
			switch geo_render_mode {
				case .Line: radius_effect_mode = .Line
				case .Solid: radius_effect_mode = .Solid
			}

			p := create_particle_effect(
				mode = radius_effect_mode, 
				pos = dat.pos,
				vel = {0, 0},
				drag = 0,
				life = f32(int(ENEMY_IN_TIME) - 20 * i) / 60.0,
				res = uint(res),
				rad_start = 600 - f32(i * 150),
				rad_end = rad,
				col_start = {layer_col.r, layer_col.g, layer_col.b, 0},
				col_end = layer_col,
				rot_start = dat.rot,
				rot_end = dat.rot,
				node_rad_start = 0,
				node_rad_end = 0,
				thic = 0,
				fade = 0,
				delay = i * 20,
				ease = .Quadratic_Out
			)
			append(&next_enemy_in_effects, p)

			for j := 0; j < 3; j += 1 {
				// implode 
				implode_delay := int(rand.float32_range(0, f32(ENEMY_IN_TIME / 2)))
				implode_life := f32(ENEMY_IN_TIME - 60) / 60.0
				p = create_particle_effect(
					mode = .Circles, 
					pos = dat.pos,
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
			pos = dat.pos,
			last_pos = dat.pos,
			acl_speed = 0, // not used
			max_speed = dat.speed, 
			vel = {0, 0}, // path type enemy bases vel from rot + max_speed
			collide_rad = base_rad,
			col = col.rgb,
			alpha = 1,
			rot = dat.rot,
			ROT_ACL = 0, // not used
			ROT_MAX_VEL = 0 // not used
		}

		enemy := create_enemy_path(geo, path_type = path_type)

		append(&next_enemies, enemy)
	}
}

