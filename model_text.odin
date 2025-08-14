package main

import ttf "vendor:sdl3/ttf"

text_engine : ^ttf.TextEngine

font_sfns_mono : ^ttf.Font
font_sfns_mono_2 : ^ttf.Font

REF_TEXT := cstring("The quick brown fox jumped over\nthe lava pit")
REF_TEXT_2 := cstring("Zoomacroom, Birdie, Mouse, Sidney.")

text_items : [dynamic]TTF_Text_Item

TTF_Text_Item :: struct {
    raw_string : cstring,
    text : ^ttf.Text,
    atlas_draw_seq : ^ttf.GPUAtlasDrawSequence,
    geo_data : ^Text_Geometry_Data
}

create_text_item :: proc(raw_string: cstring) 
{
    geo_data := new(Text_Geometry_Data)
	geo_data.vertices = [dynamic]Text_Vertex{}
	geo_data.indices = [dynamic]u32{}

    ttf_text := ttf.CreateText(text_engine, font_sfns_mono, raw_string, 0)

    item := TTF_Text_Item {
        raw_string = raw_string,
        text = ttf_text,
        atlas_draw_seq = ttf.GetGPUTextDrawData(ttf_text),
        geo_data = geo_data
    }

    append(&text_items, item)
}

Text_Geometry_Data :: struct {
    vertices : [dynamic]Text_Vertex,
    indices : [dynamic]u32
}


