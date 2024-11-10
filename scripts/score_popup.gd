class_name ScorePopup extends Label

## FUNCTIONS
#func _ready() -> void:
	#pass
	
func _on_timer_timeout() -> void:
	queue_free()
