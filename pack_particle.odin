package main

import "core:fmt"
import "core:math"

pack_radius_particles :: proc(dt: f32, cam: [2]f32) 
{
	// pack fill and lines
	for arr in radius_effects {
		for p in arr {
			// skip "removed", delayed and circle mode
			if p.delay_onset_t == 0 && !p.expired && p.mode != .Circles  {
				pack_radius_particle(p, dt, cam)
			}
		}
	}
}

pack_radius_particles_sdf :: proc(dt: f32, cam: [2]f32) 
{
	for arr in radius_effects {
		for p in arr {
			// skip "removed", delayed and only pack circles
			if p.delay_onset_t == 0 && !p.expired && p.mode == .Circles  {
				pack_radius_particle(p, dt, cam)
			}
		}
	}
}

pack_radius_particle :: proc(p: Radius_Effect, dt: f32, cam: [2]f32)
{
	models := [dynamic]Batch_Shape_Model{}
	blend_t := math.lerp(p.last_t, p.t, dt)

	rad := math.lerp(p.rad_start, p.rad_end, blend_t)
	rot := math.lerp(p.rot_start, p.rot_end, blend_t)
	col := math.lerp(p.col_start, p.col_end, blend_t)
	blend_node_rad := math.lerp(p.node_rad_start, p.node_rad_end, blend_t)

	// real-time velocity behavior: another mode could be lerp to ending pos based on t like above values
	pos := math.lerp(p.last_pos, p.pos, dt) 

	if p.mode == .Solid || p.mode == .Line {
		fill_wrap_models(
			models = &models, 
			pos = { pos.x, pos.y, 1 }, // TODO: handle z val
			model_scale = 1, 
			screen_scale =  rad * 2.0, 
			rot = rot,
			thic = p.thic, 
			fade = p.fade,
			period = 0,
			col = col,
			cam = cam
	 	)
	}	

	verts := [dynamic]Batch_Shape_Vertex {}

	for i : uint = 0; i < p.res; i += 1 {

 		angle := math.TAU * f32(i) / f32(p.res)

 		switch p.mode {
 		case .Solid:
			pos := [2]f32 { 
				rad * math.cos(angle), 
				rad * math.sin(angle) 
			}

			// outer
			append(&verts, Batch_Shape_Vertex { 
				position = pos, 
				color = col  
			})

			// center
			append(&verts, Batch_Shape_Vertex { 
				position = {0, 0}, 
				color = col
			}) 

			// next index
			angle = math.TAU * f32(i + 1) / f32(p.res)
			pos = [2]f32 { 
				rad * math.cos(angle), 
				rad * math.sin(angle) 
			}

			append(&verts, Batch_Shape_Vertex { 
				position = pos, 
				color = col
			}) 
		case .Line:
			// outer
			pos0 := [2]f32 { 
				(rad + LINE_WIDTH / 2.0) * math.cos(angle), 
				(rad + LINE_WIDTH / 2.0) * math.sin(angle) 
			}
			append(&verts, Batch_Shape_Vertex { 
				position = pos0, 
				color = col
			}) 

			// inner
			ang1 := math.TAU * f32(i) / f32(p.res)
			pos1 := [2]f32 { 
				(rad - LINE_WIDTH / 2.0) * math.cos(ang1), 
				(rad - LINE_WIDTH / 2.0) * math.sin(ang1) 
			}
			append(&verts, Batch_Shape_Vertex { 
				position = pos1, 
				color = col  
			}) 

			// next outer
			ang2 := math.TAU * f32(i + 1) / f32(p.res)
			pos2 := [2]f32 { 
				(rad + LINE_WIDTH / 2.0) * math.cos(ang2), 
				(rad + LINE_WIDTH / 2.0) * math.sin(ang2) 
			}
			append(&verts, Batch_Shape_Vertex { 
				position = pos2, 
				color = col 
			})

			// inner
			append(&verts, Batch_Shape_Vertex { 
				position = pos1, 
				color = col  
			})

			// next outer
			append(&verts, Batch_Shape_Vertex { 
				position = pos2, 
				color =col 
			})

			// next inner
			ang3 := math.TAU * f32(i + 1) / f32(p.res)
			pos3 := [2]f32 { 
				(rad - LINE_WIDTH / 2.0) * math.cos(ang3), 
				(rad - LINE_WIDTH / 2.0) * math.sin(ang3) 
			}
			append(&verts, Batch_Shape_Vertex { 
				position = pos3, 
				color = col
			})
		case .Circles:
			pos := [2]f32 { 
				pos.x + rad * math.cos(angle), 
				pos.y + rad * math.sin(angle) 
			}

			node_models := [dynamic]Batch_Shape_Model{}

			fill_wrap_models(
				models = &node_models, 
				pos = { pos.x, pos.y, 1 }, // TODO: handle z val
				model_scale = blend_node_rad * 2.0, 
				screen_scale = blend_node_rad * 2.0,
				rot = 0, 
				thic = p.thic,
				fade = p.fade,
				period = 0,
				col = col,
				cam = cam
		 	)

			for &m in node_models {
				// reference shared quad
				pack_batch_shape_vert_ref(
		 			vert_index = vert_ref_quad, 
		 			count = 6, 
		 			model = m
		 		)
			}

			delete(node_models)

		}
	}

	if p.mode != .Circles {
		pack_batch_shape_arr(
			src_verts = verts[:],
			// TODO: understand how these models don't go out of memory, 
			// b/c they are added to another dynamic array?
			src_models = models[:],
			dest_verts = &batch_shape_verts,
			dest_models = &batch_shape_models,
			dest_inputs = &batch_shape_inputs
		)
	}

	delete(models)
	delete(verts)
}
