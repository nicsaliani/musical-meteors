class_name AsteroidManager 
extends Control
## An object that manages Asteroid objects.

## The AsteroidManager is chiefly responsible for creating, destroying, and
## removing Asteroid objects from the screen. It keeps track of all Asteroids,
## which are its children. It is a child of the GameViewport, and gets the 
## values of its maximum and minimum bounds from the GameViewport's dimensions. 
## It receives signals from the MIDIController in order to create and destroy 
## Asteroid objects. There should only be one AsteroidManager in the project.

## ---SIGNALS---
## Emitted when an Asteroid is destroyed.
signal asteroid_destroyed(asteroids_destroyed)

## Emitted when the score needs to be updated, positively or negatively.
signal update_score(points)

## Emitted when a MIDI note is played that matches no Asteroid on screen.
signal wrong_note_played(pitch)

## ---NODES AND CHILDREN---
## Reference to GameViewport, the parent of the AsteroidManager.
@onready var game_viewport: SubViewport

## Reference to the MIDI Control.
@onready var midi_control: MidiControl = %"MIDI Control"

## Reference to AsteroidSpawnTimer, which controls the frequency of Asteroid
## spawning.
@onready var asteroid_spawn_timer: Timer = $"AsteroidSpawnTimer"

## Reference to the Asteroid scene.
@onready var asteroid_scene := preload("res://scenes/asteroid.tscn")

## ---GENERAL VARIABLES---
## Leftmost boundary at which an Asteroid will loop upon crossing.
var min_bound_x: int

## Rightmost boundary at which an Asteroid will loop upon crossing.
var max_bound_x: int

## Upward boundary at which an Asteroid will loop upon crossing.
var min_bound_y: int

## Downward boundary at which an Asteroid will loop upon crossing.
var max_bound_y: int

## The number of Asteroids destroyed this game. Used for Game Over statistics.
var asteroids_destroyed: int = 0

## Dictionary containing references to every Asteroid currently in the game.
## This dictionary is updated whenever an Asteroid is spawned and/or destroyed.
var asteroids_on_screen: Dictionary = {}

## Int tracking the "space" available for Asteroids to spawn. Each Asteroid
## takes up a certain amount of space based on its size. Larger Asteroids will
## not spawn if there is not enough space left for it. Space is freed whenever
## a small Asteroid is destroyed.
var space_available: int = 12

## Asteroid sizes that can be spawned based on the space available.
var sizes_available: Array

## Asteroid pitches that can be spawned based on the game level. Updates to
## include more pitches as the game level increases.
var pitches_available: Array[int] = [
	0, 
	2, 
	4, 
]

## Points where Asteroids spawn off-screen.
var spawn_points: Array[Vector2] = [
	Vector2(-256, -256), # Top-left corner
	Vector2(0, -256), # Top edge
	Vector2(256, -256), # Top-right corner
	Vector2(-256, 0), # Left edge
	Vector2(256, 0), # Right edge
	Vector2(-256, 256), # Bottom-left corner
	Vector2(0, 256), # Bottom edge
	Vector2(256, 256) # Bottom-right corner
]


## ---FUNCTIONS---
## Connects signals and sets loop boundaries based on GameViewport size.
func _ready() -> void:
	
	# Connect necessary signals
	midi_control.connect("note_pressed", _on_note_pressed)
	asteroid_spawn_timer.connect("timeout", _on_timer_timeout)
	
	# Get bounds of game viewport
	await get_tree().process_frame
	game_viewport = get_parent()
	min_bound_x = -(game_viewport.size.x / 2)
	max_bound_x = game_viewport.size.x / 2
	min_bound_y = -(game_viewport.size.y / 2)
	max_bound_y = game_viewport.size.y / 2


## Set game variables to default when the game starts (i.e. when the "START!"
## notification disappears).
func _on_notif_label_start_game() -> void:
	
	# Reset variables and start AsteroidSpawnTimer
	asteroid_spawn_timer.start()
	asteroids_destroyed = 0
	pitches_available = [0, 2, 4]
	space_available = 3


## Clear all Asteroids and stop the AsteroidSpawnTimer when the game ends.
func _on_game_timer_panel_game_over() -> void:
	
	asteroid_spawn_timer.stop()
	clear_all_asteroids()


## Create an Asteroid, but don't place it on the screen.
func create_asteroid(_size: Asteroid.SizeType) -> Asteroid:
	
	# Instantiate asteroid and set vars
	var _asteroid = asteroid_scene.instantiate()
	_asteroid.size = _size
	_asteroid.pitch = pitches_available[randi_range(0, pitches_available.size()-1)]
	add_child(_asteroid)
	_asteroid.connect("split_asteroid", split_asteroid)
	
	# Update asteroid-related lists
	asteroids_on_screen[_asteroid.pitch_letter] = _asteroid
	pitches_available.erase(_asteroid.pitch)
	
	return _asteroid


## Place an Asteroid on the border of the screen.
func spawn_asteroid_on_border(_asteroid: Asteroid, _pos: Vector2) -> void:
	
	# Position this asteroid so that it spawns just out of sight
	var _asteroid_radius = _asteroid.collision_shape_2d.shape.radius
	_asteroid.position = Vector2(
		_pos.x + (sign(_pos.x)) * _asteroid_radius,
		_pos.y + (sign(_pos.y)) * _asteroid_radius
	)
	
	update_space_available(false, _asteroid.size)


## Place an Asteroid at the location of another Asteroid.
func spawn_asteroid_from_split(_asteroid: Asteroid, _pos: Vector2):
	
	_asteroid.position = _pos


## Spawn an Asteroid on the border when AsteroidSpawnTimer goes off.
func _on_timer_timeout():
	
	# Get available sizes based on available space
	sizes_available = check_space_available_for_possible_sizes()
	
	# Spawn one new asteroid off-screen if pitches and sizes are available
	if pitches_available and sizes_available:
		var _asteroid = create_asteroid(
			randi_range(0, sizes_available.size() - 1)
		)
		spawn_asteroid_on_border(
			_asteroid, 
			spawn_points[randi_range(0, spawn_points.size() - 1)], 
		)


## Destroy an Asteroid if a note is played that matches it. If it doesn't,
## detract points and emit the wrong_note_played signal.
func _on_note_pressed(_played_pitch_letter: String):
	# Destroy asteroid with pitch letter matching the played pitch
	if asteroids_on_screen.has(_played_pitch_letter):
		var _asteroid = asteroids_on_screen[_played_pitch_letter]
		destroy_asteroid(_asteroid)
		update_score.emit(_asteroid.points)
	else:
		wrong_note_played.emit(_played_pitch_letter)
		update_score.emit(-25)


## Destroy an Asteroid and update game variables.
func destroy_asteroid(_asteroid):
	
	# Update number of asteroids destroyed and emit signal
	asteroids_destroyed += 1
	asteroid_destroyed.emit(asteroids_destroyed)
	
	# Update asteroid lists
	pitches_available.append(_asteroid.pitch)
	asteroids_on_screen.erase(_asteroid.pitch_letter)
	
	# Kill asteroid
	_asteroid.explode() 
	
	# Free one point of space if a small asteroid is destroyed
	if _asteroid.size == Asteroid.SizeType.SMALL:
		update_space_available(true, _asteroid.size)


## Check which Asteroid sizes can still be spawned based on the current amount
## of space left.
func check_space_available_for_possible_sizes() -> Array[Asteroid.SizeType]:
	
	# Return array of asteroid sizes based on how much space is left, 
	# empty if none
	if space_available > 0:
		if space_available == 1:
			return [Asteroid.SizeType.SMALL]
		elif space_available <= 3:
			return [Asteroid.SizeType.SMALL, Asteroid.SizeType.MEDIUM]
		else:
			return [Asteroid.SizeType.SMALL, 
					Asteroid.SizeType.MEDIUM, 
					Asteroid.SizeType.LARGE]
	else:
		return []


## Update the amount of space available.
func update_space_available(_operation: bool, _size: Asteroid.SizeType) -> void:
	
	# Sets operation to addition if operation is true, subtraction if false
	var _operation_value
	if _operation:
		_operation_value = 1
	else:
		_operation_value = -1
	
	# Add or subtract to available_size
	match _size:
		Asteroid.SizeType.SMALL:
			space_available += 1 * _operation_value
		Asteroid.SizeType.MEDIUM:
			space_available += 2 * _operation_value
		Asteroid.SizeType.LARGE:
			space_available += 4 * _operation_value


## Split an Asteroid depending on its size.
func split_asteroid(_pos: Vector2, _size: Asteroid.SizeType):
	
	# Split large asteroids into two medium ones, and medium asteroids into two small ones
	match _size:
		Asteroid.SizeType.LARGE:
			for i in range(2):
				var _asteroid = create_asteroid(
					Asteroid.SizeType.MEDIUM
				)
				spawn_asteroid_from_split(_asteroid, _pos)
		Asteroid.SizeType.MEDIUM:
			for i in range(2):
				var _asteroid = create_asteroid(
					Asteroid.SizeType.SMALL
				)
				spawn_asteroid_from_split(_asteroid, _pos)


## Clear all Asteroids from the screen.
func clear_all_asteroids() -> void:
	for _asteroid in asteroids_on_screen:
		asteroids_on_screen[_asteroid].clear_with_explosion_effects()
		await get_tree().create_timer(0.1).timeout
	asteroids_on_screen.clear()


## Add new available Asteroid pitches on level up, based on the level.
## Also add one more unit of available space.
func _on_score_panel_level_up(level: Variant) -> void:
	
	match level:
		2:
			pitches_available.append(5)
		3:
			pitches_available.append(7)
		4:
			pitches_available.append(9)
		5:
			pitches_available.append(11)
		6:
			pitches_available.append(1)
		7:
			pitches_available.append(3)
		8:
			pitches_available.append(6)
		9:
			pitches_available.append(8)
		10:
			pitches_available.append(10)
	
	space_available += 1


## Reset the AsteroidManager when a Main Menu button is pressed.
func _on_main_menu_button_pressed() -> void:
	reset_asteroid_manager()


## Remove all Asteroids (without explosion effects) and reset AsteroidManager
## variables.
func reset_asteroid_manager() -> void:
	for child in get_children():
		if child.get_class() == "Area2D":
			remove_child(child)
			child.queue_free()
	asteroids_on_screen.clear()
	asteroid_spawn_timer.stop()
