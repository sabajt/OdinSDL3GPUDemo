package main

import "core:math"
import "core:math/rand"

update_player_thrust_trail :: proc (
	pos: [2]f32, 
	player_vel: [2]f32, 
	speed: f32,
	vel_mult_low: f32,
	vel_mult_high: f32,
	rot: f32, 
	col: [3]f32,
	ang_range: f32,
	drag: f32,
	x_pos_range: [2]f32,
	y_pos_range: [2]f32)
{
	// create particle behind player
	
	ang := rot + math.PI + rand.float32_range(-ang_range, ang_range)

	dir := [2]f32 {
		math.cos(f32(ang)), 
		math.sin(f32(ang))
	}
	vel := speed * dir * rand.float32_range(vel_mult_low, vel_mult_high) + player_vel * 0.5

	col_start := [4]f32 {
		col.r, 
		col.g + 0.1, 
		col.b + 0.1, 
		1
	}
	col_end := [4]f32 {
		col.r, 
		col.g + 0.2, 
		col.b - 0.1, 
		0
	}

	particle_pos := pos + {
		rand.float32_range(x_pos_range.x, x_pos_range.y), 
		rand.float32_range(y_pos_range.x, y_pos_range.y)
	}

	node_rad_end := f32(3) + rand.float32_range(0, 20)

	switch rand.int_max(3) {
	case 0:
		p := create_particle_effect(
			mode = .Circles, 
			pos = particle_pos,
			vel = vel, 
			drag = drag,
			life = 0.8,
			res = 1,
			rad_start = 1 ,
			rad_end = 1,
			col_start = col_start,
			col_end = col_end,
			rot_start = 0,
			rot_end = 0,
			node_rad_start = 3,
			node_rad_end = 2 + node_rad_end,
			thic = rand.float32_range(1, node_rad_end),
			fade = 3,
		)
		grow_effect_batch_if_needed()
		re_arr := &radius_effects[len(radius_effects) - 1]
		append(re_arr, p)

	case 1,2:
		p := create_particle_effect(
			mode = .Line, 
			pos = particle_pos,
			vel = vel, 
			drag = drag,
			life = 0.8,
			res = 6,
			rad_start = 6,
			rad_end = 2,
			col_start = col_start,
			col_end = col_end,
			rot_start = 0,
			rot_end = rand.float32_range(-math.TAU, math.TAU),
			node_rad_start = 0,
			node_rad_end = 0,
			thic = 0, // TODO: make Maybe() since ignored?
			fade = 0,
		)
		grow_effect_batch_if_needed()
		re_arr := &radius_effects[len(radius_effects) - 1]
		append(re_arr, p)
	}
}

find_player_respawn_pos :: proc(n: Player_Number, iter: int = 0) -> [2]f32
{
	rad := n == .one ? player_1.COLLIDE_RAD : player_2.COLLIDE_RAD

	// pick pos

	range := f32(resolution.y / 2.0)
	offset := [2]f32 {rand.float32() * range - range / 2.0, rand.float32() * range - range / 2.0}
	pos :[2]f32 = camera.pos + resolution / 2.0 + offset

	// max of 6 attempts

	if iter >= 6 {
		return pos
	}

	// test for enemies

	did_collide := false
	for e in enemies {
		// TODO: try giving some padding?
		if collide(pos, rad, e.geo.pos, e.geo.collide_rad) { 
			did_collide = true
			break
		}
	}

	// recurse if collision

	if did_collide {
		return find_player_respawn_pos(n, iter + 1)
	}

	// return pos otherwise
	return pos
}

create_player_warp_in_effect :: proc(player: Player) 
{
	// warp effect 

	for j := 0; j < 20; j += 1 {

		// tweak one of the color components slightly 

		red := f32(1)
		green := f32(1)
		blue := f32(1)

		col_i := rand.int_max(3)
		switch col_i {
			case 0: red -= (rand.float32() * 0.4)
			case 1: green -= (rand.float32() * 0.4)
			case 2: blue -= (rand.float32() * 0.4)
		}

		col_start := [4]f32 {red, green, blue, 0.2}
		col_end := [4]f32 {player.col.r, player.col.g, player.col.b, 0.8}

		// choose an ease 

		ease_i := rand.int_max(2)
		ease_option : Ease_Mode = .Linear
		switch ease_i {
			case 0: ease_option = .Quadratic_In_Out 
			case 1: ease_option = .Cubic_In_Out 
		}

		// rotate some of them

		rot := f32(0)
		if rand.float32() > 0.5 {
			rot = rand.float32() * math.TAU
			if rand.float32() > 0.5 {
				rot *= -1
			}
		}

		p := create_particle_effect(
			mode = .Line, 
			pos = player.next_spawn_pos,
			vel = {0, 0}, // not used
			drag = 0, // not used
			life = f32(PLAYER_IN_TIME) / 60.0,
			res = uint(rand.float32_range(3, 15)),
			rad_start = 900 - rand.float32_range(0, 400),
			rad_end = 5,
			col_start = col_start,
			col_end = col_end,
			rot_start = 0,
			rot_end = 0,
			node_rad_start = 4,
			node_rad_end = rand.float32_range(4, 15),
			thic = 0,
			fade = 0,
			delay = int(rand.float32_range(0, f32(PLAYER_IN_TIME / 2))),
			ease = .Cubic_In_Out
		)
		grow_effect_batch_if_needed()
		re_arr := &radius_effects[len(radius_effects) - 1]
		append(re_arr, p)			
	}

	// implode effect

	for j := 0; j < 10; j += 1 {

		// tweak one of the color components slightly 

		red := f32(1)
		green := f32(1)
		blue := f32(1)

		col_i := rand.int_max(3)
		switch col_i {
			case 0: red -= (rand.float32() * 0.4)
			case 1: green -= (rand.float32() * 0.4)
			case 2: blue -= (rand.float32() * 0.4)
		}
		col_start := [4]f32 {red, green, blue, 1}
		col_end := [4]f32 {player.col.r, player.col.g, player.col.b, 0.1}

		// half time solid, other half choose a thickness / fade
		
		thic := f32(0)
		fade := f32(2)
		if rand.float32() > 0.5 {
			thic = rand.float32_range(6, 15)
			fade = thic / 2.0
		}

		p := create_particle_effect(
			mode = .Circles, 
			pos = player.next_spawn_pos,
			vel = {0, 0}, // not used
			drag = 0, // not used
			life = f32(PLAYER_IN_TIME) / 60.0,
			res = uint(rand.float32_range(10, 50)),
			rad_start = 800 - rand.float32_range(0, 400),
			rad_end = 30,
			col_start = col_start,
			col_end = col_end,
			rot_start = 0,
			rot_end = 0,
			node_rad_start = 4,
			node_rad_end = rand.float32_range(4, 15),
			thic = thic,
			fade = fade,
			delay = int(rand.float32_range(0, f32(PLAYER_IN_TIME / 2))),
			ease = .Cubic_In_Out
		)
		grow_effect_batch_if_needed()
		re_arr := &radius_effects[len(radius_effects) - 1]
		append(re_arr, p)			
	}
}

create_player_explode_effect :: proc(player: Player) 
{
	rad_max := resolution.x / 2.0 * 1.1
	node_rad_start := f32(8)
	fade := f32(4)
	life := f32(4)

	// background glow effect

	glow_fade := f32(400)
	glow_rad_end := f32(1100)

	p := create_particle_effect(
		mode = .Circles, 
		pos = player.pos,
		vel = {0, 0},
		drag = 0,
		life = life,
		res = 1,
		rad_start = 0.01,
		rad_end = 0.01,
		col_start = {player.col.r, player.col.g, player.col.b, 0.4},
		col_end = {1, 1, 1, 0},
		rot_start = 0,  
		rot_end = 0,
		node_rad_start = 2,
		node_rad_end = glow_rad_end,
		thic = glow_rad_end,
		fade = glow_fade,
		ease = .Quadratic_Out
	)
	grow_effect_batch_if_needed()
	re_arr := &radius_effects[len(radius_effects) - 1]
	append(re_arr, p)

	// explode batch 1: ease out solid circ

	for i := 0; i < 20; i += 1 {

		// tweak one of the color components 

		red := f32(1)
		green := f32(1)
		blue := f32(1)

		col_i := rand.int_max(3)
		switch col_i {
			case 0: red -= rand.float32()
			case 1: green -= rand.float32()
			case 2: blue -= rand.float32()
		}
		col_start := [4]f32 {player.col.r, player.col.g, player.col.b, 1}
		col_end := [4]f32 {red, green, blue, 0}

		// choose an ease 

		ease_option : Ease_Mode = .Quadratic_Out
		if rand.float32() > 0.5 {
			ease_option = .Cubic_Out 
		}

		p := create_particle_effect(
			mode = .Circles, 
			pos = player.pos,
			vel = {0, 0},
			drag = 0,
			life = life + 0.5,
			// res = 90 - uint(rand.float32() * 20),
			res = 90 - uint(2 * i),
			rad_start = player.SCALE.x / 3.0,
			rad_end = math.lerp(f32(100), rad_max, f32(i) / 20.0) + 100,
			col_start = col_start,
			col_end = col_end, 
			rot_start = 0,
			rot_end = 0,
			node_rad_start = node_rad_start,
			node_rad_end = node_rad_start,
			thic = node_rad_start + fade * 2, // TODO: hack to only fade on outer edge
			fade = fade,
			ease = ease_option,
		)
		grow_effect_batch_if_needed()
		re_arr := &radius_effects[len(radius_effects) - 1]
		append(re_arr, p)
	}

	// explode batch 2: linear bubbles

	for i := 0; i < 8; i += 1 {

		// tweak one of the color components slightly 

		red := f32(1)
		green := f32(1)
		blue := f32(1)

		col_i := rand.int_max(3)
		switch col_i {
			case 0: red -= rand.float32()
			case 1: green -= rand.float32()
			case 2: blue -= rand.float32()
		}
		col_start := [4]f32 {player.col.r, player.col.g, player.col.b, 1}
		col_end := [4]f32 {red, green, blue, 0}

		p := create_particle_effect(
			mode = .Circles, 
			pos = player.pos,
			vel = {0, 0},
			drag = 0,
			life = life,
			// res = 90 - uint(rand.float32() * 20),
			res = 90 - uint(3 * i),
			rad_start = player.SCALE.x / 3.0,
			rad_end = 200 + math.lerp(f32(100), rad_max, f32(i) / 10.0),
			col_start = col_start,
			col_end = col_end, 
			rot_start = 0,
			rot_end = 0,
			node_rad_start = node_rad_start * 2,
			node_rad_end = node_rad_start,
			thic = node_rad_start - 2, // TODO: hack to only fade on outer edge
			fade = 3,
			ease = .Linear
		)
		grow_effect_batch_if_needed()
		re_arr := &radius_effects[len(radius_effects) - 1]
		append(re_arr, p)
	}

	// explode batch 3: small quick player color with delays

	for i := 0; i < 14; i += 1 {

		col_start := [4]f32 {player.col.r, player.col.g, player.col.b, 1}
		col_end := [4]f32 {player.col.r, player.col.g, player.col.b, 0}

		p := create_particle_effect(
			mode = .Circles, 
			pos = player.pos,
			vel = {0, 0},
			drag = 0,
			life = life,
			res = 80 - uint(rand.float32() * 30),
			rad_start = player.SCALE.x / 3.0,
			rad_end = math.lerp(f32(100), rad_max, f32(i) / 10.0) - 100,
			col_start = col_start,
			col_end = col_end, 
			rot_start = 0,
			rot_end = 0,
			node_rad_start = 2,
			node_rad_end = 2,
			thic = 2,
			fade = 0,
			ease = .Cubic_In_Out,
			delay = rand.int_max(int(life / 3))
		)
		grow_effect_batch_if_needed()
		re_arr := &radius_effects[len(radius_effects) - 1]
		append(re_arr, p)
	}
}


