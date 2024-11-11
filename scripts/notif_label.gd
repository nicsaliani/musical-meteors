class_name NotifLabel extends Label

## SIGNALS
signal start_game

## ENUMS
enum NotifEffect {
	NONE,
	FLASH,
}

## VARIABLES
var countdown_texts := ["3", "2", "1", "START!"]
# Called when the node enters the scene tree for the first time.

## FUNCTIONS
func _ready() -> void:
	hide()


func _on_start_game_button_pressed() -> void:
	start_game_countdown()


func _on_game_timer_panel_game_over() -> void:
	show_notif("GAME OVER!", 3.0, 32)


func show_notif(
		_text: String = "TEST NOTIF", 
		_duration: float = 1.0,
		_font_size: int = 16,
		_color: Color = Color.WHITE,
):
	text = _text
	label_settings.font_size = _font_size
	label_settings.font_color = _color
	
	show()
	await get_tree().create_timer(_duration, false).timeout
	text = ""
	hide()


func hide_notif():
	text = ""
	hide()


func start_game_countdown():
	show()
	
	for i in range(4):
		text = ("Press the KEYS that match the ASTEROIDS!\n" 
				+ str(countdown_texts[i])
		)
		await(get_tree().create_timer(1, false).timeout)
	
	start_game.emit()
	hide_notif()
