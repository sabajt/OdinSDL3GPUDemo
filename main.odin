package main

import "core:fmt"
import "core:os"
import "core:math/linalg"
import "base:runtime"
import "core:math"
import sdl "vendor:sdl3"

// window

window: ^sdl.Window

// resolution := [2]f32 {2040, 1090} // almost fullscreen window (big monitor)
// resolution := [2]f32 {2048, 1152} // fullscreen (big monitor)
// resolution := [2]f32 {1600, 900}
resolution := [2]f32 {1800, 1000}
// resolution := [2]f32 {1200, 800}
// resolution := [2]f32 {1000, 700}
// resolution := [2]f32 {800, 600}
// resolution := [2]f32 {600, 600}
 
// frame timing

real_time := sdl.Uint64(0)
sim_time := sdl.Uint64(0)
lag_time := sdl.Uint64(0)

MAX_FRAME_TIME : sdl.Uint64 : sdl.Uint64(0.25 * 1000.0)
MS_PER_UPDATE : sdl.Uint64 : 16

// other constants

ROTATION_OFFSET := f32(linalg.PI / 2.0)
GRID_PADDING : f32 : 100.0

// main entry point

main :: proc() 
{
	fmt.println("\n* SDL EnterAppMainCallbacks *", sdl.GetError())
	exit_code := sdl.EnterAppMainCallbacks(0, nil, AppInit, AppIterate, AppEvent, AppQuit)
	fmt.println("final error = ", sdl.GetError())
    os.exit(int(exit_code))
}

// app callbacks

AppInit :: proc "c" (appstate: ^rawptr, argc: i32, argv: [^]cstring) -> sdl.AppResult 
{
	context = runtime.default_context()

	init()

	return .CONTINUE
}

AppIterate :: proc "c" (appstate: rawptr) -> sdl.AppResult 
{
	context = runtime.default_context()

	new_time := sdl.GetTicks()
	frame_time := new_time - real_time

	if frame_time > MAX_FRAME_TIME {
		if DEBUG_MODE { fmt.printfln("\n[!] simulation slowdown: frame time %v MS exceeded max %v MS.", frame_time, MAX_FRAME_TIME) }
		frame_time = MAX_FRAME_TIME
	}

	real_time = new_time
	lag_time += frame_time

	for lag_time >= MS_PER_UPDATE {
		sim_time += MS_PER_UPDATE
		update()
		lag_time -= MS_PER_UPDATE
	}

	dt := f32(lag_time) / f32(MS_PER_UPDATE)

	// render
	render(dt)

	return .CONTINUE
}

AppEvent :: proc "c" (appstate: rawptr, event: ^sdl.Event) -> sdl.AppResult 
{
	context = runtime.default_context()

	return handle_input(event)
}

AppQuit :: proc "c" (appstate: rawptr, result: sdl.AppResult) 
{
	context = runtime.default_context()

	fmt.println("\n* App Quit *")

	if DEBUG_MODE {
		fmt.printfln("\nDebug Context:\n- max batch shape inputs: %v\n- max batch shape verts: %v\n- max batch shape models: %v\n", debug_context.max_batch_shape_inputs, debug_context.max_batch_shape_vertices, debug_context.max_batch_shape_models)
	}

	delete(batch_shape_inputs)
	delete(batch_shape_verts)
	delete(batch_shape_models)
	delete(radius_effects)
	delete(enemies)
	delete(next_enemies)
	delete(next_enemy_in_effects)
	delete(beacons)
	delete(bullets)
	delete(bombs)
	delete(text_items) // TODO: how to properly delete nested things?
}


