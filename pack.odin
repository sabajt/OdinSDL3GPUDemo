package main

import "core:fmt"

vert_ref_quad := 0 // len 6 
vert_ref_tri := 0 // len 3

pack :: proc(dt: f32, cam: [2]f32)
{
	// TODO: decouple packing / render order from sdf flags etc 

	// first pack shared vert refs

	pack_shared_verts()

	// most other stuff

	sim_dt := game_state == .paused ? 0 : dt // make pausing not jitter

	pack_radius_particles(sim_dt, cam)
	pack_sdf(sim_dt, cam) // !! coupled with render order (sdf pipeline and flags)
	// pack_beacons(sim_dt, cam)
	pack_enemies(sim_dt, cam)


	// players

	if game_state != .game_over {
		if player_2.is_alive {
			pack_player_2(sim_dt, cam)
		} else if player_2.is_spawning_in == false {
			pack_countdown(sim_dt, cam)
		}

		if player_1.is_alive {
			pack_player_1(sim_dt)
		} else if player_1.is_spawning_in == false {
			pack_countdown(sim_dt, cam) 
		}
	}

	// text

	pack_text_ttf()

	// menu / ui

	switch game_state {

	case .title:
		pack_title_screen(dt, cam)

	case .paused:
		pack_pause_menu(dt, cam)

	case .game_over:
		pack_game_over(dt, cam)

	case .active:
	}

	if DEBUG_MODE {
		debug_context.max_batch_shape_inputs = max(len(batch_shape_inputs), debug_context.max_batch_shape_inputs)
		debug_context.max_batch_shape_vertices = max(len(batch_shape_verts), debug_context.max_batch_shape_vertices)
		debug_context.max_batch_shape_models = max(len(batch_shape_models), debug_context.max_batch_shape_models)
	}
}

pack_shared_verts :: proc()
{
	// quad

	verts := []Batch_Shape_Vertex {
		{ position = {-0.5, -0.5}, color = {1, 1, 1, 1} },
		{ position = {0.5, -0.5}, color = {1, 1, 1, 1} },
		{ position = {0.5, 0.5}, color = {1, 1, 1, 1} },
		{ position = {-0.5, -0.5}, color = {1, 1, 1, 1} },
		{ position = {0.5, 0.5}, color = {1, 1, 1, 1} },
		{ position = {-0.5, 0.5}, color = {1, 1, 1, 1} }
	}

	vert_ref_quad = pack_vert_ref(verts[:])

	// triangle

	verts = []Batch_Shape_Vertex {
		{ position = {-0.5, -0.5}, color = {1, 1, 1, 1} },
		{ position = {0.5, -0.5}, color = {1, 1, 1, 1} },
		{ position = {0, 0.5}, color = {1, 1, 1, 1} },
	}

	vert_ref_tri = pack_vert_ref(verts[:])

	// letters and numbers

	pack_shared_letter_verts()
	pack_shared_number_verts()
}

pack_enemies :: proc(dt: f32, cam: [2]f32) 
{
	for e in enemies  {
		pack_geo_collider(e.geo, dt, cam)
	}
}

pack_beacons :: proc(dt: f32, cam: [2]f32) 
{
	for b in beacons  {
		pack_geo_collider(b, dt, cam)
	}
}


