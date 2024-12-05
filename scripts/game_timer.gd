class_name GameTimer extends Control
## A timer that displays the amount of time left before the game ends.
##
## This script is attached to the GameTimerPanel Control node. It needs access
## to a Timer, a label to display the time, and an AudioStreamPlayer to play
## the game over sound effect when the timer runs out.

## ---SIGNALS---
## Emitted when the total time is updated. Sent to the game over menu script.
signal total_time_updated(total_time: String)

## Emitted when the game ends.
signal game_over

## ---NODES AND CHILDREN---
## Reference to the Timer node.
@onready var timer: Timer = $Timer

## Reference to the GameTimerLabel node.
@onready var game_timer_label: Label = $Control/GameTimerLabel

## Reference to the AudioStreamPlayer node.
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

## ---GENERAL VARIABLES---
## The default amount of time provided when a new game begins. Set to 60
## seconds by default. Can be changed from the editor for easy testing.
@export var start_time: int

## The current amount of time left before the game ends.
var current_time: int

## The total amount of time that has passed this game.
var total_time: int


## ---FUNCTIONS---
## On startup, update the game timer to the default start time and reset the
## total time passed this game.
func _on_start_game_button_pressed() -> void:
	
	update_game_timer(start_time)
	total_time = 0


## When the NotifLabel node disappears, start the timer.
func _on_notif_label_start_game() -> void:
	
	timer.start()


## When the timer times out, detract one second from the timer and update the
## total time passed this game.
func _on_timer_timeout() -> void:
	
	update_game_timer(-1)
	total_time += 1
	total_time_updated.emit(seconds_to_clock_time(total_time))


## On a level up, add more time to the timer. Add more if the level is over 5.
func _on_score_panel_level_up(level: Variant) -> void:
	
	if level < 6:
		update_game_timer(15)
	else:
		update_game_timer(30)


## Add or subtract an amount of seconds from the game timer.
func update_game_timer(seconds: int) -> void:
	
	current_time += seconds
	
	if (current_time > -1):
		game_timer_label.text = seconds_to_clock_time(current_time)
	else:
		current_time = 0
		game_timer_label.text = "TIME!"
		
		# Send signals and play sound effects
		audio_stream_player.play()
		timer.stop()
		game_over.emit()


## Convert an amount of seconds into clock time.
func seconds_to_clock_time(seconds: int) -> String:
	var digit_minute: String = str(seconds / 60)
	var digit_second_tens: String = str((seconds / 10) % 6)
	var digit_second_ones: String = str(seconds % 10)
	return digit_minute + ":" + digit_second_tens + digit_second_ones


## Reset the game timer when the main menu button is pressed.
func _on_main_menu_button_pressed() -> void:
	reset_game_timer()


## Reset the current time, stop the timer, and reset the timer label.
func reset_game_timer() -> void:
	current_time = 0
	timer.stop()
	game_timer_label.text = seconds_to_clock_time(current_time)
