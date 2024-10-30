extends Node

## SIGNALS
#signal game_started()
#signal game_paused()
#signal game_over()

## ENUMS
enum GameState { MAIN_MENU, PLAYING, PAUSED, GAME_OVER }
var current_game_state = GameState.PLAYING

## VARIABLES


## FUNCTIONS
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Process this node even when the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Pause if pause action is made
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

func toggle_pause():
	if current_game_state == GameState.PLAYING:
		current_game_state = GameState.PAUSED
		get_tree().paused = true
	elif current_game_state == GameState.PAUSED:
		current_game_state = GameState.PLAYING
		get_tree().paused = false
