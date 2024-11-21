class_name ScreenModeOptionButton extends OptionButton

var base_screen_mode = ProjectSettings.get_setting(
		"display/window/size/mode"
)


func _on_item_selected(index: int) -> void:
	
	match index:
		0:
			base_screen_mode = ( # Window Mode
					DisplayServer.WindowMode.WINDOW_MODE_WINDOWED
			)
		1:
			base_screen_mode = ( # Maximized Window Mode
					DisplayServer.WindowMode.WINDOW_MODE_MAXIMIZED
			)
		2:
			base_screen_mode = ( # Fullscreen Mode
					DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN
			)
		3:
			base_screen_mode = ( # Exclusive Fullscreen Mode
					DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
			)
	
	DisplayServer.window_set_mode(base_screen_mode)
