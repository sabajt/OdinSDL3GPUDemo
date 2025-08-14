package main

import "core:fmt"
import "core:math"

pack_geo_collider :: proc(c: Geo_Collider, dt: f32, cam: [2]f32)
{
	// TODO: blend color too
	col := [4]f32{ c.col.r, c.col.g, c.col.b, c.alpha }

	blend_pos := [3]f32 {}
	blend_pos.xy = math.lerp(c.last_pos, c.pos, dt)
	blend_pos.z = 1 // TODO: does z matter anymore?
	blend_rot := c.rot // - math.PI / 2.0

	for l in c.layers.data {

		// fill models

		models := [dynamic]Batch_Shape_Model{}
		fill_wrap_models(
			models = &models, 
			pos = blend_pos, 
			model_scale = 1, 
			screen_scale =  l.rad * 2.0, 
			rot = l.rot + blend_rot, 
			thic = l.rad, // TODO: define in geo collider?
			fade = 0,
			period = 0,
			col = l.col,
			cam = cam
	 	)

	 	// fill verts

	 	verts := [dynamic]Batch_Shape_Vertex {}
		for i : uint = 0; i < l.res; i += 1 {

	 		angle := math.TAU * f32(i) / f32(l.res)

	 		switch l.mode {
	 		case .Solid:
				pos := [2]f32 { 
					l.rad * math.cos(angle), 
					l.rad * math.sin(angle) 
				}

				// outer
				append(&verts, Batch_Shape_Vertex { 
					position = pos, 
					color = {1,1,1,1}
				})

				// center
				append(&verts, Batch_Shape_Vertex { 
					position = {0, 0}, 
					color = {1,1,1,1}
				}) 

				// next index
				angle = math.TAU * f32(i + 1) / f32(l.res)
				pos = [2]f32 { 
					l.rad * math.cos(angle), 
					l.rad * math.sin(angle) 
				}

				append(&verts, Batch_Shape_Vertex { 
					position = pos, 
					color = {1,1,1,1} 
				}) 
			case .Line:
				// outer
				pos0 := [2]f32 { 
					(l.rad + LINE_WIDTH / 2.0) * math.cos(angle), 
					(l.rad + LINE_WIDTH / 2.0) * math.sin(angle) 
				}
				append(&verts, Batch_Shape_Vertex { 
					position = pos0, 
					color = {1,1,1,1}
				}) 

				// inner
				ang1 := math.TAU * f32(i) / f32(l.res)
				pos1 := [2]f32 { 
					(l.rad - LINE_WIDTH / 2.0) * math.cos(ang1), 
					(l.rad - LINE_WIDTH / 2.0) * math.sin(ang1) 
				}
				append(&verts, Batch_Shape_Vertex { 
					position = pos1, 
					color = {1,1,1,1}
				}) 

				// next outer
				ang2 := math.TAU * f32(i + 1) / f32(l.res)
				pos2 := [2]f32 { 
					(l.rad + LINE_WIDTH / 2.0) * math.cos(ang2), 
					(l.rad + LINE_WIDTH / 2.0) * math.sin(ang2) 
				}
				append(&verts, Batch_Shape_Vertex { 
					position = pos2, 
					color = {1,1,1,1}
				})

				// inner
				append(&verts, Batch_Shape_Vertex { 
					position = pos1, 
					color = {1,1,1,1}
				})

				// next outer
				append(&verts, Batch_Shape_Vertex { 
					position = pos2, 
					color = {1,1,1,1}
				})

				// next inner
				ang3 := math.TAU * f32(i + 1) / f32(l.res)
				pos3 := [2]f32 { 
					(l.rad - LINE_WIDTH / 2.0) * math.cos(ang3), 
					(l.rad - LINE_WIDTH / 2.0) * math.sin(ang3) 
				}
				append(&verts, Batch_Shape_Vertex { 
					position = pos3, 
					color = {1,1,1,1}
				})
			}
		}

		if DEBUG_MODE {
			// debug rotation indicator vert
			append(&verts, Batch_Shape_Vertex { 
				position = {100, -10}, 
				color = col
			})
			append(&verts, Batch_Shape_Vertex { 
				position = {100, 10}, 
				color = col
			})
			append(&verts, Batch_Shape_Vertex { 
				position = {110, 0}, 
				color = {1, 1, 1, 1}
			})
		}

		pack_batch_shape_arr(
			src_verts = verts[:],
			// TODO: understand how these models don't go out of memory, 
			// b/c they are added to another dynamic array?
			src_models = models[:],
			dest_verts = &batch_shape_verts,
			dest_models = &batch_shape_models,
			dest_inputs = &batch_shape_inputs
		)

		delete(models)
		delete(verts)
	}
} 
