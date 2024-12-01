class_name MainMenu extends Control

## SIGNALS
signal open_options_menu()

## ON-READY
@onready var options_menu: Panel = $"../OptionsMenu"

enum Menu { MAIN, OPTIONS, STATISTICS }
var menu_state: Menu = Menu.MAIN

## FUNCTIONS
func _on_options_menu_open_main_menu() -> void:
	show()
	
func _on_start_game_button_pressed() -> void:
	GameManager.set_game_state(GameManager.GameState.COUNTDOWN)
	hide()

func _on_options_button_pressed() -> void:
	open_menu(Menu.OPTIONS)

# TODO: Implement Statistics Button toggle

func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
func open_menu(_menu_state: Menu) -> void:
	match _menu_state:
		Menu.OPTIONS:
			open_options_menu.emit()
		# TODO: Implement Statistics Menu State
	
	menu_state = _menu_state


func _on_main_menu_button_pressed() -> void:
	show()
	
