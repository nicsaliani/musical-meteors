extends Node
## An Autoload singleton for handling game state and pausing.
##
## The GameManager functions for changing the game state are called from the
## GameStateChanger script, which is attached to the Main node.

## ---SIGNALS---
## Emitted when the game is paused.
signal game_paused()

## Emitted when the game is unpaused.
signal game_unpaused()

## ---ENUMS---
## Represents the different states of the game:
## MAIN MENU: The game is on the main menu screen or options screen.
## COUNTDOWN: The game is counting down before spawning Asteroids. Ends when
## the NotifLabel disappears.
## PLAYING: The game is active. Asteroids are spawning.
## PAUSED: The game is paused.
## GAME_OVER: The game has just ended or is on the Game Over screen.
enum GameState { MAIN_MENU, COUNTDOWN, PLAYING, PAUSED, GAME_OVER }

## The current game state.
var game_state: GameState = GameState.MAIN_MENU


## FUNCTIONS
## Set this node to always process, even when the game is paused.
func _ready() -> void:
	
	process_mode = Node.PROCESS_MODE_ALWAYS


## Pause the game if the ESC key is pressed.
func _process(_delta: float) -> void:
	
	# Pause if pause action is made
	if Input.is_action_just_pressed("pause"):
		toggle_pause()


## If the game is not paused, unpause it (and vice versa).
func toggle_pause():
	# Pause if game is PLAYING; unpause if game is PAUSED
	if game_state == GameState.PLAYING:
		game_paused.emit()
		set_game_state(GameState.PAUSED)
		get_tree().paused = true
	elif game_state == GameState.PAUSED:
		game_unpaused.emit()
		set_game_state(GameState.PLAYING)
		get_tree().paused = false


## Set the current game state.
func set_game_state(_game_state: GameState) -> void:
	game_state = _game_state
