package main

game_state : Game_State = .title

Game_State :: enum {
	title,
	active,
	paused,
	game_over
}

reset_to_title :: proc() {
	game_state = .title

	clear_enemies()
	
	for &arr in radius_effects {
		clear(&arr)
	}
	clear(&radius_effects)

	// reset players if needed

	if player_1.is_alive == false {
		player_1.dead_time = PLAYER_RESPAWN_RATE - PLAYER_IN_TIME + 1
	}
	if player_2.is_alive == false {
		player_2.dead_time = PLAYER_RESPAWN_RATE - PLAYER_IN_TIME + 1
	}
}




