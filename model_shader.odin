package main

import "core:math/linalg"

// shaders

vs_grid_code := #load("shaders/compiled/msl/Grid.vert.msl")
vs_batch_shape_code := #load("shaders/compiled/msl/BatchShape.vert.msl")
vs_text_code := #load("shaders/compiled/msl/Text.vert.msl")

fs_solid_color_code := #load("shaders/compiled/msl/SolidColor.frag.msl")
fs_sdf_quad_code := #load("shaders/compiled/msl/SDFQuad.frag.msl")
fs_text_code := #load("shaders/compiled/msl/Text.frag.msl")

// shader input

Batch_Shape_Input :: struct {
	vertex_index : uint,
	model_index : uint,
}

Batch_Shape_Vertex :: struct {
	color : [4]f32,
	position : [2]f32,
	padding : [2]f32
}

Batch_Shape_Model :: struct {
    position: [3]f32,
    rotation: f32,
    scale: [2]f32,
    padding_a: [2]f32,
    color: [4]f32, // overrides vert colors
    thic: f32, // thickness of circle if SDF
    fade: f32, // fade length of circle if SDF
    period: f32, // for solid rendering: 0 -> solid, >=2 -> transparent "stripes"
    padding_b: f32
}

create_batch_shape_model :: proc(
    pos: [2]f32,
    rot: f32,
    scale: [2]f32,
    col: [4]f32, 
    thic: f32,
    fade: f32, 
    period: f32) -> Batch_Shape_Model
{
	return Batch_Shape_Model {
		position = {pos.x, pos.y, 1},
		rotation = rot,
		scale = scale,
		color = col,
		thic = thic,
		fade = fade,
		period = period
	}
}

Grid_Vertex :: struct {
	position : [2]f32,
	color : [4]f32 
}

Text_Vertex :: struct {
	position : [2]f32,
	color : [4]f32, 
	uv : [2]f32
}

// shader uniforms

View_Projection :: struct {
	view_projection : linalg.Matrix4x4f32
}

Mvp_Ubo :: struct {
	mvp : linalg.Matrix4x4f32
}

Res_Ubo :: struct {
	res_cam : [4]f32
}

Axis_Ubo :: struct {
	x_axis : uint
}

Offset_Ubo :: struct {
	offset: f32
}
