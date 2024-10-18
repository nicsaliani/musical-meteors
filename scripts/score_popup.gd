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
	pass
	#text = str(points)
	
func _on_timer_timeout() -> void:

	queue_free()
