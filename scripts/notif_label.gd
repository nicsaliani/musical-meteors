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
@onready var notif_timer: Timer = $NotifTimer


## FUNCTIONS
func _ready() -> void:
	hide()


func _on_start_game_button_pressed() -> void:
	start_game_countdown()


func _on_game_timer_panel_game_over() -> void:
	show_notif(
		"GAME OVER!", 
		3.0, 
		32
	)


func _on_asteroid_manager_wrong_note_played(pitch) -> void:
	show_notif(
		"No " + str(pitch) + " meteor.",
		2.0,
		16,
		Color.RED
	)


func _on_score_panel_level_up(_level: Variant) -> void:
	show_notif(
		"LEVEL UP!\n New key unlocked.",
		2.0,
		16,
		Color.YELLOW
	)


func _on_notif_timer_timeout() -> void:
	hide_notif()


func show_notif(
		_text: String = "TEST NOTIF", 
		_duration: float = 1.0,
		_font_size: int = 16,
		_color: Color = Color.WHITE,
) -> void:
	text = _text
	label_settings.font_size = _font_size
	label_settings.font_color = _color
	
	if !notif_timer.is_stopped():
		restart_notif_timer(_duration)
	else:
		notif_timer.start(_duration)
	show()


func hide_notif() -> void:
	text = ""
	hide()


func restart_notif_timer(_duration: float) -> void:
	notif_timer.stop()
	notif_timer.start(_duration)


func start_game_countdown() -> void:
	show()
	
	for i in range(4):
		text = ("Press the KEYS that match the ASTEROIDS!\n" 
				+ str(countdown_texts[i])
		)
		await(get_tree().create_timer(1, false).timeout)
	
	start_game.emit()
	hide_notif()
