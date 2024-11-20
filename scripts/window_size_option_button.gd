class_name WindowSizeOptionButton extends OptionButton

var base_window_size = Vector2(
	ProjectSettings.get_setting("display/window/size/window_width_override"),
	ProjectSettings.get_setting("display/window/size/window_height_override"),
)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_item_selected(index: int) -> void:
	
	match index:
		0:
			base_window_size = Vector2i(960, 540)
		1:
			base_window_size = Vector2i(1920, 1080)
		2:
			base_window_size = Vector2i(
				DisplayServer.screen_get_size()
			)
	
	get_viewport().size = base_window_size
