package main

Enemy_Type :: enum {
	Seeker,
	Path 
}

Enemy :: struct {
	type: Enemy_Type,
	t: int,
	geo: Geo_Collider,
	seek_i: int, // Seeker only: 0 or 1 (player 1 / 2)
	path_type: Enemy_Path_Type, // Path only: map to movement path functions
}

// Seeker

create_enemy_seeker :: proc(geo: Geo_Collider, seek_i: int) -> Enemy {
	return Enemy {
		type = .Seeker,
		t = 0,
		geo = geo,
		seek_i = seek_i,
		path_type = .none // not used
	}
}

// Path

Enemy_Path_Type :: enum {
	none,
	wavey_slowdown,
	zigzag
}

create_enemy_path :: proc(geo: Geo_Collider, path_type: Enemy_Path_Type) -> Enemy {
	return Enemy {
		type = .Path,
		t = 0,
		geo = geo,
		seek_i = 0, // not used
		path_type = path_type
	}
}


