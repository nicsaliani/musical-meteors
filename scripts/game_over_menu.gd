class_name GameOverMenu extends Control

## ON-READY
@onready var total_time_value: Label = $GameStatContainer/GameStatValueContainer2/TotalTimeValue
@onready var meteors_destroyed_value: Label = $GameStatContainer/GameStatValueContainer2/MeteorsDestroyedValue
@onready var missed_keys_value: Label = $GameStatContainer/GameStatValueContainer2/MissedKeysValue
@onready var longest_streak_value: Label = $GameStatContainer/GameStatValueContainer2/LongestStreakValue

## VARIABLES
var total_time: String
var meteors_destroyed: int
var missed_keys: int
var longest_streak: int
var current_streak: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


func _on_game_ended() -> void:
	total_time_value.text = total_time
	meteors_destroyed_value.text = str(meteors_destroyed)
	missed_keys_value.text = str(missed_keys)
	longest_streak_value.text = str(longest_streak)
	show()


func _on_start_game_button_pressed() -> void:
	total_time = ""
	meteors_destroyed = 0
	missed_keys = 0
	longest_streak = 0
	current_streak = 0
	hide()


func _on_total_time_updated(_time: String) -> void:
	total_time = _time


func _on_asteroid_destroyed(_meteors_destroyed: Variant) -> void:
	meteors_destroyed = _meteors_destroyed
	
	current_streak += 1
	if current_streak > longest_streak:
		longest_streak = current_streak
	
	print(current_streak, ", ", longest_streak)


func _on_wrong_note_played(pitch: Variant) -> void:
	missed_keys += 1
	current_streak = 0
	
