class_name GameOverMenu extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


func _on_game_ended() -> void:
	show()


func _on_start_game_button_pressed() -> void:
	hide()
