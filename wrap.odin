package main

wrap_pos :: proc(pos: [2]f32, cam: [2]f32) -> [2]f32
{
	result := pos

	if pos.x < cam.x {
		result.x = pos.x + resolution.x
	} else if pos.x > cam.x + resolution.x {
		result.x = pos.x - resolution.x
	}

	if pos.y < cam.y {
		result.y = pos.y + resolution.y
	} else if pos.y > cam.y + resolution.y {
		result.y = pos.y - resolution.y

	}
	return result
}

