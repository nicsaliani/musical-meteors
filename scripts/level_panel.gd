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
	
	if level > 3 and level < 6:
		level_label.label_settings.font_color = Color.YELLOW
	elif level >= 6 and level < 10:
		level_label.label_settings.font_color = Color.ORANGE
	elif level == 10:
		level_label.label_settings.font_color = Color.RED
