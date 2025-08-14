package main

import "core:fmt"
import "core:math"
import "core:math/rand"
import "core:math/linalg"

ENEMY_IN_TIME := u64(60.0 * 2.5)

// TODO: try upping enemy speed / acl but limit enemy rot vel 

Enemy_Wave_State :: enum {
	Rest,
	Animate_In,
	Active
}

current_enemy_wave := int(0)
enemy_wave_state : Enemy_Wave_State = .Rest
next_enemy_wave_rest_t := int(0) // overwritten in enemy wave creation
next_enemy_wave_in_t := int(0)

clear_enemies :: proc()
{
	clear(&enemies)
	clear(&next_enemies)
	clear(&next_enemy_in_effects)

	current_enemy_wave = int(0)
	enemy_wave_state  = .Rest
	next_enemy_wave_rest_t = int(0) // overwritten in enemy wave creation
	next_enemy_wave_in_t = int(0)
}

update_enemies :: proc()
{
	switch enemy_wave_state {
		case .Rest: update_enemies_rest()
		case .Animate_In: update_enemies_animate_in()
		case .Active: update_enemies_active()
	}
}

update_enemies_rest :: proc()
{
	next_enemy_wave_rest_t -= 1
	if next_enemy_wave_rest_t <= 0 {
		enemy_wave_state = .Animate_In
		begin_animate_enemy_wave_in()
	}
}

update_enemies_animate_in :: proc()
{
	if u64(next_enemy_wave_in_t) < ENEMY_IN_TIME {
		next_enemy_wave_in_t += 1
	} else {
		enemy_wave_state = .Active
		begin_enemy_wave()
	}
}

update_enemies_active :: proc()
{
	for &e in enemies {
		update_enemy_movement(&e)

		if player_1.is_alive && player_1.grace_t == 0 && collide_player(.one, e.geo.pos, e.geo.collide_rad) {
			handle_enemy_player_1_collide()	
		}
		if player_2.is_alive && player_2.grace_t == 0 && collide_player(.two, e.geo.pos, e.geo.collide_rad) {
			handle_enemy_player_2_collide()	
		}
	} 

	if len(enemies) == 0 {
		current_enemy_wave += 1
		enemy_wave_state = .Rest
		create_next_enemy_wave()
	}
}

create_next_enemy_wave :: proc()
{
	switch current_enemy_wave {
	case 0: create_enemy_wave_0()
	case 1: create_enemy_wave_1()
	case 2: create_enemy_wave_2()
	case 3: create_enemy_wave_3()
	case 4: create_enemy_wave_4()
	case 5: create_enemy_wave_5()
	case 6: create_enemy_wave_6()
	case 7: create_enemy_wave_7()
	case 8: create_enemy_wave_8()
	case 9: create_enemy_wave_9()
	case 10: create_enemy_wave_10()
	case 11: create_enemy_wave_11()
	case 12: create_enemy_wave_12()
	case 13: create_enemy_wave_13()
	case 14: create_enemy_wave_14()
	case 15: create_enemy_wave_15()
	case 16: create_enemy_wave_16()
	case 17: create_enemy_wave_17()
	case 18: create_enemy_wave_18()
	case 19: create_enemy_wave_19()
	}
}

begin_animate_enemy_wave_in :: proc()
{
	for &e in next_enemy_in_effects {
		grow_effect_batch_if_needed()
		re_arr := &radius_effects[len(radius_effects) - 1]
		append(re_arr, e)
	}
	clear(&next_enemy_in_effects)
}


begin_enemy_wave :: proc() 
{
	for &e in next_enemies {
		append(&enemies, e)
	}
	clear(&next_enemies)
}

update_enemy_movement :: proc(e: ^Enemy)
{
	switch e.type {
	case .Seeker:
		update_enemy_seeker_movement(e)
	case .Path:
		update_enemy_path_movement(e)
	}
}

handle_enemy_player_1_collide :: proc()
{	
	create_player_explode_effect(player_1) 

	// remove player
	player_1.is_alive = false 

	// update any seek targets to player 2
	for &e in enemies {
		e.seek_i = 1
	}

	// check for game over state
	if player_2.is_alive == false && player_2.is_spawning_in == false {
		game_state = .game_over
	}
}

handle_enemy_player_2_collide :: proc() // RENMAE
{	
	create_player_explode_effect(player_2)

	// remove player
	player_2.is_alive = false 

	// update any seek targets to player 1
	for &e in enemies {
		e.seek_i = 0
	}

	// check for game over state
	if player_1.is_alive == false && player_1.is_spawning_in == false {
		game_state = .game_over
	}
}

update_enemy_thrust_trail :: proc(c: Geo_Collider)
{
	// create particle behind player (this enemy is always just moving)

	if sim_time % 3 == 0 {
		ang := c.rot + math.PI + rand.float32_range(-0.5, 0.5)
		update_enemy_thrust_trail_internal(c.pos, ang, c.col)
	}
}

update_enemy_thrust_trail_internal :: proc(pos: [2]f32, ang: f32, col: [3]f32) {
	dir := [2]f32 {
		math.cos(f32(ang)), 
		math.sin(f32(ang))
	} 
	vel := dir * 3.0
	node_rad_end := f32(10) + rand.float32_range(0, 20)

	switch rand.int_max(2) {
	case 0:
		p := create_particle_effect(
			mode = .Circles, 
			pos = pos,
			vel = vel, 
			drag = rand.float32_range(0.03, 0.07),
			life = 0.9,
			res = 1,
			rad_start = 0 ,
			rad_end = 0,
			col_start = {col.r, col.g, col.b, 1},
			col_end = {col.r, col.g, col.b, 0},
			rot_start = 0,
			rot_end = 0,
			node_rad_start = 0.5,
			node_rad_end = node_rad_end,
			thic = rand.float32_range(8, node_rad_end),
			fade = 0
		)
		grow_effect_batch_if_needed()
		re_arr := &radius_effects[len(radius_effects) - 1]
		append(re_arr, p)

	case 1:
		p := create_particle_effect(
			mode = .Line, 
			pos = pos,
			vel = vel, 
			drag = rand.float32_range(0.03, 0.07),
			life = 1.5,
			res = 5,
			rad_start = 1,
			rad_end = 40 + rand.float32_range(0, 20),
			col_start = {col.r, col.g, col.b, 1},
			col_end = {col.r, col.g, col.b, 0},
			rot_start = 0,
			rot_end = rand.float32_range(-2.0 * math.TAU, 2.0 * math.TAU),
			node_rad_start = 0,
			node_rad_end = 0,
			thic = 0, // not used
			fade = 0 // not used
		)
		grow_effect_batch_if_needed()
		re_arr := &radius_effects[len(radius_effects) - 1]
		append(re_arr, p)
	}
}

create_enemy_explode_effect :: proc(e: Enemy)
{
	life := f32(2.5)
	res := e.geo.layers.data[0].res

	// background glow effect

	glow_fade := f32(400)
	glow_rad_end := f32(1100)

	p := create_particle_effect(
		mode = .Circles, 
		pos = e.geo.pos,
		vel = {0, 0},
		drag = 0,
		life = life,
		res = 1,
		rad_start = 0.01,
		rad_end = 0.01,
		col_start = {e.geo.col.r, e.geo.col.g, e.geo.col.b, 0.5},
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

	// single impact shape effect

	p = create_particle_effect(
		mode = .Line, 
		pos = e.geo.pos,
		vel = {0, 0}, 
		drag = 0,
		life = life + 1,
		res = res,
		rad_start = 40,
		rad_end = 800,
		col_start = {e.geo.col.r, e.geo.col.g, e.geo.col.b, 0.4},
		col_end = {1, 1, 1, 0},
		rot_start = e.geo.rot,
		rot_end = e.geo.rot,
		node_rad_start = 0,
		node_rad_end = 0,
		thic = 0, // not used
		fade = 0 // not used
	)
	grow_effect_batch_if_needed()
	re_arr = &radius_effects[len(radius_effects) - 1]
	append(re_arr, p)

	// explode particles

	rad_max := resolution.x
	for i := 0; i < 11; i += 1 {
		p := create_particle_effect(
			mode = .Circles, 
			pos = e.geo.pos,
			vel = {0, 0},
			drag = 0,
			life = life,
			res = 50,
			rad_start = 6,
			rad_end = math.lerp(f32(100), rad_max, f32(i) / 10.0),
			col_start = {e.geo.col.r, e.geo.col.g, e.geo.col.b, 1},
			col_end = {e.geo.col.r, e.geo.col.g, e.geo.col.b, 0},
			rot_start = 0,  
			rot_end = 0,
			node_rad_start = 5,
			node_rad_end = 5,
			thic = 6 + 4, // TODO: hack to only fade on outer edge
			fade = 2,
			ease = .Quadratic_Out
		)
		grow_effect_batch_if_needed()
		re_arr := &radius_effects[len(radius_effects) - 1]
		append(re_arr, p)
	} 
}



