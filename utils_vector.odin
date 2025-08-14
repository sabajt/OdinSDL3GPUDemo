package main

import "core:math"
import "core:math/rand"
import "core:math/linalg"

pvec :: proc(a: f32, r: f32) -> [2]f32
{
	return { 
		r * math.cos(a),
		r * math.sin(a) 
	} 
}

limvec ::proc(v: [2]f32, max: f32) -> [2]f32
{
	return linalg.length(v) > max ? max * linalg.normalize(v) : v 
}

rand_screen_vec :: proc() -> [2]f32
{
	return camera.pos + {
		rand.float32() * resolution.x, 
		rand.float32() * resolution.y
	}
}

