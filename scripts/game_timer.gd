class_name GameTimer extends Control

## SIGNALS
signal total_time_updated(total_time: String)
signal game_over

## ON-READY REFERENCES
@onready var timer: Timer = $Timer
@onready var game_timer_label: Label = $Control/GameTimerLabel
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


## VARIABLES
@export var start_time: int
var current_time: int
var total_time: int

## FUNCTIONS
func _on_start_game_button_pressed() -> void:
	update_game_timer(start_time)
	total_time = 0


func _on_notif_label_start_game() -> void:
	timer.start()


func _on_timer_timeout() -> void:
	update_game_timer(-1)
	total_time += 1
	total_time_updated.emit(seconds_to_clock_time(total_time))


func _on_score_panel_level_up(level: Variant) -> void:
	if level < 5:
		update_game_timer(15)
	else:
		update_game_timer(30)


func update_game_timer(seconds: int) -> void:
	current_time += seconds
	
	if (current_time > -1):
		game_timer_label.text = seconds_to_clock_time(current_time)
	else:
		current_time = 0
		game_timer_label.text = "TIME!"
		audio_stream_player.play()
		timer.stop()
		game_over.emit()


func seconds_to_clock_time(seconds: int) -> String:
	var digit_minute: String = str(seconds / 60)
	var digit_second_tens: String = str((seconds / 10) % 6)
	var digit_second_ones: String = str(seconds % 10)
	return digit_minute + ":" + digit_second_tens + digit_second_ones
