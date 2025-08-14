package main

import "core:fmt"
import "core:math/linalg"
import "core:math"
import "core:mem"
import sdl "vendor:sdl3"
import ttf "vendor:sdl3/ttf"

render :: proc(dt: f32) 
{
	command_buffer := sdl.AcquireGPUCommandBuffer(gpu) 

	swapchain_texture: ^sdl.GPUTexture
	ok := sdl.WaitAndAcquireGPUSwapchainTexture(command_buffer, window, &swapchain_texture, nil, nil)
	assert(ok, "not ok")

	if swapchain_texture != nil {
		render_internal(dt, command_buffer, swapchain_texture)
	}

	ok = sdl.SubmitGPUCommandBuffer(command_buffer);
	assert(ok, "not ok")	

	if DEBUG_MODE {
		debug_context.render_cycle += 1
	}
}

render_internal :: proc(dt: f32, command_buffer: ^sdl.GPUCommandBuffer, swapchain_texture: ^sdl.GPUTexture) 
{	
	// view projection, camera

	sim_dt := game_state == .paused ? 0 : dt // make pausing not jitter

	proj_mat := linalg.matrix_ortho3d_f32(0, resolution.x, 0, resolution.y, near=-100, far=100, flip_z_axis=false)
	camera_blend_pos := math.lerp(camera.last_pos, camera.pos, sim_dt)
	camera_mat := linalg.matrix4_translate_f32({-camera_blend_pos.x, -camera_blend_pos.y, 0})

	// clear cpu models

	clear_batch_shape()
	clear_text()

	// pack cpu to render models

	pack(dt, camera_blend_pos) // use real dt so paused state can have animations

	// copy and transfer memory to gpu

	render_transfer_mem(command_buffer)

	// begin render pass
 
	color_target := sdl.GPUColorTargetInfo {
		texture = swapchain_texture,
		clear_color = {0, 0, 0, 1},
		load_op = .CLEAR,
		store_op = .STORE,
	}

	render_pass := sdl.BeginGPURenderPass(command_buffer, &color_target, 1, nil)

	// grid: common

	sdl.BindGPUGraphicsPipeline(render_pass, pipeline_bkg)

	sdl.BindGPUVertexBuffers(
		render_pass, 
		first_slot = 0, 
		bindings = &(sdl.GPUBufferBinding { buffer = grid_vertex_buffer }), 
		num_bindings = 1
	)

	grid_offset_ubo := Offset_Ubo { offset = GRID_PADDING }
	sdl.PushGPUVertexUniformData(
		command_buffer, 
		slot_index = 2,
		data = &grid_offset_ubo, 
		length = size_of(grid_offset_ubo)
	)

	// grid: vertical lines

	grid_scale_mat := linalg.matrix4_scale_f32({1, resolution.y, 1})	

	grid_axis_ubo := Axis_Ubo { x_axis = 1 }
	sdl.PushGPUVertexUniformData(
		command_buffer, 
		slot_index = 1, 
		data = &grid_axis_ubo, 
		length = size_of(grid_axis_ubo)
	)

	grid_x_left := math.ceil(camera_blend_pos.x / GRID_PADDING) * GRID_PADDING
	grid_pos_mat := linalg.matrix4_translate_f32({grid_x_left, camera_blend_pos.y, 1}) // TODO: z?

	grid_mvp := proj_mat * camera_mat * grid_pos_mat * grid_scale_mat
	grid_mvp_ubo := Mvp_Ubo { mvp = grid_mvp }
	sdl.PushGPUVertexUniformData(
		command_buffer, 
		0, 
		&grid_mvp_ubo, 
		size_of(grid_mvp_ubo)
	)

	vertical_instances := sdl.Uint32(math.ceil(resolution.x / GRID_PADDING))

	sdl.DrawGPUPrimitives(
		render_pass, 
		num_vertices = 2, 
		num_instances = vertical_instances, 
		first_vertex = 0, 
		first_instance = 0
	)

	// grid: horizontal lines

	grid_scale_mat = linalg.matrix4_scale_f32({resolution.x, 1, 1})	

	grid_axis_ubo = Axis_Ubo { x_axis = 0 }
	sdl.PushGPUVertexUniformData(
		command_buffer, 
		slot_index = 1, 
		data = &grid_axis_ubo, 
		length = size_of(grid_axis_ubo)
	)

	grid_y_bottom := math.ceil(camera_blend_pos.y / GRID_PADDING) * GRID_PADDING
	grid_pos_mat = linalg.matrix4_translate_f32({camera_blend_pos.x, grid_y_bottom, 1}) // TODO: z?

	grid_mvp = proj_mat * camera_mat * grid_pos_mat * grid_scale_mat
	grid_mvp_ubo = Mvp_Ubo { mvp = grid_mvp }
	sdl.PushGPUVertexUniformData(
		command_buffer, 
		slot_index = 0, 
		data = &grid_mvp_ubo, 
		length = size_of(grid_mvp_ubo)
	)

	horizontal_instances := sdl.Uint32(math.ceil(resolution.y / GRID_PADDING))

	sdl.DrawGPUPrimitives(
		render_pass, 
		num_vertices = 2, 
		num_instances = horizontal_instances, 
		first_vertex = 2, 
		first_instance = 0
	)

	// draw batched particles: fill

	sdl.BindGPUGraphicsPipeline(render_pass, pipeline_fill)

	sdl.BindGPUVertexBuffers(
		render_pass, 
		first_slot = 0, 
		bindings = &(sdl.GPUBufferBinding { buffer = batch_shape_inputs_vertex_buffer }), 
		num_bindings = 1
	)

	// TODO: figure out how to do in 1 call (how to build multi pointer?)
	sdl.BindGPUVertexStorageBuffers(
		render_pass,
		first_slot = 0,
		storage_buffers = &batch_shape_vertex_storage_buffer,
		num_bindings = 1
	)
	sdl.BindGPUVertexStorageBuffers(
		render_pass,
		first_slot = 1,
		storage_buffers = &batch_shape_models_storage_buffer,
		num_bindings = 1
	)

	view_projection := proj_mat * camera_mat
	sdl.PushGPUVertexUniformData(
		command_buffer, 
		slot_index = 0, 
		data = &view_projection, 
		length = size_of(view_projection)
	)

	res_ubo := Res_Ubo { res_cam = {resolution.x, resolution.y, camera_blend_pos.x, camera_blend_pos.y } }
	sdl.PushGPUFragmentUniformData(command_buffer, 0, &res_ubo, size_of(res_ubo))

	players_len := len(batch_shape_inputs) - last_sdf_input
	sdf_particles_len := last_sdf_input - first_sdf_input

	sdl.DrawGPUPrimitives(
		render_pass, 
		num_vertices = u32(first_sdf_input),
		num_instances = 1, 
		first_vertex = 0, 
		first_instance = 0
	)

	// draw batched particles: sdf circles

	sdl.BindGPUGraphicsPipeline(render_pass, pipeline_sdf)

	res_ubo_2 := Res_Ubo { res_cam = {resolution.x, resolution.y, camera_blend_pos.x, camera_blend_pos.y } }
	sdl.PushGPUFragmentUniformData(command_buffer, 0, &res_ubo_2, size_of(res_ubo_2))

	sdl.DrawGPUPrimitives(
		render_pass, 
		num_vertices = u32(sdf_particles_len),
		num_instances = 1, 
		first_vertex = u32(first_sdf_input), 
		first_instance = 0
	)

	// draw players

	sdl.BindGPUGraphicsPipeline(render_pass, pipeline_fill)

	sdl.DrawGPUPrimitives(
		render_pass, 
		num_vertices = u32(players_len),
		num_instances = 1, 
		first_vertex = u32(last_sdf_input), 
		first_instance = 0
	)

	// draw text

	// render_text(render_pass, command_buffer, proj_mat)

	sdl.EndGPURenderPass(render_pass)
}

render_text :: proc(render_pass: ^sdl.GPURenderPass, command_buffer: ^sdl.GPUCommandBuffer, proj_mat: matrix[4, 4]f32)
{
	sdl.BindGPUGraphicsPipeline(render_pass, pipeline_text)

	sdl.BindGPUVertexBuffers(
		render_pass, 
		first_slot = 0, 
		bindings = &(sdl.GPUBufferBinding { buffer = text_vertex_buffer }), 
		num_bindings = 1
	)
	sdl.BindGPUIndexBuffer(
		render_pass, 
		binding = sdl.GPUBufferBinding { buffer = text_index_buffer }, 
		index_element_size = ._32BIT
	)

	text_pos_mat := linalg.matrix4_translate_f32({200, 600, 0}) // TODO: z?	
	text_mvp := proj_mat * text_pos_mat // Ignores camera
	text_mvp_ubo := Mvp_Ubo { mvp = text_mvp }
	sdl.PushGPUVertexUniformData(
		command_buffer, 
		slot_index = 0, 
		data = &text_mvp_ubo, 
		length = size_of(text_mvp_ubo)
	)

	text_index_offset = 0
	text_vertex_offset = 0
	for &item in text_items {
		render_text_item(render_pass, item = &item)
	}
}

text_index_offset := 0
text_vertex_offset := 0

render_text_item :: proc(render_pass: ^sdl.GPURenderPass, item: ^TTF_Text_Item) 
{
	for seq := item.atlas_draw_seq; seq != nil; seq = seq.next {

		sdl.BindGPUFragmentSamplers(
			render_pass, 
			first_slot = 0, 
			texture_sampler_bindings =  &(sdl.GPUTextureSamplerBinding {
				texture = seq.atlas_texture, 
				sampler = text_sampler 
			}),
			num_bindings = 1
		)
		sdl.DrawGPUIndexedPrimitives(
			render_pass, 
			num_indices = u32(seq.num_indices),
			num_instances = 1, 
			first_index = u32(text_index_offset), 
			vertex_offset = i32(text_vertex_offset), 
			first_instance = 0
		)

		text_index_offset += int(seq.num_indices)
		text_vertex_offset += int(seq.num_vertices)
	}
}

render_transfer_mem :: proc (command_buffer: ^sdl.GPUCommandBuffer)
{
	// TODO: create array of custom tranfer mem struct so it doesn't crash when nothing inside

	// copy data into transfer buffer

	inputs_sz := len(batch_shape_inputs) * size_of(Batch_Shape_Input)
	verts_sz := len(batch_shape_verts) * size_of(Batch_Shape_Vertex)
	models_sz := len(batch_shape_models) * size_of(Batch_Shape_Model)

	text_verts_sz := 0 
	text_verts := [dynamic]Text_Vertex {}
	text_indices_sz := 0
	text_indices := [dynamic]u32 {}
	for item in text_items {
		text_verts_sz += len(item.geo_data.vertices) * size_of(Text_Vertex)
		append(&text_verts, ..item.geo_data.vertices[:])
		text_indices_sz += len(item.geo_data.indices) * size_of(int)
		append(&text_indices, ..item.geo_data.indices[:])
	}

	transfer_memory := transmute([^]byte)sdl.MapGPUTransferBuffer(gpu, transfer_buffer, true) // TODO: should cycle?

	// solid shapes
	mem.copy(
		transfer_memory, 
		raw_data(batch_shape_inputs), 
		inputs_sz
	)
	mem.copy(
		transfer_memory[batch_shape_inputs_byte_size:], 
		raw_data(batch_shape_verts), 
		verts_sz
	)
	mem.copy(
		transfer_memory[(batch_shape_inputs_byte_size + batch_shape_verts_byte_size):],
		raw_data(batch_shape_models), 
		models_sz
	)

	// text
	mem.copy(
		transfer_memory[(batch_shape_inputs_byte_size + batch_shape_verts_byte_size + batch_shape_models_byte_size):],
		raw_data(text_verts),
		text_verts_sz
	)
	mem.copy(
		transfer_memory[(batch_shape_inputs_byte_size + batch_shape_verts_byte_size + batch_shape_models_byte_size + text_vert_buf_byte_size):],
		raw_data(text_indices),
		text_indices_sz
	)
	sdl.UnmapGPUTransferBuffer(gpu, transfer_buffer)

	// upload to gpu

	copy_pass := sdl.BeginGPUCopyPass(command_buffer)

	// solids

	sdl.UploadToGPUBuffer(
		copy_pass, 
		source = {
			transfer_buffer = transfer_buffer
		},
		destination = {
			buffer = batch_shape_inputs_vertex_buffer, 
			size = u32(batch_shape_inputs_byte_size)
		},
		cycle = true // TODO: should cycle?
	)
	sdl.UploadToGPUBuffer(
		copy_pass, 
		source = {
			transfer_buffer = transfer_buffer,
			offset = u32(batch_shape_inputs_byte_size)

		},
		destination = {
			buffer = batch_shape_vertex_storage_buffer, 
			size = u32(batch_shape_verts_byte_size)
		},
		cycle = false 
	)
	sdl.UploadToGPUBuffer(
		copy_pass, 
		source = {
			transfer_buffer = transfer_buffer, 
			offset = u32(batch_shape_inputs_byte_size + batch_shape_verts_byte_size)
		},
		destination = {
			buffer = batch_shape_models_storage_buffer, 
			size = u32(batch_shape_models_byte_size)
		},
		cycle = false
	)

	// text
	sdl.UploadToGPUBuffer(
		copy_pass, 
		source = {
			transfer_buffer = transfer_buffer, 
			offset = u32(batch_shape_inputs_byte_size + batch_shape_verts_byte_size + batch_shape_models_byte_size)
		},
		destination = {
			buffer = text_vertex_buffer, 
			size = u32(text_vert_buf_byte_size)
		},
		cycle = false
	)
	sdl.UploadToGPUBuffer(
		copy_pass, 
		source = {
			transfer_buffer = transfer_buffer, 
			offset = u32(batch_shape_inputs_byte_size + batch_shape_verts_byte_size + batch_shape_models_byte_size + text_vert_buf_byte_size)
		},
		destination = {
			buffer = text_index_buffer, 
			size = u32(text_index_buf_byte_size)
		},
		cycle = false
	)

	sdl.EndGPUCopyPass(copy_pass)
	sdl.ReleaseGPUTransferBuffer(gpu, transfer_buffer)

	delete(text_verts)
	delete(text_indices)
}

