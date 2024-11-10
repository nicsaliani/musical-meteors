extends Node

## ENUMS
enum GameState { MAIN_MENU, COUNTDOWN, PLAYING, PAUSED, GAME_OVER }
var game_state: GameState = GameState.MAIN_MENU

## VARIABLES
var score: int

## FUNCTIONS
func _ready() -> void:
	# Process this node even when the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS


func _process(_delta: float) -> void:
	# Pause if pause action is made
	if Input.is_action_just_pressed("pause"):
		toggle_pause()


func toggle_pause():
	# Pause if game is PLAYING; unpause if game is PAUSED
	if game_state == GameState.PLAYING:
		set_game_state(GameState.PAUSED)
		get_tree().paused = true
	elif game_state == GameState.PAUSED:
		set_game_state(GameState.PLAYING)
		get_tree().paused = false
	
	print(GameManager.game_state)


func set_game_state(_game_state: GameState) -> void:
	game_state = _game_state
