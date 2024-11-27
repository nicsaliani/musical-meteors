class_name GameOverMenu extends Control

## ON-READY
@onready var total_time_value: Label = $GameStatContainer/GameStatValueContainer2/TotalTimeValue
@onready var meteors_destroyed_value: Label = $GameStatContainer/GameStatValueContainer2/MeteorsDestroyedValue
@onready var missed_keys_value: Label = $GameStatContainer/GameStatValueContainer2/MissedKeysValue
@onready var longest_streak_value: Label = $GameStatContainer/GameStatValueContainer2/LongestStreakValue

## VARIABLES
var total_time: String
var meteors_destroyed: int
var missed_keys: String
var longest_streak: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


func _on_game_ended() -> void:
	total_time_value.text = total_time
	meteors_destroyed_value.text = str(meteors_destroyed)
	show()


func _on_start_game_button_pressed() -> void:
	hide()


func _on_total_time_updated(_time: String) -> void:
	total_time = _time


func _on_asteroid_destroyed(_meteors_destroyed: Variant) -> void:
	meteors_destroyed = _meteors_destroyed
