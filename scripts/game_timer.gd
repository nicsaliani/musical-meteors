class_name GameTimer extends Control

## SIGNALS
signal game_over

## ON-READY REFERENCES
@onready var timer: Timer = $Timer
@onready var game_timer_label: Label = $Control/GameTimerLabel

## VARIABLES
@export var start_time := 0
var current_time: int

## FUNCTIONS
func _on_start_game_button_pressed() -> void:
	update_game_timer(start_time)

func _on_notif_label_start_game() -> void:
	timer.start()

func _on_timer_timeout() -> void:
	update_game_timer(-1)

func _on_level_up():
	# TODO: Connect 'level_up' signal to this function
	update_game_timer(30)

func _on_bad_key_pressed():
	# TODO: Connect 'bad_key_pressed' signal to this function
	update_game_timer(-5)

func update_game_timer(seconds: int) -> void:
	current_time += seconds
	
	if (current_time > -1):
		var digit_minute: String = str(current_time / 60)
		var digit_second_tens: String = str((current_time / 10) % 6)
		var digit_second_ones: String = str(current_time % 10)
		game_timer_label.text = digit_minute + ":" + digit_second_tens + digit_second_ones
	else:
		# TODO: Send game_over signal
		game_timer_label.text = "TIME!"
		timer.stop()
		game_over.emit()
