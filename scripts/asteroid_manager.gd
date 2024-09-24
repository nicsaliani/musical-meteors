class_name AsteroidManager extends Control

## SIGNALS
## -------------------
## TODO: Integrate and attach functions to this signal
signal asteroid_destroyed(asteroid)

## ON-READY REFERENCES
## -------------------
@onready var midi_control: MidiControl = $"../MIDI Control"
@onready var asteroid_spawn_timer: Timer = $"Asteroid Spawn Timer"

## EXPORT REFERNECES
## -------------------
@export var asteroid_scene := preload("res://scenes/asteroid.tscn")

## VARIABLES
## -------------------
# Vertical/Horizontal boundary values
const MIN_BOUNDARY = -256
const MAX_BOUNDARY = 256

var asteroids_on_screen: Dictionary = {}
var pitches_available: Array[int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
var space_available: int = 12
var sizes_available: Array
var spawn_points: Array[Vector2] = [
	Vector2(MIN_BOUNDARY, MIN_BOUNDARY),
	Vector2(0, MIN_BOUNDARY),
	Vector2(MAX_BOUNDARY, MIN_BOUNDARY),
	Vector2(MIN_BOUNDARY, 0),
	Vector2(MAX_BOUNDARY, 0),
	Vector2(MIN_BOUNDARY, MAX_BOUNDARY),
	Vector2(0, MAX_BOUNDARY),
	Vector2(MAX_BOUNDARY, MAX_BOUNDARY),
]

## FUNCTIONS
## -------------------
func _ready():
	
	# Connect necessary signals
	midi_control.connect("note_pressed", _on_note_pressed)
	asteroid_spawn_timer.connect("timeout", _on_timer_timeout)

func create_asteroid(size: Asteroid.SizeType) -> Asteroid:
	
	# Instantiate asteroid and set vars
	var asteroid = asteroid_scene.instantiate()
	asteroid.size = size
	asteroid.pitch = pitches_available[randi_range(0, pitches_available.size()-1)]
	add_child(asteroid)
	asteroid.connect("split_asteroid", split_asteroid)
	
	# Update asteroid-related lists
	asteroids_on_screen[asteroid.pitch_letter] = asteroid
	pitches_available.erase(asteroid.pitch)
	
	return asteroid

func spawn_asteroid(asteroid: Asteroid, pos: Vector2, do_update_space_available: bool):
	
	# Position this asteroid so that it spawns just out of sight
	var asteroid_radius = asteroid.collision_shape_2d.shape.radius
	
	asteroid.position = Vector2(
		pos.x + (sign(pos.x)) * asteroid_radius,
		pos.y + (sign(pos.y)) * asteroid_radius
	)
	
	# Update space available if set to true
	if do_update_space_available:
		update_space_available(false, asteroid.size)

func _on_timer_timeout():
	
	# Get available sizes based on available space
	sizes_available = check_space_available_for_possible_sizes()
	
	# Spawn one new asteroid if possible
	if pitches_available and sizes_available:
		var _asteroid = create_asteroid(
			randi_range(0, sizes_available.size() - 1)
		)
		spawn_asteroid(
			_asteroid, 
			spawn_points[randi_range(0, spawn_points.size() - 1)], 
			true
		)
	
func _on_note_pressed(played_note: String):
	if asteroids_on_screen.has(played_note):
		destroy_asteroid(asteroids_on_screen[played_note])

func destroy_asteroid(asteroid):
	emit_signal("asteroid_destroyed", asteroid)
	pitches_available.append(asteroid.pitch)
	asteroids_on_screen.erase(asteroid.pitch_letter)
	asteroid.explode()
	
	if asteroid.size == Asteroid.SizeType.SMALL:
		update_space_available(true, asteroid.size)

func check_space_available_for_possible_sizes() -> Array[Asteroid.SizeType]:
	
	# Return array of asteroid sizes based on how much space is left
	if space_available > 0:
		if space_available == 1:
			return [Asteroid.SizeType.SMALL]
		elif space_available <= 3:
			return [Asteroid.SizeType.SMALL, Asteroid.SizeType.MEDIUM]
		else:
			return [Asteroid.SizeType.SMALL, Asteroid.SizeType.MEDIUM, Asteroid.SizeType.LARGE]
	else:
		return []

func update_space_available(operation: bool, asteroid_size: Asteroid.SizeType) -> void:
	
	# Sets operation to addition if operation is true, subtraction if false
	var operation_value
	if operation:
		operation_value = 1
	else:
		operation_value = -1
	
	# Add or subtract to available_size
	match asteroid_size:
		Asteroid.SizeType.SMALL:
			space_available += 1 * operation_value
		Asteroid.SizeType.MEDIUM:
			space_available += 2 * operation_value
		Asteroid.SizeType.LARGE:
			space_available += 4 * operation_value

func split_asteroid(pos: Vector2, size: Asteroid.SizeType):
	match size:
		Asteroid.SizeType.LARGE:
			for i in range(2):
				var _asteroid = create_asteroid(
					Asteroid.SizeType.MEDIUM
				)
				spawn_asteroid(_asteroid, pos, false)
		Asteroid.SizeType.MEDIUM:
			for i in range(2):
				var _asteroid = create_asteroid(
					Asteroid.SizeType.SMALL
				)
				spawn_asteroid(_asteroid, pos, false)
				
#func spawn_asteroid(amount: int, pos: Vector2, size: Asteroid.SizeType) -> Asteroid:
	#
	## Instantiate asteroid and set vars
	#for i in range(amount):
		#var asteroid = asteroid_scene.instantiate()
		#asteroid.size = size
		#asteroid.pitch = pitches_available[randi_range(0, pitches_available.size()-1)]
		#add_child(asteroid)
		#asteroid.connect("split_asteroid", split_asteroid)
		#
		## Position this asteroid so that it spawns just out of sight
		#var asteroid_radius = asteroid.collision_shape_2d.shape.radius
		#asteroid.position = Vector2(
			#pos.x + (sign(pos.x)) * asteroid_radius,
			#pos.y + (sign(pos.y)) * asteroid_radius
		#)
		#
		## Update asteroid-related lists
		#asteroids_on_screen[asteroid.pitch_letter] = asteroid
		#pitches_available.erase(asteroid.pitch)
	#
		## Subtract space available if it is not at 0
		#return asteroid
