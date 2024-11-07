class_name NotifLabel extends Label

## SIGNALS
signal start_game

## VARIABLES
var countdown_texts := ["3", "2", "1", "START!"]
# Called when the node enters the scene tree for the first time.

## FUNCTIONS
func _ready() -> void:
	hide()


func _on_start_game_button_pressed() -> void:
	start_game_countdown()


func start_game_countdown():
	show()
	
	for i in range(4):
		text = "Press the KEYS that match the ASTEROIDS!\n" + str(countdown_texts[i])
		await(get_tree().create_timer(1, false).timeout)
	
	start_game.emit()
	hide_notif()

func show_notif(_notif_text: String):
	text = _notif_text
	show()
	
func hide_notif():
	text = ""
	hide()
