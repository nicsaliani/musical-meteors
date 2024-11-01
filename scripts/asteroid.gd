class_name Asteroid extends Area2D

## SIGNALS
## -------------------
signal split_asteroid(pos, size)

## ON-READY REFERENCES
## -------------------
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var asteroid_sprite_2d: Sprite2D = $AsteroidSprite2D
@onready var symbol_sprite_2d: Sprite2D = $SymbolSprite2D
@onready var particle_layer: Control = get_node("../../ParticleLayer")


## EXPORT REFERENCES
## -------------------
@export var particle_explode: PackedScene
@export var size: SizeType
@export var pitch: PitchType

## ENUMS
## -------------------
enum SizeType {SMALL, MEDIUM, LARGE}

enum PitchType {
	C,
	CD,
	D,
	DE,
	E,
	F,
	FG,
	G,
	GA,
	A,
	AB,
	B
}

enum AccidentalType {FLAT, SHARP, NATURAL}

## VARIABLES
## -------------------
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

var movement_vector := Vector2(0, -1)
var pitch_letter: String
var rotate_value: float
var rotate_angles: Array[float] = [
	0,
	90,
	180,
	270
]
var speed: int:
	get:
		match size:
			SizeType.SMALL:
				return 75
			SizeType.MEDIUM:
				return 50
			SizeType.LARGE:
				return 25
			_:
				return 0
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
var accidental: AccidentalType

var min_bound_x: float
var max_bound_x: float
var min_bound_y: float
var max_bound_y: float

## FUNCTIONS
## -------------------
func _ready() -> void:
	
	pitch_letter = PitchType.keys()[pitch]
	asteroid_sprite_2d.modulate = color_dict[pitch]
	rotate_value = randf_range(0, 2*PI)
	
	min_bound_x = get_parent().min_bound_x
	max_bound_x = get_parent().max_bound_x
	min_bound_y = get_parent().min_bound_y
	max_bound_y = get_parent().max_bound_y
	
	# Set asteroid sprite and collision shape based on size
	match size:
		SizeType.SMALL:
			asteroid_sprite_2d.texture = preload("res://assets/sprites/meteor_small.png")
			collision_shape_2d.shape = preload("res://resources/col_meteor_small.tres")
		SizeType.MEDIUM:
			asteroid_sprite_2d.texture = preload("res://assets/sprites/meteor_medium.png")
			collision_shape_2d.shape = preload("res://resources/col_meteor_medium.tres")
		SizeType.LARGE:
			asteroid_sprite_2d.texture = preload("res://assets/sprites/meteor_large.png")
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
	
	# Assign accidental type
	accidental = AccidentalType.values()[_symbol_flip]
	
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

func explode():
	
	split_asteroid.emit(position, size)
	
	var _explosion = particle_explode.instantiate()
	_explosion.position = position
	_explosion.color = asteroid_sprite_2d.modulate
	_explosion.accidental = accidental
	particle_layer.add_child(_explosion)

	queue_free()
