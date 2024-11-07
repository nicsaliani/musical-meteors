extends Node

## FUNCTIONS
func _ready() -> void:
	GameManager.set_game_state(GameManager.GameState.MAIN_MENU)

func _on_start_game_button_pressed() -> void:
	GameManager.set_game_state(GameManager.GameState.COUNTDOWN)

func _on_notif_label_start_game() -> void:
	GameManager.set_game_state(GameManager.GameState.PLAYING)

func _on_game_timer_panel_game_over() -> void:
	GameManager.set_game_state(GameManager.GameState.GAME_OVER)
