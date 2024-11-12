class_name AsteroidManager extends Control

## SIGNALS
## -------------------
signal asteroid_destroyed(asteroid)
signal wrong_note_played(pitch)

## ON-READY REFERENCES
## -------------------
@onready var game_viewport: SubViewport
@onready var midi_control: MidiControl = %"MIDI Control"
@onready var asteroid_spawn_timer: Timer = $"AsteroidSpawnTimer"
@onready var asteroid_scene := preload("res://scenes/asteroid.tscn")

## VARIABLES
## -------------------
var min_bound_x
var max_bound_x
var min_bound_y
var max_bound_y

var asteroids_on_screen: Dictionary = {}
var space_available: int = 12
var sizes_available: Array
var pitches_available: Array[int] = [
	0, 
	1, 
	2, 
	3, 
	4, 
	5, 
	6, 
	7, 
	8, 
	9, 
	10, 
	11
]
var spawn_points: Array[Vector2] = [
	Vector2(-256, -256),
	Vector2(0, -256),
	Vector2(256, -256),
	Vector2(-256, 0),
	Vector2(256, 0),
	Vector2(-256, 256),
	Vector2(0, 256),
	Vector2(256, 256)
]
var spawn_trajectories: Array

## FUNCTIONS
## -------------------
func _ready():
	
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

func _on_notif_label_start_game() -> void:
	asteroid_spawn_timer.start()


func _on_game_timer_panel_game_over() -> void:
	asteroid_spawn_timer.stop()
	clear_all_asteroids()


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

func spawn_asteroid_on_border(_asteroid: Asteroid, _pos: Vector2):
	
	# Position this asteroid so that it spawns just out of sight
	var _asteroid_radius = _asteroid.collision_shape_2d.shape.radius
	_asteroid.position = Vector2(
		_pos.x + (sign(_pos.x)) * _asteroid_radius,
		_pos.y + (sign(_pos.y)) * _asteroid_radius
	)
	
	update_space_available(false, _asteroid.size)

func spawn_asteroid_from_split(_asteroid: Asteroid, _pos: Vector2):
	_asteroid.position = _pos
	
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
	
func _on_note_pressed(_played_pitch_letter: String):
	
	# Destroy asteroid with pitch letter matching the played pitch
	if asteroids_on_screen.has(_played_pitch_letter):
		destroy_asteroid(asteroids_on_screen[_played_pitch_letter])
	else:
		wrong_note_played.emit(_played_pitch_letter)

func destroy_asteroid(_asteroid):
	
	# Signal or call other functions and update asteroid-related lists
	asteroid_destroyed.emit(_asteroid)
	pitches_available.append(_asteroid.pitch)
	asteroids_on_screen.erase(_asteroid.pitch_letter)
	_asteroid.explode()
	
	# Free one point of space if a small asteroid is destroyed
	if _asteroid.size == Asteroid.SizeType.SMALL:
		update_space_available(true, _asteroid.size)

func check_space_available_for_possible_sizes() -> Array[Asteroid.SizeType]:
	
	# Return array of asteroid sizes based on how much space is left, empty if none
	if space_available > 0:
		if space_available == 1:
			return [Asteroid.SizeType.SMALL]
		elif space_available <= 3:
			return [Asteroid.SizeType.SMALL, Asteroid.SizeType.MEDIUM]
		else:
			return [Asteroid.SizeType.SMALL, Asteroid.SizeType.MEDIUM, Asteroid.SizeType.LARGE]
	else:
		return []

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

func clear_all_asteroids() -> void:
	for _asteroid in asteroids_on_screen:
		await get_tree().create_timer(0.1).timeout
		asteroids_on_screen[_asteroid].clear_with_explosion_effects()
