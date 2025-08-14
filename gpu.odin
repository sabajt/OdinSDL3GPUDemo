package main

import sdl "vendor:sdl3"

// gpu resources

gpu: ^sdl.GPUDevice

pipeline_fill: ^sdl.GPUGraphicsPipeline
pipeline_sdf: ^sdl.GPUGraphicsPipeline
pipeline_bkg: ^sdl.GPUGraphicsPipeline
pipeline_text: ^sdl.GPUGraphicsPipeline

grid_vertex_buffer: ^sdl.GPUBuffer

transfer_buffer: ^sdl.GPUTransferBuffer

// text

text_vertex_buffer: ^sdl.GPUBuffer
text_index_buffer: ^sdl.GPUBuffer
text_sampler: ^sdl.GPUSampler

TEXT_VERT_BUF_MAX_SIZE := int(4000)
TEXT_INDEX_BUF_MAX_SIZE := int(6000)

text_vert_buf_byte_size := size_of(Text_Vertex) * TEXT_VERT_BUF_MAX_SIZE
text_index_buf_byte_size := size_of(u32) * TEXT_INDEX_BUF_MAX_SIZE

// batch fill shapes

batch_shape_inputs := [dynamic]Batch_Shape_Input {}
batch_shape_inputs_byte_size := 80_000 * size_of(Batch_Shape_Input) // TODO: rename max size?
batch_shape_inputs_vertex_buffer : ^sdl.GPUBuffer

batch_shape_verts := [dynamic]Batch_Shape_Vertex {}
batch_shape_verts_byte_size := 40_000 * size_of(Batch_Shape_Vertex) 
batch_shape_vertex_storage_buffer: ^sdl.GPUBuffer

batch_shape_models := [dynamic]Batch_Shape_Model {}
batch_shape_models_byte_size := 20_000 * size_of(Batch_Shape_Model)
batch_shape_models_storage_buffer : ^sdl.GPUBuffer

first_sdf_input := int(0)
last_sdf_input := int(0)

