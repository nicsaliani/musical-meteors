class_name ScorePopup extends Label

## FUNCTIONS
#func _ready() -> void:
	#pass

func _ready() -> void:
	label_settings = label_settings.duplicate()


func _on_timer_timeout() -> void:
	flash_and_delete()


func flash_and_delete() -> void:
	var opacity_state = true
	for i in range(11):
		await get_tree().create_timer(.033).timeout
		opacity_state = !opacity_state
		
		if opacity_state:
			label_settings.font_color.a = 100
		else:
			label_settings.font_color.a = 0
	
	queue_free()
			
