class_name ScorePopup extends Label

## ON-READY REFERENCES
## -------------------
@onready var timer: Timer = $Timer

## VARIABLES
## -------------------
var points: int

## FUNCTIONS
## -------------------
func _ready() -> void:
	
	text = str(points)
	
func _on_timer_timeout() -> void:
	print("done")
	queue_free()
