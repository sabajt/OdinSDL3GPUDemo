package main

import "core:math"
import "core:math/linalg"

update_bombs :: proc()
{
	for &b, bi in bombs {
		update_bomb_movement(&b)

		b.last_t = b.t
		b.t += 1

		if b.detonate { 
			bomb_explode(b)
			ordered_remove(&bombs, bi)
		}
	}	
}

update_bomb_movement :: proc(b: ^Bomb)
{
	// analog bomb control

	right_x_axis_val := abs(player_2.right_x_axis_val) > AXIS_CUTOFF ? player_2.right_x_axis_val : 0
	right_y_axis_val := abs(player_2.right_y_axis_val) > AXIS_CUTOFF ? player_2.right_y_axis_val : 0

	move_bomb : bool = abs(right_x_axis_val) > AXIS_CUTOFF || abs(right_y_axis_val) > AXIS_CUTOFF
	if move_bomb {
		acl := b.ACL * [2]f32 {right_x_axis_val, right_y_axis_val}
		b.vel += acl
	}

	// apply drag if >0 vel

	if linalg.dot(b.vel, b.vel) > 0 {
		b.vel = max(linalg.length(b.vel) - b.DRAG, 0) * linalg.normalize(b.vel)
	}

	// limit to max speed and pos

	b.vel = limvec(b.vel, b.MAX_SPEED)
	b.last_pos = b.pos
	b.pos += b.vel
}

bomb_explode :: proc(b: Bomb)
{
	res := int(8)
	for i : int = 0; i < res; i += 1 {
		angle := math.TAU * f32(i) / f32(res)

		dir := [2]f32 { 
			math.cos(angle), 
			math.sin(angle) 
		}

		bullet := create_bullet(
			pos = b.pos,
			vel = 16.0 * dir,
			rad = 12, 
			col = {1,1,1,1},
			life = 30,
			thic = 10,
			fade = 4,
			ease = 0.92
		)
		append(&bullets, bullet)
	}
}

