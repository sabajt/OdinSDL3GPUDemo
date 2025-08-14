package main

import "core:fmt"

DEBUG_MODE : bool = false

Debug_Context :: struct {
	max_batch_shape_inputs: int,
	max_batch_shape_vertices: int,
	max_batch_shape_models: int,

	render_cycle: int
}

debug_context := Debug_Context {
	max_batch_shape_inputs = 0,
	max_batch_shape_vertices = 0,
	max_batch_shape_models = 0,

	render_cycle = 0
}

debug_print_stream :: proc(args: ..any, f: u64 = 5) 
{
	if sim_time % (MS_PER_UPDATE * f) == 0 {
		fmt.println(args = args)
	}
}

