class_name LevelPanel extends Control

## ON-READY
@onready var level_label: Label = $Control/LevelLabel


## FUNCTIONS
func _ready() -> void:
	set_level(0)


func _on_start_game_button_pressed() -> void:
	set_level(1)


func _on_score_panel_level_up(level: Variant) -> void:
	set_level(level)


func set_level(level: int) -> void:
	level_label.text = str(level)
	
	if level < 4:
		level_label.label_settings.font_color = Color.WHITE
	elif level >= 4 and level < 7:
		level_label.label_settings.font_color = Color.YELLOW
	elif level >= 7 and level < 10:
		level_label.label_settings.font_color = Color.ORANGE
	else:
		level_label.label_settings.font_color = Color.RED
