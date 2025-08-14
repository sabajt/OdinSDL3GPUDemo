#+feature dynamic-literals

package main

import "core:fmt"
import "core:mem"
import "core:math/linalg"
import "core:math"
import sdl "vendor:sdl3"
import ttf "vendor:sdl3/ttf"

init :: proc() {
	if DEBUG_MODE { 
		sdl.SetLogPriorities(.VERBOSE) 
		fmt.println("\n* Init *\n")
	}

	ok := sdl.Init({.VIDEO, .GAMEPAD}) // TODO: ttf example had .EVENTS too
	assert(ok)

	window = sdl.CreateWindow("Zip & Zap", i32(resolution.x), i32(resolution.y), {})
	// window = sdl.CreateWindow("Zip & Zap", i32(resolution.x), i32(resolution.y), {.FULLSCREEN})
	assert(window != nil)

	gpu = sdl.CreateGPUDevice({.MSL, .SPIRV, .DXIL}, true, nil)

	ok = sdl.ClaimWindowForGPUDevice(gpu, window)
	assert(ok)

	init_transfer_mem()
	init_pipelines()

	// init_beacons()

	if DEBUG_MODE { 
		fmt.println("\ninit finished")
		test_collides()
	}
}
	

init_transfer_mem :: proc()
{
	// setup vertex buffers

	batch_shape_inputs_vertex_buffer = sdl.CreateGPUBuffer(gpu, {
		usage = {.VERTEX},
		size = u32(batch_shape_inputs_byte_size)
	})

	// setup storage buffers

	batch_shape_vertex_storage_buffer = sdl.CreateGPUBuffer(gpu, {
		usage = {.GRAPHICS_STORAGE_READ},
		size = u32(batch_shape_verts_byte_size)
	})
	batch_shape_models_storage_buffer = sdl.CreateGPUBuffer(gpu, {
		usage = {.GRAPHICS_STORAGE_READ},
		size = u32(batch_shape_models_byte_size)
	})

	// grid vertex buffer

	grid_verts := []Grid_Vertex {
		{ position = {0, 0}, color = {0.4, 0.4, 0.4, 1} }, // b
		{ position = {0, 1}, color = {0.4, 0.4, 0.4, 1} }, // t

		{ position = {0, 0}, color = {0.4, 0.4, 0.4, 1} }, // l
		{ position = {1, 0}, color = {0.4, 0.4, 0.4, 1} }, // r
	}
	grid_verts_byte_size := len(grid_verts) * size_of(grid_verts[0]) // TODO: size_of(Grid_Vertex) the same?

	grid_vertex_buffer = sdl.CreateGPUBuffer(gpu, {
		usage = {.VERTEX},
		size = u32(grid_verts_byte_size)
	})

	// sdl ttf
	
	ok := ttf.Init()
	assert(ok)

	font_sfns_mono = ttf.OpenFont("fonts/SFNSMono.ttf", 40)
	if font_sfns_mono == nil {
		fmt.println("ERROR: Couldn't open font")
	}

	font_sfns_mono_2 = ttf.OpenFont("fonts/SFNSMono.ttf", 20)
	if font_sfns_mono_2 == nil {
		fmt.println("ERROR: Couldn't open font")
	}

	text_engine = ttf.CreateGPUTextEngine(gpu)

	// text vertex and index buffers

	text_vertex_buffer = sdl.CreateGPUBuffer(gpu, {
		usage = {.VERTEX},
		size = u32(text_vert_buf_byte_size)
	})

	text_index_buffer = sdl.CreateGPUBuffer(gpu, {
		usage = {.INDEX},
		size = u32(text_index_buf_byte_size)
	})

	// text sampler

	text_sampler = sdl.CreateGPUSampler(gpu, {
		min_filter = .LINEAR,
		mag_filter = .LINEAR,
		mipmap_mode = .LINEAR, // TODO: need?
		address_mode_u = .CLAMP_TO_EDGE,
		address_mode_v = .CLAMP_TO_EDGE,
		address_mode_w = .CLAMP_TO_EDGE, // TODO: need?
	})

	// text geo

	text_items = [dynamic]TTF_Text_Item{}
	create_text_item(REF_TEXT)
	create_text_item(REF_TEXT_2)

	// create main shared transfer buffer for dynamic data

	transfer_buffer_byte_size := batch_shape_inputs_byte_size + 
		batch_shape_verts_byte_size + 
		batch_shape_models_byte_size + 
		text_vert_buf_byte_size + 
		text_index_buf_byte_size

	transfer_buffer = sdl.CreateGPUTransferBuffer(gpu, {
		usage = .UPLOAD,
		size = u32(transfer_buffer_byte_size)
	})

	// copy data into temp transfer buffer for static data

	grid_transfer_buffer := sdl.CreateGPUTransferBuffer(gpu, {
		usage = .UPLOAD,
		size = u32(grid_verts_byte_size)
	})

	transfer_memory := transmute([^]byte)sdl.MapGPUTransferBuffer(gpu, grid_transfer_buffer, false)
	mem.copy(
		transfer_memory,
		raw_data(grid_verts),
		grid_verts_byte_size)

	sdl.UnmapGPUTransferBuffer(gpu, grid_transfer_buffer)

	// upload to gpu

	copy_command_buffer := sdl.AcquireGPUCommandBuffer(gpu) 
	copy_pass := sdl.BeginGPUCopyPass(copy_command_buffer)

	sdl.UploadToGPUBuffer(
		copy_pass, 
		{
			transfer_buffer = grid_transfer_buffer, 
		},
		{
			buffer = grid_vertex_buffer, 
			size = u32(grid_verts_byte_size)
		},
		false
	)

	sdl.EndGPUCopyPass(copy_pass)
	ok = sdl.SubmitGPUCommandBuffer(copy_command_buffer)
	assert(ok)

	sdl.ReleaseGPUTransferBuffer(gpu, grid_transfer_buffer)
}

init_pipelines :: proc()
{
	// load shaders
	// vert
 	vs_wrap_shape := load_shader(
 		gpu, 
 		vs_batch_shape_code, 
 		.VERTEX, 
 		num_uniform_buffers = 1, 
 		num_storage_buffers = 2
 	)
 	vs_grid := load_shader(
 		gpu, 
 		vs_grid_code, 
 		.VERTEX, 
 		num_uniform_buffers = 3
 	)
	vs_text := load_shader(
		gpu,
		vs_text_code,
		.VERTEX,
		num_uniform_buffers = 1
	)
	// frag
	fs_solid_col := load_shader(
		gpu, 
		fs_solid_color_code, 
		.FRAGMENT, 
		num_uniform_buffers = 1
	)
	fs_sdf_quad := load_shader(
		gpu, 
		fs_sdf_quad_code, 
		.FRAGMENT, 
		num_uniform_buffers = 1
	)
	fs_text := load_shader(
		gpu, 
		fs_text_code, 
		.FRAGMENT, 
		num_samplers = 1
	)

	// setup base fill pipeline    

	fill_vertex_attributes := []sdl.GPUVertexAttribute {
		{
			location = 0,
			format = .UINT,
			offset = u32(offset_of(Batch_Shape_Input, vertex_index)),
		},
		{
			location = 1,
			format = .UINT,
			offset = u32(offset_of(Batch_Shape_Input, model_index)),
		}
	}  

	color_target : sdl.GPUColorTargetDescription = {
		format = sdl.GetGPUSwapchainTextureFormat(gpu, window),
		blend_state = {
			enable_blend = true,
			color_blend_op = .ADD,
			alpha_blend_op = .ADD,
			src_color_blendfactor = .SRC_ALPHA,
			dst_alpha_blendfactor = .ONE_MINUS_SRC_ALPHA,
			src_alpha_blendfactor = .SRC_ALPHA,
			dst_color_blendfactor = .ONE_MINUS_SRC_ALPHA
		}
	}

	pipeline_info : sdl.GPUGraphicsPipelineCreateInfo = {
		vertex_shader = vs_wrap_shape,
		fragment_shader = fs_solid_col,
		primitive_type = .TRIANGLELIST,
		target_info = {
			num_color_targets = 1,
			color_target_descriptions = &color_target,
		},
		vertex_input_state = {
			num_vertex_buffers = 1,
			vertex_buffer_descriptions = (&sdl.GPUVertexBufferDescription {
				slot = 0,
				pitch = size_of(Batch_Shape_Input),
				input_rate = .VERTEX,
				instance_step_rate = 0
			}),
			num_vertex_attributes = u32(len(fill_vertex_attributes)),
			vertex_attributes = raw_data(fill_vertex_attributes)
		},
	}

	pipeline_fill = sdl.CreateGPUGraphicsPipeline(gpu, pipeline_info)

	// sdf quad pipeline

	pipeline_info.fragment_shader = fs_sdf_quad
	pipeline_sdf =  sdl.CreateGPUGraphicsPipeline(gpu, pipeline_info)

	// background grid pipeline

	grid_vertex_attributes := []sdl.GPUVertexAttribute {
		{
			location = 0,
			format = .FLOAT2,
			offset = u32(offset_of(Grid_Vertex, position)),
		},
		{
			location = 1,
			format = .FLOAT4,
			offset = u32(offset_of(Grid_Vertex, color)),
		}
	}

	grid_vertex_input_state: sdl.GPUVertexInputState = {
		num_vertex_buffers = 1,
		vertex_buffer_descriptions = (&sdl.GPUVertexBufferDescription {
			slot = 0,
			pitch = size_of(Grid_Vertex),
			input_rate = .VERTEX,
			instance_step_rate = 0
		}),
		num_vertex_attributes = u32(len(grid_vertex_attributes)),
		vertex_attributes = raw_data(grid_vertex_attributes)
	}

	pipeline_info.vertex_shader = vs_grid
	pipeline_info.fragment_shader = fs_solid_col
	pipeline_info.primitive_type = .LINELIST
	pipeline_info.vertex_input_state = grid_vertex_input_state

	pipeline_bkg = sdl.CreateGPUGraphicsPipeline(gpu, pipeline_info)

	// ttf text pipeline

	text_vertex_attributes := []sdl.GPUVertexAttribute {
		{
			location = 0,
			format = .FLOAT2,
			offset = u32(offset_of(Text_Vertex, position)),
		},
		{
			location = 1,
			format = .FLOAT4,
			offset = u32(offset_of(Text_Vertex, color)),
		},
		{
			location = 2,
			format = .FLOAT2,
			offset = u32(offset_of(Text_Vertex, uv)),
		},
	}

	text_vertex_input_state: sdl.GPUVertexInputState = {
		num_vertex_buffers = 1,
		vertex_buffer_descriptions = (&sdl.GPUVertexBufferDescription {
			slot = 0,
			pitch = size_of(Text_Vertex),
			input_rate = .VERTEX,
			instance_step_rate = 0
		}),
		num_vertex_attributes = u32(len(text_vertex_attributes)),
		vertex_attributes = raw_data(text_vertex_attributes)
	}

	pipeline_info.vertex_shader = vs_text
	pipeline_info.fragment_shader = fs_text
	pipeline_info.primitive_type = .TRIANGLELIST
	pipeline_info.vertex_input_state = text_vertex_input_state

	pipeline_text = sdl.CreateGPUGraphicsPipeline(gpu, pipeline_info)

	// cleanup

	sdl.ReleaseGPUShader(gpu, vs_wrap_shape)
	sdl.ReleaseGPUShader(gpu, vs_grid)
	sdl.ReleaseGPUShader(gpu, vs_text)
	sdl.ReleaseGPUShader(gpu, fs_solid_col)
	sdl.ReleaseGPUShader(gpu, fs_sdf_quad)
	sdl.ReleaseGPUShader(gpu, fs_text)
}


