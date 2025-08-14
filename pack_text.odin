package main

import "core:fmt"
import "core:mem"
import sdl "vendor:sdl3"
import ttf "vendor:sdl3/ttf"
import "core:strings"

LETTER_SPACING := f32(75)

clear_text :: proc()
{
	for item in text_items {
		clear(&item.geo_data.vertices)
		clear(&item.geo_data.indices)
	}
}

pack_text_ttf :: proc()
{
	for &item in text_items {
		pack_text_item(&item)
	}
}

// TODO: prob don't need to rebuild every frame (including clear...)
pack_text_item :: proc(item: ^TTF_Text_Item)
{
	// TODO: position text by size
	text_size : [2]i32
	ok := ttf.GetTextSize(item.text, &text_size.x, &text_size.y)
	if !ok { fmt.println("Error getting text size") }

	for seq := item.atlas_draw_seq; seq != nil; seq = seq.next {

		// verts
		for i := 0; i32(i) < seq.num_vertices; i += 1 {
			xy := ([2]f32)(seq.xy[i])
			uv := ([2]f32)(seq.uv[i])

			vert := Text_Vertex {
				position = xy,
				color = {1, 1, 1, 1},
				uv = uv
			}
			append(&item.geo_data.vertices, vert)
		}

		// indices
		for i := 0; i32(i) < seq.num_indices; i+= 1 {
			append(&item.geo_data.indices, u32(seq.indices[i]))
		}
    }
}

pack_text :: proc(text: []string, pos: [2]f32, scale: [2]f32 = {1, 1}) 
{
	for s, i in text {
		switch s {
		case "a": pack_letter(vert_ref_a, {pos.x + f32(i) * LETTER_SPACING, pos.y}, scale)
		case "d": pack_letter(vert_ref_d, {pos.x + f32(i) * LETTER_SPACING, pos.y}, scale)
		case "e": pack_letter(vert_ref_e, {pos.x + f32(i) * LETTER_SPACING, pos.y}, scale)
		case "i": pack_letter(vert_ref_i, {pos.x + f32(i) * LETTER_SPACING, pos.y}, scale)
		case "g": pack_letter(vert_ref_g, {pos.x + f32(i) * LETTER_SPACING, pos.y}, scale)
		case "m": pack_letter(vert_ref_m, {pos.x + f32(i) * LETTER_SPACING, pos.y}, scale)
		case "n": pack_letter(vert_ref_n, {pos.x + f32(i) * LETTER_SPACING, pos.y}, scale)
		case "o": pack_letter(vert_ref_0, {pos.x + f32(i) * LETTER_SPACING, pos.y}, scale) // O is just 0
		case "p": pack_letter(vert_ref_p, {pos.x + f32(i) * LETTER_SPACING, pos.y}, scale)
		case "r": pack_letter(vert_ref_r, {pos.x + f32(i) * LETTER_SPACING, pos.y}, scale)
		case "s": pack_letter(vert_ref_s, {pos.x + f32(i) * LETTER_SPACING, pos.y}, scale)
		case "t": pack_letter(vert_ref_t, {pos.x + f32(i) * LETTER_SPACING, pos.y}, scale)
		case "u": pack_letter(vert_ref_u, {pos.x + f32(i) * LETTER_SPACING, pos.y}, scale)
		case "v": pack_letter(vert_ref_v, {pos.x + f32(i) * LETTER_SPACING, pos.y}, scale)
		case "z": pack_letter(vert_ref_z, {pos.x + f32(i) * LETTER_SPACING, pos.y}, scale)

		case "0": pack_letter(vert_ref_0, {pos.x + f32(i) * LETTER_SPACING, pos.y}, scale)
		case "1": pack_letter(vert_ref_1, {pos.x + f32(i) * LETTER_SPACING, pos.y}, scale)
		case "2": pack_letter(vert_ref_2, {pos.x + f32(i) * LETTER_SPACING, pos.y}, scale)
		case "3": pack_letter(vert_ref_3, {pos.x + f32(i) * LETTER_SPACING, pos.y}, scale)
		case "4": pack_letter(vert_ref_4, {pos.x + f32(i) * LETTER_SPACING, pos.y}, scale)
		case "5": pack_letter(vert_ref_s, {pos.x + f32(i) * LETTER_SPACING, pos.y}, scale) // 5 is just S
		case "6": pack_letter(vert_ref_6, {pos.x + f32(i) * LETTER_SPACING, pos.y}, scale)
		case "7": pack_letter(vert_ref_7, {pos.x + f32(i) * LETTER_SPACING, pos.y}, scale)
		case "8": pack_letter(vert_ref_8, {pos.x + f32(i) * LETTER_SPACING, pos.y}, scale)
		case "9": pack_letter(vert_ref_9, {pos.x + f32(i) * LETTER_SPACING, pos.y}, scale)

		}
	}
}

pack_text_center_x :: proc(text: []string, cam: [2]f32, y: f32, scale: [2]f32 = {1, 1}) 
{
	line_len := f32(len(text)) * LETTER_SPACING
	x := (resolution.x - line_len) / 2.0

	pack_text(text, cam + {x, y}, scale)
}

pack_letter :: proc(vert_ref: Vert_Ref, pos: [2]f32, scale: [2]f32 = {1, 1})
{
 	model := create_batch_shape_model(
		pos = pos, 
		rot = 0, 
		scale = scale, 
		col = COL_WHITE, 
		thic = 0, 
		fade = 0, 
		period = 0
	)
	pack_batch_shape_vert_ref(
 		vert_index = vert_ref.i, 
 		count = vert_ref.len, 
 		model = model
 	)
}

