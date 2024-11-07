extends Node

## SIGNALS
signal pause_game()
signal unpause_game()

## ENUMS
enum GameState { MAIN_MENU, COUNTDOWN, PLAYING, PAUSED, GAME_OVER }
var game_state: GameState = GameState.MAIN_MENU

## VARIABLES
var score: int

## FUNCTIONS
func _ready() -> void:
	# Process this node even when the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS

func set_game_state(_game_state: GameState) -> void:
	game_state = _game_state

func toggle_pause():
	# Pause if game is PLAYING; unpause if game is PAUSED
	if game_state == GameState.PLAYING:
		game_state = GameState.PAUSED
		pause_game.emit()
		get_tree().paused = true
	elif game_state == GameState.PAUSED:
		game_state = GameState.PLAYING
		unpause_game.emit()
		get_tree().paused = false
