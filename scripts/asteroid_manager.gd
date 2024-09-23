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
	
func spawn_asteroid(amount: int, pos: Vector2, size: Asteroid.SizeType) -> Asteroid:
	
	# Instantiate asteroid and set vars
	var asteroid = asteroid_scene.instantiate()
	asteroid.size = size
	asteroid.pitch = pitches_available[randi_range(0, pitches_available.size()-1)]
	add_child(asteroid)
	
	# Position this asteroid so that it spawns just out of sight
	var asteroid_radius = asteroid.collision_shape_2d.shape.radius
	asteroid.position = Vector2(
		pos.x + (sign(pos.x)) * asteroid_radius,
		pos.y + (sign(pos.y)) * asteroid_radius
	)
	
	# Update asteroid-related lists
	asteroids_on_screen[asteroid.pitch_letter] = asteroid
	pitches_available.erase(asteroid.pitch)
	
	# Return the new asteroid to be used in other functions
	return asteroid

func _on_timer_timeout():
	
	# Get available sizes based on available space
	var sizes_available := check_space_available_for_possible_sizes()
	
	# Spawn one new asteroid if possible
	if pitches_available and sizes_available:
		var _asteroid = spawn_asteroid(
			1,
			spawn_points[randi_range(0, spawn_points.size() - 1)],
			randi_range(0, sizes_available.size() - 1)
		)
		update_space_available(false, _asteroid.size)
	print(space_available)
	print(check_space_available_for_possible_sizes())
	
func _on_note_pressed(played_note: String):
	if asteroids_on_screen.has(played_note):
		destroy_asteroid(asteroids_on_screen[played_note])
		asteroids_on_screen.erase(played_note)

func destroy_asteroid(asteroid):
	emit_signal("asteroid_destroyed", asteroid)
	asteroid.explode()
	pitches_available.append(asteroid.pitch)
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
	
