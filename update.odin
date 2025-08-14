package main

import "core:fmt"
import "core:math"
import "core:math/linalg"

update :: proc() 
{
	// update resolution from current window size
	resolution = get_resolution()

	switch game_state {
	case .active:
		update_active(is_title = false)
	case .paused:
		update_paused()
	case .title:
		update_active(is_title = true)
	case .game_over:
		update_game_over()
	}
}

update_active :: proc(is_title: bool)
{
	// must update camera first or glitches
	update_camera()
	update_screen_wrap() // TODO: best order for this?

	update_particles()

	if player_1.is_alive {
		update_player_1()
	} else {
		update_player_1_dead()
	}

	if player_2.is_alive {
		update_player_2()
	} else {
		update_player_2_dead()
	}

	update_bombs()
	update_bullets()
	if is_title == false {
		update_enemies()
	}
}

update_paused :: proc()
{
	update_pause_menu()
}

update_game_over :: proc()
{
	// must update camera first or glitches
	update_camera()
	update_screen_wrap() // TODO: best order for this?
	update_particles()
	update_bombs()
	update_bullets()
	update_enemies()
}

// TODO: move
grow_effect_batch_if_needed :: proc()
{	
	if len(radius_effects) > 0 {

		batch := radius_effects[len(radius_effects) - 1] 

		if len(batch) >= MAX_RADIUS_EFFECT_BATCH {
			new_batch := [dynamic]Radius_Effect{} // TODO: look into mem allocation here 
			append(&radius_effects, new_batch)
		}
	} else {
		new_batch := [dynamic]Radius_Effect{} // TODO: look into mem allocation here 
		append(&radius_effects, new_batch)
	}
}

handle_beacon_collide_player :: proc(c: Geo_Collider)
{
	grow_effect_batch_if_needed()
	re_arr := &radius_effects[len(radius_effects) - 1]
	append(re_arr, create_random_particle_pos(.Line, c.pos))
}

update_camera :: proc ()
{
	// cam_target := p1_pos + p1_facing * 100.0 - resolution / 2.0
	cam_target := player_1.pos - resolution / 2.0
	cam_path := cam_target - camera.pos
	cam_dir : [2]f32 = {0, 0}
	if linalg.dot(cam_path, cam_path) > 0 {
		cam_dir = linalg.normalize(cam_path)
	}

	path_len := linalg.length(cam_path)

	EASE_DIST := f32(400)
	STOP_DIST := f32(2)

	if path_len < STOP_DIST {
		camera.speed = 0
	} else if path_len < EASE_DIST {
		camera.speed = (path_len / EASE_DIST) * camera.MAX_SPEED
	} else {
		camera.speed = camera.MAX_SPEED
	}

	camera.last_pos = camera.pos
	camera.pos += camera.speed * cam_dir
}

update_screen_wrap :: proc()
{
	// screen wrapping
	// TODO: need to handle render interpolation jump at high speed?

	// screen wrap: p2
	player_2.last_pos = wrap_pos(player_2.last_pos, camera.pos)
	player_2.pos = wrap_pos(player_2.pos, camera.pos)

	// screen wrap: particles

	for arr in radius_effects {
		for &p in arr {
			p.pos = wrap_pos(p.pos, camera.pos)
		}
	}

	// enemies
	
	for &e in enemies {
		e.geo.last_pos = wrap_pos(e.geo.last_pos, camera.pos)
		e.geo.pos = wrap_pos(e.geo.pos, camera.pos)
	}

	// beacons
	
	for &b in beacons {
		b.last_pos = wrap_pos(b.last_pos, camera.pos)
		b.pos = wrap_pos(b.pos, camera.pos)
	}

	// bombs
	for &b in bombs {
		b.last_pos = wrap_pos(b.last_pos, camera.pos)
		b.pos = wrap_pos(b.pos, camera.pos)
	}

	// bullets

	for &b in bullets {
		b.last_pos = wrap_pos(b.last_pos, camera.pos)
		b.pos = wrap_pos(b.pos, camera.pos)
	}
}

