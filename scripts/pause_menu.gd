class_name PauseMenu extends Control

## FUNCTIONS
func _ready() -> void:
	# Process this node even when the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

func _process(delta: float) -> void:
	# Pause if pause action is made
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

func _on_resume_button_pressed() -> void:
	toggle_pause()

func toggle_pause():
	# Pause if game is PLAYING; unpause if game is PAUSED
	if GameManager.game_state == GameManager.GameState.PLAYING:
		GameManager.game_state = GameManager.GameState.PAUSED
		get_tree().paused = true
		show()
	elif GameManager.game_state == GameManager.GameState.PAUSED:
		GameManager.game_state = GameManager.GameState.PLAYING
		get_tree().paused = false
		hide()
