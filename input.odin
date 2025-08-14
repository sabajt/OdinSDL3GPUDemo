package main

import "core:fmt"
import "core:math/linalg"
import "core:math"
import sdl "vendor:sdl3"

gamepad_1 : ^sdl.Gamepad
gamepad_2 : ^sdl.Gamepad

AXIS_CUTOFF : f32 = 0.3

handle_input :: proc(event: ^sdl.Event) -> sdl.AppResult 
{
	result : sdl.AppResult  

	switch game_state {
	case .active:
		result = handle_input_active(event)
	case .paused:
		result = handle_input_paused(event)
	case .title:
		result = handle_input_active(event) // TODO: map start / esc to begin game instead of pause
	case .game_over:
		result = handle_input_game_over(event)
	}

	return result
}

handle_input_game_over :: proc(event: ^sdl.Event) -> sdl.AppResult
{
	#partial switch event.type {
	case .QUIT:
		return .SUCCESS

	case .KEY_DOWN:
		#partial switch event.key.scancode {
		case .Q:
			return .SUCCESS

		case .ESCAPE:
			handle_start_pressed()
		}
	case .GAMEPAD_BUTTON_DOWN:
		button := sdl.GamepadButton(event.gbutton.button)

		// let any player control menu
		#partial switch button {
		case .START:
			handle_start_pressed()
		}
	}

	return .CONTINUE
}

handle_input_paused :: proc(event: ^sdl.Event) -> sdl.AppResult 
{
	#partial switch event.type {

    case .QUIT:
    	return .SUCCESS

    case .KEY_DOWN:
		#partial switch event.key.scancode {

		case .Q:
			return .SUCCESS

		case .ESCAPE:
			handle_start_pressed()

		case .UP:
			handle_menu_up()

		case .DOWN:
			handle_menu_down()

		case .RETURN:
			handle_menu_select()
		}

	case .GAMEPAD_BUTTON_DOWN:
		button := sdl.GamepadButton(event.gbutton.button)

		// let any player control menu

		#partial switch button {

		case .DPAD_UP:
			handle_menu_up()

		case .DPAD_DOWN:
			handle_menu_down()

		case .EAST:
			handle_menu_select()

		case .START:
			handle_start_pressed()
		}		
    }

    return .CONTINUE
}

handle_input_active :: proc(event: ^sdl.Event) -> sdl.AppResult 
{
	#partial switch event.type {

    case .QUIT:
    	return .SUCCESS

	case .KEY_DOWN:
		#partial switch event.key.scancode {

		case .Q:
			return .SUCCESS

		case .P:
			handle_create_particle()

		case .ESCAPE:
			handle_start_pressed()

		case .SPACE:
			handle_shoot_player_1()

		case .LEFT:
			handle_p1_rotate_start(.Left)

		case .RIGHT:
			handle_p1_rotate_start(.Right)

		case .UP:
			handle_p1_acl_start()

		case .DOWN:
			handle_p1_reverse_acl_start()
		}

	case .KEY_UP:
		#partial switch event.key.scancode {

		case .LEFT:
			handle_p1_rotate_end(.Left)

		case .RIGHT:
			handle_p1_rotate_end(.Right)

		case .UP:
			handle_p1_acl_end()

		case .DOWN:
			handle_p1_reverse_acl_end()
		}

	case .GAMEPAD_ADDED:
		fmt.println("gdevice added = ", event.gdevice.which)
		handle_gamepad_added(event.gdevice.which)

	case .GAMEPAD_REMOVED:
		fmt.println("gdevice removed = ", event.gdevice.which)
		handle_gamepad_removed(event.gdevice.which)

	case .GAMEPAD_AXIS_MOTION:

		// Gamepad 1 

		jid_1 : sdl.JoystickID = 0
		if gamepad_1 != nil {
			jid_1 = sdl.GetGamepadID(gamepad_1)
		}

		jid_2 : sdl.JoystickID = 0
		if gamepad_2 != nil {
			jid_2 = sdl.GetGamepadID(gamepad_2)
		}

		if event.gaxis.which == jid_1 {
			axis := sdl.GamepadAxis(event.gaxis.axis)

			#partial switch axis {
			case .LEFTX, .LEFTY:
				handle_p1_rotate_left_axis(sdl.GamepadAxis(event.gaxis.axis), event.gaxis.value)
			case .LEFT_TRIGGER, .RIGHT_TRIGGER:
				if event.gaxis.value > 0 {
					handle_shoot_player_1()
				}
			}
		}

		if event.gaxis.which == jid_2 {
			axis := sdl.GamepadAxis(event.gaxis.axis)

			#partial switch axis {
			case .LEFTX, .LEFTY:
				handle_p2_rotate_left_axis(sdl.GamepadAxis(event.gaxis.axis), event.gaxis.value)
			case .RIGHTX, .RIGHTY:
				handle_p2_rotate_right_axis(sdl.GamepadAxis(event.gaxis.axis), event.gaxis.value)
			case .LEFT_TRIGGER, .RIGHT_TRIGGER:
				if event.gaxis.value > 0 {
					handle_detonate_bomb_player_2()
				}
			}
		}
	

	case .GAMEPAD_BUTTON_DOWN:
		button := sdl.GamepadButton(event.gbutton.button)

		// Gamepad 1 

		jid_1 : sdl.JoystickID = 0
		if gamepad_1 != nil {
			jid_1 = sdl.GetGamepadID(gamepad_1)
		}

		if event.gbutton.which == jid_1 {

			#partial switch button {

			case .LEFT_SHOULDER, .RIGHT_SHOULDER:
				handle_shoot_player_1()

			case .DPAD_LEFT:
				handle_p1_rotate_start(.Left)

			case .DPAD_RIGHT:
				handle_p1_rotate_start(.Right)

			case .EAST:
				handle_p1_acl_start()

			case .SOUTH:
				handle_p1_reverse_acl_start()	

			case .START:
				handle_start_pressed()
			}

			return .CONTINUE
		}

		// Gamepad 2

		jid_2 : sdl.JoystickID = 0
		if gamepad_2 != nil {
			jid_2 = sdl.GetGamepadID(gamepad_2)
		}

		if event.gbutton.which == jid_2 {
			
		#partial switch button {

			case .LEFT_SHOULDER, .RIGHT_SHOULDER:
				handle_detonate_bomb_player_2()

			case .EAST:
				handle_shoot_player_2()

			case .START:
				handle_start_pressed()
			}

			return .CONTINUE
		}

	case .GAMEPAD_BUTTON_UP:
		button := sdl.GamepadButton(event.gbutton.button)

		// Gamepad 1 

		jid_1 : sdl.JoystickID = 0
		if gamepad_1 != nil {
			jid_1 = sdl.GetGamepadID(gamepad_1)
		}

		if event.gbutton.which == jid_1 {

			#partial switch button {

			case .DPAD_LEFT:
				handle_p1_rotate_end(.Left)

			case .DPAD_RIGHT:
				handle_p1_rotate_end(.Right)

			case .EAST:
				handle_p1_acl_end()

			case .SOUTH:
				handle_p1_reverse_acl_end()	
			}

			return .CONTINUE
		}

		// Gamepad 2

		jid_2 : sdl.JoystickID = 0
		if gamepad_2 != nil {
			jid_2 = sdl.GetGamepadID(gamepad_2)
		}

		if event.gbutton.which == jid_2 {

			return .CONTINUE
		}
	}
	return .CONTINUE
}

// Pause / Menu / Navigation

handle_start_pressed :: proc()
{
	switch game_state {
	case .title:
		// start game
		game_state = .active
		create_next_enemy_wave()

	case .active:
		// pause
		game_state = .paused
		pause_menu_option = .resume

	case .paused:
		// resume
		game_state = .active

	case .game_over:
		reset_to_title()
	}
}

handle_menu_up :: proc()
{
	menu_request = .up
}

handle_menu_down :: proc()
{
	menu_request = .down
}

handle_menu_select :: proc()
{
	menu_request = .select
}


// Particles

handle_create_particle :: proc() 
{
	create_random_particles = true
}

// Player 1 actions

handle_shoot_player_1 :: proc()
{
	player_1.shoot = true
}

handle_p1_rotate_start :: proc(dir: Rotate_Dir) 
{
	switch player_1.rot_dir {
	case .None:
		player_1.rot_dir = dir
	case .Left, .Right:
	}
} 

handle_p1_rotate_end :: proc(dir: Rotate_Dir) 
{
	if dir == player_1.rot_dir {
		player_1.rot_dir = .None
	}
}

// TODO: refac this to not ref any gamepad specific stuf?
handle_p1_rotate_left_axis :: proc(axis: sdl.GamepadAxis, value: sdl.Sint16) 
{
	axis_val := f32(value) / f32(max(sdl.Sint16))

	if sdl.GamepadAxis(axis) == sdl.GamepadAxis.LEFTX {
		player_1.left_x_axis_val = axis_val
	}
	if sdl.GamepadAxis(axis) == sdl.GamepadAxis.LEFTY {
		player_1.left_y_axis_val = -axis_val
	}
}

handle_p1_acl_start :: proc() 
{
	player_1.is_acl = true
}

handle_p1_acl_end :: proc() 
{
	player_1.is_acl = false
}

handle_p1_reverse_acl_start :: proc() 
{
	player_1.is_dcl = true
}

handle_p1_reverse_acl_end :: proc() 
{
	player_1.is_dcl = false
	player_1.is_reverse_acl = false
}

// Player 2 actions

handle_p2_rotate_left_axis :: proc(axis: sdl.GamepadAxis, value: sdl.Sint16) 
{
	axis_val := f32(value) / f32(max(sdl.Sint16))

	if sdl.GamepadAxis(axis) == sdl.GamepadAxis.LEFTX {
		player_2.left_x_axis_val = axis_val
	}
	if sdl.GamepadAxis(axis) == sdl.GamepadAxis.LEFTY {
		player_2.left_y_axis_val = -axis_val
	}
}

handle_p2_rotate_right_axis :: proc(axis: sdl.GamepadAxis, value: sdl.Sint16) 
{
	axis_val := f32(value) / f32(max(sdl.Sint16))

	if sdl.GamepadAxis(axis) == sdl.GamepadAxis.RIGHTX {
		player_2.right_x_axis_val = axis_val
	}
	if sdl.GamepadAxis(axis) == sdl.GamepadAxis.RIGHTY {
		player_2.right_y_axis_val = -axis_val
	}
}


handle_shoot_player_2 :: proc()
{
	player_2.shoot = true
}

handle_detonate_bomb_player_2 :: proc()
{
	player_2.detonate = true
}

// Gamepad management

handle_gamepad_added :: proc(jid: sdl.JoystickID) 
{
	fmt.println("gamepad added, jid ", jid)

	if gamepad_1 == nil {
		if jid != sdl.GetGamepadID(gamepad_2) {
			gamepad_1 = sdl.OpenGamepad(jid)
			fmt.println("gamepad 1 opened and assigned")
		}
	} else if gamepad_2 == nil {
		if jid != sdl.GetGamepadID(gamepad_1) {
			gamepad_2 = sdl.OpenGamepad(jid)
			fmt.println("gamepad 2 opened and assigned")
		}
	}
}

handle_gamepad_removed :: proc(jid: sdl.JoystickID) 
{
	fmt.println("gamepad removed, jid ", jid)

	if gamepad_1 != nil && jid == sdl.GetGamepadID(gamepad_1) {
		sdl.CloseGamepad(gamepad_1)
		gamepad_1 = nil
		fmt.println("gamepad 1 closed and unassigned")
	} else if gamepad_2 != nil && jid == sdl.GetGamepadID(gamepad_2) {
		sdl.CloseGamepad(gamepad_2)
		gamepad_2 = nil
		fmt.println("gamepad 2 closed and unassigned")
	}
}


