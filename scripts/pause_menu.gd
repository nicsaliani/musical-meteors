class_name PauseMenu extends Control

## FUNCTIONS
func _ready() -> void:
	# Process this node even when the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

func _process(_delta: float) -> void:
	if GameManager.game_state == GameManager.GameState.PAUSED:
		show()
	else:
		hide()


func _on_resume_button_pressed() -> void:
	GameManager.toggle_pause()
