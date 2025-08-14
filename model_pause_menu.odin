package main

Pause_Menu_Option :: enum {
	resume = 0,
	quit = 1
}

pause_menu_option: Pause_Menu_Option = .resume

Menu_Request :: enum {
	none,
	up,
	down,
	select
}

menu_request: Menu_Request = .none


