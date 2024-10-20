class_name Countdown extends Control

## SIGNALS

## ON-READY REFERENCES
@onready var timer: Timer = $Timer
@onready var countdown_label: Label = $CountdownLabel

## VARIABLES
@export var start_time: int
var current_time: int

## FUNCTIONS
func _ready() -> void:
	
	timer.start() # Move this to _on_game_start() once function works
	current_time = start_time
	
	update_countdown(0)

func _on_game_start():
	# TODO: Connect 'game_start' signal to this function
	pass

func _on_timer_timeout() -> void:
	
	update_countdown(-1)

func _on_level_up():
	# TODO: Connect 'level_up' signal to this function
	update_countdown(30)
	pass

func _on_bad_key_pressed():
	# TODO: Connect 'bad_key_pressed' signal to this function
	update_countdown(-5)
	pass

func update_countdown(seconds: int) -> void:
	
	current_time += seconds
	
	if (current_time > -1):
		var digit_minute: String = str(current_time / 60)
		var digit_second_tens: String = str((current_time / 10) % 6)
		var digit_second_ones: String = str(current_time % 10)
		
		countdown_label.text = digit_minute + ":" + digit_second_tens + digit_second_ones
		
	else:
		# TODO: Trigger Game Over
		countdown_label.text = "TIME!"
		timer.stop()
		
	print(timer.is_stopped())
