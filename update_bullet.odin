package main

import "core:math"
import "core:fmt"

update_bullets :: proc ()
{	
	remove_bullets := [dynamic]int{}
	defer { delete(remove_bullets) }

	remove_enemies := [dynamic]int{}
	defer { delete(remove_enemies) }

	for &b, bi in bullets {

		b.last_col = b.col
		t := b.t / b.life 
		if t > b.fadeout_start_t {
			b.col.a = 1 - (t - b.fadeout_start_t) / (1 - b.fadeout_start_t)
		}

		b.last_pos = b.pos
		b.pos += b.vel
		b.last_t = b.t
		b.t += 1

		b.vel *= b.ease
		
		bullet_removed := false

		// TODO: bug in that same enemy could get removed by multiple bullets here gone b/c of "hot swap"? 

		for e, ei in enemies {
			if collide(e.geo.pos, e.geo.collide_rad, b.pos, b.rad){

				ordered_remove(&enemies, ei)

				if !bullet_removed {
					bullet_removed = true
					ordered_remove(&bullets, bi)
				}

				create_enemy_explode_effect(e)
 			}
		}

		if !bullet_removed && b.t > b.life { 
			ordered_remove(&bullets, bi)
		}
	}
}




