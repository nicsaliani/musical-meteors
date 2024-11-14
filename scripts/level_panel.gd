class_name LevelPanel extends Control

## ON-READY
@onready var level_label: Label = $Control/LevelLabel


## FUNCTIONS

func _ready() -> void:
	level_label.text = "0"


func _on_start_game_button_pressed() -> void:
	level_label.text = "1"


func _on_score_panel_level_up(level: Variant) -> void:
	level_label.text = str(level)
