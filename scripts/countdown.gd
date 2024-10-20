class_name Countdown extends Control

## SIGNALS

## ON-READY REFERENCES
@onready var timer: Timer = $Countdown/Timer
@onready var countdown_label: Label = $Countdown/CountdownLabel

## VARIABLES

## FUNCTIONS
func _on_timer_timeout() -> void:
	pass # Replace with function body.

func update_timer() -> void:
	pass
