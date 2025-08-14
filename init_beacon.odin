#+feature dynamic-literals

package main

import sa "core:container/small_array"

beacons : [dynamic]Geo_Collider 

init_beacons :: proc()
{
	col := [4]f32 { 0.4, 0.8, 0.9, 1 }

	// layered squares beacon

	l0 : sa.Small_Array(GEO_COLLIDER_MAX_LAYERS, Geo_Layer)
	sa.append_elem(&l0, Geo_Layer {rad = 110, res = 4, rot = 0, mode = .Line, col = col})
	sa.append_elem(&l0, Geo_Layer {rad = 90, res = 4, rot = 0, mode = .Line, col = col})
	sa.append_elem(&l0, Geo_Layer {rad = 70, res = 4, rot = 0, mode = .Line, col = col})
	sa.append_elem(&l0, Geo_Layer {rad = 50, res = 4, rot = 0, mode = .Line, col = col})
	sa.append_elem(&l0, Geo_Layer {rad = 30, res = 4, rot = 0, mode = .Line, col = col})
	sa.append_elem(&l0, Geo_Layer {rad = 10, res = 4, rot = 0, mode = .Line, col = col})

	b0 := Geo_Collider { 
		type = .Beacon,
		t = 0,
		last_t = 0,
		layers = l0,
		pos = {600, 300},
		last_pos = {600, 300},
		acl_speed = 0,
		vel = {0, 0},
		collide_rad = 110,
		alpha = 1,
		rot = 0
	}

	append(&beacons, b0)

	// circle with outer ring beacon

	l1 : sa.Small_Array(GEO_COLLIDER_MAX_LAYERS, Geo_Layer)
	sa.append_elem(&l1, Geo_Layer {rad = 140, res = 30, rot = 0, mode = .Line})
	sa.append_elem(&l1, Geo_Layer {rad = 70, res = 24, rot = 0, mode = .Solid})

	b1 := Geo_Collider { 
		type = .Beacon,
		t = 0,
		last_t = 0,
		layers = l1,
		pos = {800, 700},
		last_pos = {800, 700},
		acl_speed = 0,
		vel = {0, 0},
		collide_rad = 140,
		col = col.rgb,
		alpha = 1,
		rot = 0
	}

	append(&beacons, b1)
}


