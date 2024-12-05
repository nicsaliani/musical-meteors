class_name Asteroid 
extends Area2D
## An asteroid object that floats around 2D space.

## Asteroids are periodically spawned by the AsteroidManager when the game is
## in the PLAYING state. Before being put on screen, Asteroids are given a 
## size, a pitch, and a color, which is chosen based on the pitch. Upon
## reaching the edge of their parent viewport, they will loop to the opposite
## edge. Pressing the note on a MIDI controller that matches an Asteroid's
## pitch will destroy it, and the Asteroid will then spawn some particles.


## ---SIGNALS---
## Emitted when the Asteroid should be split into more Asteroids.
signal split_asteroid(pos, size)

## ---NODES AND CHILDREN---
## Reference to CollisionShape2D child node.
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

## Reference to Sprite2D child node -- the asteroid's main sprite.
@onready var asteroid_sprite_2d: Sprite2D = $AsteroidSprite2D

## Reference to SymbolSprite2D child node -- the asteroid's symbol sprite.
@onready var symbol_sprite_2d: Sprite2D = $SymbolSprite2D

## Reference to ParticleLayer node.
@onready var particle_layer: Control = get_node("../../ParticleLayer")

## reference to ScorePanel node.
@onready var score_panel := get_node("../../../../../ScorePanel")

## ---ENUMS---
## Enum for the Asteroid's size.
enum SizeType { SMALL, MEDIUM, LARGE }
@export var size: SizeType

## Enum for the Asteroid's pitch.
enum PitchType { C, CD, D, DE, E, F, FG, G, GA, A, AB, B }
@export var pitch: PitchType

## Enum for the Asteroid's accidental, displayed as a symbol.
enum AccidentalType { FLAT, SHARP, NATURAL }
@export var accidental: AccidentalType

## ---OTHER SCENES---
## Particle explosion scene. Spawned on destruction of Asteroid.
@export var particle_explode: PackedScene

## Explosion sprite scene. Spawned on destruction of Asteroid.
@export var meteor_explosion_effect: PackedScene

## Score popup scene. Spawned on destruction of Asteroid.
@export var score_popup: PackedScene

## ---GENERAL VARIABLES---
## The Asteroid's movement speed. Determined by its size.
var speed: int:
	get:
		match size:
			SizeType.SMALL:
				return 100
			SizeType.MEDIUM:
				return 75
			SizeType.LARGE:
				return 50
			_:
				return 0

## The Asteroid's point value awarded on destruction. Determined by its size.
var points: int:
	get:
		match size:
			SizeType.SMALL:
				return 25
			SizeType.MEDIUM:
				return 50
			SizeType.LARGE:
				return 100
			_:
				return 0

## Leftmost boundary at which an Asteroid will loop upon crossing.
var min_bound_x: float

## Rightmost boundary at which an Asteroid will loop upon crossing.
var max_bound_x: float

## Upward boundary at which an Asteroid will loop upon crossing.
var min_bound_y: float

## Downward boundary at which an Asteroid will loop upon crossing.
var max_bound_y: float

## The angle at which the Asteroid is sent upon spawning.
var rotate_value: float

## The Asteroid's direction of movement: straight.
var movement_vector := Vector2(0, -1)

## The angle of the Asteroid's sprite's rotation.
var rotate_angles: Array[float] = [0, 90, 180, 270]

## The Asteroid's pitch represented by a letter.
var pitch_letter: String

## Dictionary of Asteroid colors. They match the MIDI key colors.
var color_dict: Dictionary = {
	0: Color.html("#004de6"),
	1: Color.html("#809fff"),
	2: Color.html("#e6e617"),
	3: Color.html("#73e6ac"),
	4: Color.html("#00e6e6"),
	5: Color.html("#ff00ff"),
	6: Color.html("#c880ff"),
	7: Color.html("#00e600"),
	8: Color.html("#ff8080"),
	9: Color.html("#ff0000"),
	10: Color.html("#ffbf80"),
	11: Color.html("#ff8c19")
}

## ---FUNCTIONS---
## Sets variables and sprites.
func _ready() -> void:
	
	# Set pitch letter based on pitch
	pitch_letter = PitchType.keys()[pitch]
	
	# Set asteroid color based on pitch
	asteroid_sprite_2d.modulate = color_dict[pitch]
	
	# Set random rotation value
	rotate_value = randf_range(0, 2*PI)
	
	# Set all boundary values -- retrieved from AsteriodManager
	min_bound_x = get_parent().min_bound_x
	max_bound_x = get_parent().max_bound_x
	min_bound_y = get_parent().min_bound_y
	max_bound_y = get_parent().max_bound_y
	
	# Set asteroid sprite and collision shape based on size
	match size:
		SizeType.SMALL:
			asteroid_sprite_2d.texture = preload("res://assets/sprites/game/meteor_small.png")
			collision_shape_2d.shape = preload("res://resources/col_meteor_small.tres")
		SizeType.MEDIUM:
			asteroid_sprite_2d.texture = preload("res://assets/sprites/game/meteor_medium.png")
			collision_shape_2d.shape = preload("res://resources/col_meteor_medium.tres")
		SizeType.LARGE:
			asteroid_sprite_2d.texture = preload("res://assets/sprites/game/meteor_large.png")
			collision_shape_2d.shape = preload("res://resources/col_meteor_large.tres")
	
	# Set pitch symbol sprite based on pitch (random flip for accidentals)
	var _symbol_flip = 2
	match pitch:
		0:	# C
			symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_c.png")
		1:	# CD
			_symbol_flip = randi_range(0, 1)
			if _symbol_flip:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_cs.png")
			else:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_df.png")
		2:	# D
			symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_d.png")
		3:	# DE
			_symbol_flip = randi_range(0, 1)
			if _symbol_flip:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_ds.png")
			else:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_ef.png")
		4:	# E
			symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_e.png")
		5:	# F
			symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_f.png")
		6:	# FG
			_symbol_flip = randi_range(0, 1)
			if _symbol_flip:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_fs.png")
			else:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_gf.png")
		7:	# G
			symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_g.png")
		8:	# GA
			_symbol_flip = randi_range(0, 1)
			if _symbol_flip:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_gs.png")
			else:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_af.png")
		9:	# A
			symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_a.png")
		10:	# AB
			_symbol_flip = randi_range(0, 1)
			if _symbol_flip:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_as.png")
			else:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_bf.png")
		11:	# B
			symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_b.png")
	
	# Rotate sprite 0, 90, 180, or 270 degrees
	asteroid_sprite_2d.rotation_degrees = rotate_angles[randi_range(0, 3)]
	
	# Set accidental type based on symbol
	accidental = AccidentalType.values()[_symbol_flip]


## Processes movement and screen wrapping.
func _process(_delta: float) -> void:
	
	# X/Y Movement
	global_position += movement_vector.rotated(rotate_value) * speed * _delta
	
	# Radius of asteroid's collision shape used to calculate screen wrapping
	var _shape_radius = collision_shape_2d.shape.radius
	
	# Screen Wrap (X)
	if position.x + _shape_radius < min_bound_x:
		position.x = max_bound_x + _shape_radius
	elif position.x - _shape_radius > max_bound_x:
		position.x = min_bound_x - _shape_radius
		
	# Screen Wrap (Y)
	if position.y + _shape_radius < min_bound_y:
		position.y = max_bound_y + _shape_radius
	elif position.y - _shape_radius > max_bound_y:
		position.y = min_bound_y - _shape_radius


## Generates explosion for main gameplay.
func explode() -> void:
	
	# Emit split signal, spawn score popup, and spawn explosion effects
	split_asteroid.emit(position, size)
	spawn_score_popup()
	clear_with_explosion_effects()


## Generates xplosion for clearing meteors from screen on game over.
func clear_with_explosion_effects() -> void:
	
	# Spawn effects and delete self
	spawn_meteor_explosion_effect()
	spawn_meteor_explosion_particles()
	queue_free()


## Spawns an explosion effect sprite at Asteroid's location.
func spawn_meteor_explosion_effect() -> void:
	
	# Instantiate explosion effect sprite
	var _explosion_effect = meteor_explosion_effect.instantiate()
	_explosion_effect.position = position
	_explosion_effect.rotation = asteroid_sprite_2d.rotation_degrees
	
	# Add to particle layer
	particle_layer.add_child(_explosion_effect)


## Spawns a particle explosion effect at Asteroid's location.
func spawn_meteor_explosion_particles() -> void:

	# Instantiate explosion particles
	var _explosion = particle_explode.instantiate()
	_explosion.position = position
	_explosion.color = asteroid_sprite_2d.modulate
	_explosion.accidental = accidental
	
	# Add to particle layer
	particle_layer.add_child(_explosion)


## Spawns a score popup at Asteroid's location.
func spawn_score_popup() -> void:
	
	# Instantiate score popup
	var _score_popup = score_popup.instantiate()
	_score_popup.text = str(points)
	
	# Add to particle layer
	particle_layer.add_child(_score_popup)
	
	# Position score popup to center of Asteroid
	_score_popup.position = position - Vector2(
			_score_popup.size.x / 2,
			_score_popup.size.y / 2,
	)
