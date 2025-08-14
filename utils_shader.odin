package main

import sdl "vendor:sdl3"

load_shader :: proc(
	device: ^sdl.GPUDevice, 
	code: []u8, 
	stage: sdl.GPUShaderStage, 
	num_samplers: u32 = 0,
	num_uniform_buffers: u32 = 0, 
	num_storage_buffers: u32 = 0,
	num_storage_textures: u32 = 0) -> ^sdl.GPUShader 
{
	return sdl.CreateGPUShader(device, {
		code_size = len(code),
		code = raw_data(code),   
		entrypoint = "main0",
		format = {.MSL},
		stage = stage,
		num_samplers = num_samplers,
		num_uniform_buffers = num_uniform_buffers,
		num_storage_buffers = num_storage_buffers,
		num_storage_textures = num_storage_textures
	})
}
