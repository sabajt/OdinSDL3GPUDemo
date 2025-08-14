package main

import "core:fmt"

update_pause_menu :: proc()
{
	switch menu_request {

	case .up:
		pause_menu_option = Pause_Menu_Option(max(0, int(pause_menu_option) - 1))

	case .down:
		pause_menu_option = Pause_Menu_Option(min(int(Pause_Menu_Option.quit), int(pause_menu_option) + 1))

	case .select:
		pause_menu_selected()

	case .none:
	}

	menu_request = .none
}

pause_menu_selected :: proc()
{
	switch pause_menu_option {

	case .resume:
		game_state = .active

	case .quit:
		reset_to_title()
	}
}




