package main

import "core:math"
import "core:math/rand"

rand_rot :: proc() -> f32 
{
	return rand.float32() * math.TAU
}

