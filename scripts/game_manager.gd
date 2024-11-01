extends Node

## SIGNALS

## ON-READY
# Game Panel
@onready var game_panel: NinePatchRect = $GamePanel
@onready var asteroid_manager: Control = %AsteroidManager
@onready var main_menu: Control = $GamePanel/MainMenu
@onready var notif_label: Label = $GamePanel/NotifLabel

# MIDI Control Panel
@onready var midi_control_panel: NinePatchRect = $MIDIControlPanel

# Countdown Panel
@onready var countdown_panel: NinePatchRect = $CountdownPanel

# Level Panel (TODO: Create Level Panel)
#@onready var level_panel: NinePatchRect = $LevelPanel

# Score Panel
@onready var score_panel: NinePatchRect = $ScorePanel

## ENUMS
enum GameState { MAIN_MENU, PLAYING, PAUSED, GAME_OVER }
var current_game_state := GameState.MAIN_MENU

## VARIABLES

## FUNCTIONS
func _ready() -> void:
	# Process this node even when the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	# Pause if pause action is made
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

func _on_start_game_button_pressed() -> void:
	#current_game_state == GameState.PLAYING
	notif_label.start_game_countdown()
	asteroid_manager.start()
	main_menu.hide()

func _on_options_button_pressed():
	pass
	
func _on_quit_button_pressed() -> void:
	# Quit the game
	print("Quitting...")
	get_tree().quit()

func toggle_pause():
	if current_game_state == GameState.PLAYING:
		current_game_state = GameState.PAUSED
		get_tree().paused = true
	elif current_game_state == GameState.PAUSED:
		current_game_state = GameState.PLAYING
		get_tree().paused = false
