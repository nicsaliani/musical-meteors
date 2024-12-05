class_name GameOverMenu extends Control
## The Game Over menu, which displays game statistics and contains buttons for
## restarting the game and exiting to the main menu.
##
## The Game Over menu appears three seconds after the "GAME OVER!" label.
## Many of its functions are called by signals from other nodes.


## ---CHILDREN---
## Reference to the TotalTimeValue label.
@onready var total_time_value: Label = (
		$GameStatContainer/GameStatValueContainer2/TotalTimeValue
)

## Reference to the MeteorsDestroyedValue label.
@onready var meteors_destroyed_value: Label = (
		$GameStatContainer/GameStatValueContainer2/MeteorsDestroyedValue
)

## Reference to the MissedKeysValue label.
@onready var missed_keys_value: Label = (
		$GameStatContainer/GameStatValueContainer2/MissedKeysValue
)

## Reference to the LongestStreakValue label.
@onready var longest_streak_value: Label = (
		$GameStatContainer/GameStatValueContainer2/LongestStreakValue
)

## ---GENERAL VARIABLES---
## The total time this game has lasted.
var total_time: String

## The total amount of meteors destroyed this game.
var meteors_destroyed: int

## The total amount of wrong notes pressed this game.
var missed_keys: int

## The most meteors destroyed in a row without pressing a wrong note this game.
var longest_streak: int

## The current amount of meteors destroyed in a row without pressing a wrong
## note this game.
var current_streak: int


## ---FUNCTIONS---
## Hide this node on startup.
func _ready() -> void:
	
	hide()


## Assign the game over stat labels to their respective variable values, then
## show the node.
func _on_game_ended() -> void:
	
	total_time_value.text = total_time
	meteors_destroyed_value.text = str(meteors_destroyed)
	missed_keys_value.text = str(missed_keys)
	longest_streak_value.text = str(longest_streak)
	show()


## Reset all game over stats to their defaults and hide this node.
func _on_start_game_button_pressed() -> void:
	
	reset_game_over_stats()
	hide()


## Update the total time variable.
func _on_total_time_updated(_time: String) -> void:
	
	total_time = _time


## Update the current streak variable, and update the longest streak variable
## if the current streak exceeds it.
func _on_asteroid_destroyed(_meteors_destroyed: Variant) -> void:
	
	meteors_destroyed = _meteors_destroyed
	
	current_streak += 1
	
	if current_streak > longest_streak:
		longest_streak = current_streak


## Update the missed keys variable and reset the current streak to zero when a
## wrong note is pressed.
func _on_wrong_note_played(_pitch: Variant) -> void:
	
	missed_keys += 1
	current_streak = 0


## Hide this node when a main menu button is pressed.
func _on_main_menu_button_pressed() -> void:
	
	hide()


## Reset all game over values to their defaults.
func reset_game_over_stats() -> void:
	
	total_time = ""
	meteors_destroyed = 0
	missed_keys = 0
	longest_streak = 0
	current_streak = 0
