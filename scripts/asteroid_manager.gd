class_name AsteroidManager extends Control

@onready var midi_control: MidiControl = $"../MIDI Control"
@onready var asteroid_spawn_timer: Timer = $"Asteroid Spawn Timer"

@export var asteroid_scene := preload("res://scenes/asteroid.tscn")

var asteroids_on_screen: Dictionary = {}
var pitches_available: Array[int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
var sizes_available: Array
func _ready():
	midi_control.connect("note_pressed", _on_note_pressed)
	asteroid_spawn_timer.connect("timeout", _on_timer_timeout)
	#for i in range(12):
		#spawn_asteroid()
	
func spawn_asteroid():
	var asteroid = asteroid_scene.instantiate()
	asteroid.position = Vector2(randf_range(-256, 256), randf_range(-256, 256))
	asteroid.size = randi_range(0, Asteroid.SizeType.size() - 1)
	asteroid.pitch = pitches_available[randi_range(0, pitches_available.size()-1)]
	pitches_available.erase(asteroid.pitch)
	
	add_child(asteroid)
	asteroids_on_screen[asteroid.pitch_letter] = asteroid

func _on_note_pressed(played_note: String):
	if asteroids_on_screen.has(played_note):
		asteroids_on_screen[played_note].queue_free()
		asteroids_on_screen.erase(played_note)

func _on_timer_timeout():
	spawn_asteroid()
