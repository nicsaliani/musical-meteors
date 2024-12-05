extends Node
## Script for handing game state changing.
##
## This script is attached to the Main node. It is not an Autoload because
## Autoloads cannot easily receive signals from other nodes. This script acts
## as a centralized hub that receives all signals for changing the game state.

## ---FUNCTIONS---
## Set the game state to MAIN_MENU on startup.
func _ready() -> void:
	GameManager.set_game_state(GameManager.GameState.MAIN_MENU)


## Set the game state to COUNTDOWN.
func _on_start_game_button_pressed() -> void:
	GameManager.set_game_state(GameManager.GameState.COUNTDOWN)


## Set the game state to PLAYING.
func _on_notif_label_start_game() -> void:
	GameManager.set_game_state(GameManager.GameState.PLAYING)


## Set the game state to GAME_OVER.
func _on_game_timer_panel_game_over() -> void:
	GameManager.set_game_state(GameManager.GameState.GAME_OVER)


## Set the game state to MAIN_MENU when a main menu button is pressed,
## and unpause the game in case we are coming from the pause menu.
func _on_main_menu_button_pressed() -> void:
	GameManager.set_game_state(GameManager.GameState.MAIN_MENU)
	get_tree().paused = false
